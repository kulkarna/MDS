USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_renewed_upd]    Script Date: 11/02/2012 12:42:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/22/2007
-- Description:	Update account data with renewal data
--				This gets called by a job daily ( job_account_renewal_upd )
-- =============================================
-- Modified Gail Mangaroo 12/19/2007
-- Updated to use usp_document_history_copy_by_contract to copy documents 
-- =============================================
-- Modified Eric Hernandez 1/26/2009
-- Added parameter to allow the processing of a specific renewal 
-- =============================================
-- Modified José Muñoz 11/16/2009
-- Added instructions of tracking of the process to verify an error 
-- Ticket 8391 
-- =============================================
-- Modified Al Tafur 11/11/2010
-- Added filter for the parameter selection from the renewal table to account for TX contracts
-- that may have multiple new accounts with NULL usage.  The null value is for now converted to 0
-- since the account table does not allow nulls in the annual usage column
-- Ticket 19538 
-- =============================================
-- Modified Isabelle Tamanini 04/27/2011
-- Commented the part that changes the status of the accounts
-- Ticket 22726 
-- =============================================
-- Modified Isabelle Tamanini 03/01/2012
-- Converting usp to use the new tables
-- SR1-9607860
-- =============================================
-- Modified Cathy Ghazal 11/02/2012
-- use vw_AccountContractRate instead of AccountContractRate
-- MD084
-- =============================================


ALTER PROCEDURE [dbo].[usp_account_renewed_upd] 
	@p_account_id VARCHAR(30) = null

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @w_account_id					char(12)
DECLARE @w_status						varchar(15)
DECLARE @w_sub_status					varchar(15)
DECLARE @w_contract_nbr					char(12)
DECLARE @w_request_id					varchar(30)
DECLARE @w_error						varchar(5)
begin try

DECLARE  @processDate					datetime		/* ticket 8391*/
		,@processUser					varchar(50)		/* ticket 8391*/
		,@ErrorMessage					varchar(max)
		,@ErrorNumber					varchar(20)

SELECT @processDate					= getdate()			/* ticket 8391*/
	  ,@processUser					= suser_sname()		/* ticket 8391*/
	  ,@ErrorMessage				= ''
	  ,@ErrorNumber					= ''
	
insert into tblTracking_usp_account_renewed_upd values (@processDate, @p_account_id, 'Begin Process') /* ticket 8391*/

SET @w_error = 'FALSE'

---- If an account number was specified then we update the status which makes the renewal ready to be processed.
---- If an account number was not specified, then we are only processing renewals which are already effective.
IF (@p_account_id is not null)
BEGIN
	UPDATE AcctS
	SET [Status] = '07000',
		SubStatus = '20'
	FROM LibertyPower..Account A		   WITH (NOLOCK)   
	JOIN LibertyPower..AccountContract AC  WITH (NOLOCK) ON A.AccountID = AC.AccountID 
						 							    AND A.CurrentRenewalContractID = AC.ContractID
	JOIN LibertyPower..AccountStatus AcctS WITH (NOLOCK) ON AC.AccountContractID = AcctS.AccountContractID
	WHERE A.AccountIdLegacy = @p_account_id
	  AND AcctS.[Status] = '07000'
	  AND AcctS.SubStatus = '10'
	
	--UPDATE	account_renewal 
	--SET		sub_status = '20' 
	--WHERE	account_id = @p_account_id
	--AND		status = '07000' AND sub_status = '10'
	
	IF @@ERROR = 0
		insert into tblTracking_usp_account_renewed_upd values (@processDate, @p_account_id, 'UPDATE account_renewal OK !! ') /* ticket 8391*/	
END

-- account table -----------------------------------------------------------------------------
DECLARE RenewedCursor CURSOR FOR
SELECT A.AccountIdLegacy,
	   C.Number
FROM LibertyPower..Account A		       WITH (NOLOCK)
JOIN LibertyPower..[Contract] C		       WITH (NOLOCK) ON A.CurrentRenewalContractID = C.ContractID
JOIN LibertyPower..AccountContract AC      WITH (NOLOCK) ON A.AccountID = AC.AccountID 
					 							        AND C.ContractID = AC.ContractID
JOIN LibertyPower..AccountStatus AcctS     WITH (NOLOCK) ON AC.AccountContractID = AcctS.AccountContractID
JOIN LibertyPower..vw_AccountContractRate ACR WITH (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID
														--AND ACR.IsContractedRate = 1
WHERE lp_enrollment.dbo.ufn_date_only(ACR.RateStart) <= lp_enrollment.dbo.ufn_date_only(GETDATE())--update information immediately, per Douglas
  AND AcctS.[Status] = '07000' AND AcctS.SubStatus = '20'
  -- Ticket 16046 Begin	
  AND NOT EXISTS (SELECT 1
			      FROM LibertyPower..Account A2 WITH (NOLOCK)
				  JOIN LibertyPower.dbo.AccountUsage USAGE WITH (NOLOCK) ON A2.AccountID = USAGE.AccountID 
																		AND USAGE.EffectiveDate = C.StartDate  
				  WHERE A2.CurrentRenewalContractId = A.CurrentRenewalContractId
				    AND USAGE.AnnualUsage IS NULL
				    AND A2.RetailMktID <> 1) -- Texas
  -- Ticket 16046 End
  AND (@p_account_id IS NULL OR A.AccountIdLegacy = @p_account_id)

--SELECT     
--		a.account_id, a.contract_nbr
--FROM         
--	account_renewal a (NOLOCK)	--added NOLOCK by Hector Gomez 5/7/2010
--WHERE lp_enrollment.dbo.ufn_date_only(a.contract_eff_start_date) <= lp_enrollment.dbo.ufn_date_only(GETDATE())--update information immediately, per Douglas
--  AND a.[status] = '07000' AND a.sub_status = '20'
---- Ticket 16046 Begin	
--and not exists (select 1 from account_renewal b (NOLOCK) 
--				where b.contract_nbr		= a.contract_nbr
--				and b.annual_usage			is null 
--				and b.retail_mkt_id not in ('TX') ) -- Change AT 11/11/2010
---- Ticket 16046 End
--and (@p_account_id is null or account_id = @p_account_id)


OPEN RenewedCursor 

FETCH NEXT FROM RenewedCursor INTO 
	@w_account_id, @w_contract_nbr

WHILE (@@FETCH_STATUS = 0) 
BEGIN 

	BEGIN TRAN TransRenewal 

	SELECT @w_status = AcctS.[Status],
		   @w_sub_status = AcctS.SubStatus,
		   @w_request_id = C.Number
	FROM LibertyPower..Account A		   WITH (NOLOCK)
	JOIN LibertyPower..[Contract] C		   WITH (NOLOCK) ON A.CurrentContractID = C.ContractID
	JOIN LibertyPower..AccountContract AC  WITH (NOLOCK) ON A.AccountID = AC.AccountID 
						 							    AND A.CurrentContractID = AC.ContractID
	JOIN LibertyPower..AccountStatus AcctS WITH (NOLOCK) ON AC.AccountContractID = AcctS.AccountContractID
	WHERE A.AccountIdLegacy = @w_account_id
	
	--SELECT TOP 1 @w_request_id = account.contract_nbr
	--FROM account WITH (NOLOCK)
	--INNER JOIN account_renewal WITH (NOLOCK) ON account.account_number = account_renewal.account_number
	--WHERE account_renewal.contract_nbr = @w_contract_nbr
	
	--SELECT	@w_status = status, @w_sub_status = sub_status
	--FROM	account
	--WHERE	account_id = @w_account_id

	EXECUTE [lp_documents].[dbo].[usp_document_history_copy_by_contract]    @w_request_id  ,@w_contract_nbr ,'SYSTEM'
	insert into tblTracking_usp_account_renewed_upd values (@processDate, @w_account_id, 'EXECUTE [lp_documents].[dbo].[usp_document_history_copy_by_contract] OK !! ') /* ticket 8391*/	
	
	UPDATE libertypower..Account
	SET CurrentContractId = CurrentRenewalContractId,
		CurrentRenewalContractId = NULL
	WHERE AccountIdLegacy = @w_account_id
	
	UPDATE AcctS
	SET [Status] = @w_status,
		SubStatus = @w_sub_status
	FROM libertypower..AccountStatus AcctS
	JOIN libertypower..AccountContract AC ON AC.AccountContractId = AcctS.AccountContractId
	JOIN libertypower..Account A ON A.AccountId = AC.AccountId 
								AND A.CurrentContractId = AC.ContractID
	WHERE A.AccountIdLegacy = @w_account_id

	IF @@ERROR = 0
	BEGIN
		insert into tblTracking_usp_account_renewed_upd values (@processDate, @w_account_id, 'UPDATE account OK !! ') /* ticket 8391*/			
	END
	ELSE
	BEGIN
		SET @w_error		= 'TRUE'
		SET @ErrorMessage	= 'Problem, account table was not updated.'
		goto NextAccount
	END

	-- insert or update deutsche bank group
	EXEC		usp_account_deutsche_link_ins_upd @w_account_id

	NextAccount:

	IF @w_error = 'FALSE'
	BEGIN
		COMMIT TRAN TransRenewal
		insert into tblTracking_usp_account_renewed_upd values (@processDate, @w_account_id, 'COMMIT TRAN TransRenewal Process') /* ticket 8391*/
	END
	ELSE
	BEGIN
		ROLLBACK TRAN TransRenewal
		insert into tblTracking_usp_account_renewed_upd values (@processDate, @w_account_id, @ErrorMessage) /* ticket 8391*/	
		insert into tblTracking_usp_account_renewed_upd values (@processDate, @w_account_id, 'ROLLBACK TRAN TransRenewal Process') /* ticket 8391*/
	END

	FETCH NEXT FROM RenewedCursor INTO 

		@w_account_id, @w_contract_nbr
		
END

CLOSE RenewedCursor 
DEALLOCATE RenewedCursor

END TRY /* ticket 8391*/	


BEGIN CATCH /* ticket 8391*/	
	SET @ErrorMessage	= ltrim(rtrim(ERROR_MESSAGE()))			-- NEW (MUNOZ)
	SET @ErrorNumber	= ltrim(rtrim(str(ERROR_NUMBER())))		-- NEW (MUNOZ)
	IF (@@TRANCOUNT > 0)
	BEGIN
		ROLLBACK TRAN TransRenewal
	END
	INSERT INTO tblTracking_usp_account_renewed_upd values (@processDate, @w_account_id, left('Process Error: ' + @ErrorNumber + ' ' + @ErrorMessage, 300)) /* ticket 8391*/	
	INSERT INTO tblTracking_usp_account_renewed_upd values (@processDate, @w_account_id, 'ROLLBACK TRAN TransRenewal Process') /* ticket 8391*/
END CATCH; /* ticket 8391*/	

INSERT INTO tblTracking_usp_account_renewed_upd values (@processDate, @p_account_id, 'End Process') /* ticket 8391*/
