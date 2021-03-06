USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_merge_by_account_TEST_JMUNOZ]    Script Date: 07/11/2013 14:11:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Hugo Ramos
-- Create date: 8/5/2010
-- Description:	Merge contracts by account
-- based on [usp_contract_merge]
-- =============================================
-- Modified: Guy Gelin 06/27/2013
-- Updated insert statement to accomodate null customerid values
-- SR# : 1-134761177
-- =============================================
-- Modified: Jose Muñoz 07/15/2013
-- Replace the view for tke legacy tables
-- SR# : 1-134761177
-- =============================================

ALTER PROCEDURE [dbo].[usp_contract_merge_by_account]

@p_contract_nbr_retain		char(12),
@p_account_nbr_merge_list	varchar(1000),
@p_utility_nbr_merge_list	varchar(1000)

AS
BEGIN 
	SET NOCOUNT ON

	DECLARE	@w_account_nbr								char(30)
			,@w_contract_nbr							char(30)
			,@w_contract_nbr_check_account				char(12)
			,@w_contract_nbr_err_list					varchar(1000)
			,@w_account_id								char(30)
			,@w_error									char(01)
			,@w_msg_id                                  char(08)
			,@w_descp                                   varchar(250)
			,@ProcessDate								DATETIME	-- Added JMUNOZ 07/15/2013 TK# 1-134761177
			,@ContractNumberRetainID					INTEGER		-- Added JMUNOZ 07/15/2013 TK# 1-134761177
			,@ContractIDOld								INTEGER		-- Added JMUNOZ 07/15/2013 TK# 1-134761177
			,@AccountIDAux								INTEGER		-- Added JMUNOZ 07/15/2013 TK# 1-134761177
			,@RateEnd									DATETIME	-- Added JMUNOZ 07/15/2013 TK# 1-134761177
							
	SELECT @w_error										= 'N'
			,@w_msg_id									= '00000001'
			,@w_descp									= ' '
			,@w_contract_nbr_err_list					= ''
			,@ProcessDate								= GETDATE()

	-----------------------------------------------------------------------
	--  BEGIN CHECK ACCOUNT STEP VERIFICATION  ----------------------------
	-----------------------------------------------------------------------
	DECLARE @Contracts		TABLE (	contract_nbr char(20))
	DECLARE @Accounts		TABLE (	account_id char(30))
	DECLARE @Utilities		TABLE (	utility_id char(20))

	INSERT @Utilities (utility_id)
		SELECT distinct value FROM lp_account.dbo.ufn_split_delimited_string (@p_utility_nbr_merge_list, ',')

	DECLARE cur CURSOR FAST_FORWARD FOR
		-- split contract number array
		SELECT value FROM lp_account.dbo.ufn_split_delimited_string (@p_account_nbr_merge_list, ',')
	    
	OPEN cur

	FETCH NEXT FROM cur INTO @w_account_nbr
	-- loop through contract numbers in array

	WHILE (@@FETCH_STATUS <> -1) 
	BEGIN 
		PRINT 'CONTA ' + @w_account_nbr
	--		INSERT @Contracts (contract_nbr) SELECT TOP 1 contract_nbr FROM lp_account..account WHERE account_number = @w_account_nbr AND contract_nbr IN (SELECT contract_nbr FROM @Contracts)
		/* COMMENTED TO USE THE LEGACY TABLE INSTEAD VIEW
		INSERT INTO @Accounts (account_id) 
		SELECT TOP 1 account_id FROM lp_account..account 
		WHERE account_number	= @w_account_nbr 
		AND utility_id			IN (SELECT utility_id FROM @Utilities)
		*/	
		
		INSERT INTO @Accounts (account_id) 
		SELECT TOP 1 AccountIdLegacy FROM Libertypower..Account WITH (NOLOCK) 
		WHERE AccountNumber				= @w_account_nbr 
		AND UtilityId					IN (SELECT ID FROM LibertyPower..Utility UT WITH (NOLOCK)
											WHERE UT.UtilityCode  IN ( SELECT DISTINCT utility_id FROM @Utilities))
		
		
		-- determine if contract is in a check account step
		/* COMMENTED TO USE THE LEGACY TABLE INSTEAD VIEW
		SELECT	@w_contract_nbr_check_account	= contract_nbr
		FROM	lp_enrollment..check_account WITH (NOLOCK)
		WHERE	contract_nbr					= (SELECT TOP 1 contract_nbr 
													FROM lp_account..account 
													WHERE account_number	= @w_account_nbr 
													AND utility_id			IN (SELECT utility_id 
																			FROM @Utilities))
		AND		LTRIM(RTRIM(approval_status)) NOT IN ('APPROVED', 'REJECTED')
		*/

		SELECT	@w_contract_nbr_check_account	= contract_nbr
		FROM	lp_enrollment..check_account CA WITH (NOLOCK)
		WHERE	CA.contract_nbr					= (SELECT TOP 1 NUMBER
													FROM Libertypower..Contract CC WITH (NOLOCK)
													INNER JOIN Libertypower..Account AA WITH (NOLOCK)
													ON AA.CurrentContractID		= CC.ContractID
													WHERE AA.AccountNumber		= @w_account_nbr 
													AND AA.UtilityID			IN (SELECT ID FROM LibertyPower..Utility UT WITH (NOLOCK)
																					WHERE UT.UtilityCode  IN ( SELECT DISTINCT utility_id FROM @Utilities)))
		AND		LTRIM(RTRIM(CA.approval_status)) NOT IN ('APPROVED', 'REJECTED')
		
		
		-- if so, then add to contract number string
		IF	@@ROWCOUNT > 0
		BEGIN
			PRINT 'ERROR CONTA ' + @w_account_nbr
			SET	@w_contract_nbr_err_list = 
			CASE WHEN LEN(@w_contract_nbr_err_list) = 0 THEN @w_contract_nbr_check_account 
			ELSE @w_contract_nbr_err_list + ', ' + @w_contract_nbr_check_account END
		END

		FETCH NEXT FROM cur INTO @w_account_nbr
	END
	CLOSE cur 
	DEALLOCATE cur

	--SELECT * FROM @Accounts

	-- if contract number(s) were found to be in a check account step,
	-- cancel merge and return error message
	IF	LEN(@w_contract_nbr_err_list)					> 0
	BEGIN
		SELECT	@w_error								= 'E'
		GOTO ERROR
	END
	-----------------------------------------------------------------------
	--  END CHECK ACCOUNT STEP VERIFICATION  ------------------------------
	-----------------------------------------------------------------------


	-----------------------------------------------------------------------
	--  BEGIN CONTRACT DATA UPDATES  --------------------------------------
	-----------------------------------------------------------------------
	BEGIN TRAN UpdateContractData
	-- insert contract numbers into look-up table, insert accounts into account_history, 
	-- update contract numbers in account table, and update contract numbers for associated documents

	--  CURSOR TO UPDATE ACCOUNT DATA  --------------------------------------
	DECLARE curAcc CURSOR FAST_FORWARD FOR
		SELECT account_id FROM @Accounts
	--SELECT account_id FROM account WHERE contract_nbr = @w_contract_nbr

	OPEN curAcc

	FETCH NEXT FROM curAcc INTO @w_account_id
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		-- check if accounts are in renewal process
		/*
		IF EXISTS(	SELECT	NULL
					FROM	lp_account..account_renewal WITH (NOLOCK)
					WHERE	account_id = @w_account_id )
		*/
		/* Added JMUNOZ 07/15/2013 TK# 1-134761177   */
		IF EXISTS(	SELECT	NULL
					FROM	libertypower..Account WITH (NOLOCK)
					WHERE	AccountIdLegacy  = @w_account_id 
					AND		NOT (CurrentRenewalContractID IS NULL))
		BEGIN
			ROLLBACK TRAN UpdateContractData
			SET	@w_error								= 'E'
			SET	@w_msg_id								= '00000003'
			CLOSE curAcc 
			DEALLOCATE curAcc
			CLOSE cur 
			DEALLOCATE cur
			GOTO ERROR
		END

		/* Commented to use the legacy tables instead the view "lp_account..Account"
		-- insert into account_history
		INSERT INTO	lp_account..account_history
					(account_id, account_number, account_type, status, sub_status, customer_id, entity_id, 
					contract_nbr, contract_type, retail_mkt_id, utility_id, product_id, rate_id, rate, 
					account_name_link, customer_name_link, customer_address_link, customer_contact_link, 
					billing_address_link, billing_contact_link, owner_name_link, service_address_link, 
					business_type, business_activity, additional_id_nbr_type, additional_id_nbr, 
					contract_eff_start_date, term_months, date_end, date_deal, date_created, date_submit, 
					sales_channel_role, username, sales_rep, origin, annual_usage, date_flow_start, 
					date_por_enrollment, date_deenrollment, date_reenrollment, tax_status, tax_rate, 
					credit_score, credit_agency, por_option, billing_type, chgstamp, date_inserted)
		SELECT		account_id, account_number, account_type, status, sub_status, isnull(customer_id,''), entity_id, 
					contract_nbr, contract_type, retail_mkt_id, utility_id, product_id, rate_id, rate, 
					account_name_link, customer_name_link, customer_address_link, customer_contact_link, 
					billing_address_link, billing_contact_link, owner_name_link, service_address_link, 
					business_type, business_activity, additional_id_nbr_type, additional_id_nbr, 
					contract_eff_start_date, term_months, date_end, date_deal, date_created, date_submit, 
					sales_channel_role, username, sales_rep, origin, annual_usage, date_flow_start, 
					date_por_enrollment, date_deenrollment, date_reenrollment, tax_status, tax_rate, 
					credit_score, credit_agency, por_option, billing_type, chgstamp, GETDATE()
		FROM		lp_account..account
		WHERE		account_id = @w_account_id
		*/

		/* New Insert using legacy tables				*/
		/* Added JMUNOZ 07/15/2013 TK# 1-134761177		*/
		INSERT INTO	lp_account..account_history
					(account_id, account_number, account_type, status, sub_status, customer_id, entity_id, 
					contract_nbr, contract_type, retail_mkt_id, utility_id, product_id, rate_id, rate, 
					account_name_link, customer_name_link, customer_address_link, customer_contact_link, 
					billing_address_link, billing_contact_link, owner_name_link, service_address_link, 
					business_type, business_activity, additional_id_nbr_type, additional_id_nbr, 
					contract_eff_start_date, term_months, date_end, date_deal, date_created, date_submit, 
					sales_channel_role, username, sales_rep, origin, annual_usage, date_flow_start, 
					date_por_enrollment, date_deenrollment, date_reenrollment, tax_status, tax_rate, 
					credit_score, credit_agency, por_option, billing_type, chgstamp, date_inserted)
		SELECT A.AccountIdLegacy
			,A.AccountNumber	
			,CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END
			,[Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus)
			,[Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(ACS.[Status], ACS.SubStatus)
			,A.CustomerIdLegacy
			,A.EntityID
			,C.Number
			,[Libertypower].[dbo].[ufn_GetLegacyContractType] ( CT.[Type] , CTT.ContractTemplateTypeID, CDT.DealType)
			,M.MarketCode
			,U.UtilityCode
			,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END
			,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID ELSE AC_DefaultRate.RateID END
			,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate ELSE AC_DefaultRate.Rate END
			,ISNULL(AddConNam.account_name_link,0)
			,ISNULL(AddConNam.customer_name_link,0)
			,ISNULL(AddConNam.customer_address_link,0)
			,ISNULL(AddConNam.customer_contact_link,0)
			,ISNULL(AddConNam.billing_address_link,0)
			,ISNULL(AddConNam.billing_contact_link,0)
			,ISNULL(AddConNam.owner_name_link,0)	
			,ISNULL(AddConNam.service_address_link,0)
			,LEFT(UPPER(isnull(BT.[Type],'NONE')),35)
			,LEFT(UPPER(isnull(BA.Activity,'NONE')),35)
			,LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbrType(CUST.Duns, CUST.EmployerId, CUST.TaxId, CUST.SsnEncrypted )
			,LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbr(CUST.Duns, CUST.EmployerId, CUST.TaxId, CUST.SsnEncrypted )
			,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END 
			,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term		ELSE AC_DefaultRate.Term	  END 
			,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END 
			,C.SignedDate			
			,A.DateCreated			
			,C.SubmitDate			
			,'SALES CHANNEL/' + SC.ChannelName 
			,USER1.UserName			
			,C.SalesRep		
			,A.Origin		
			,ISNULL(USAGE.AnnualUsage, (SELECT TOP 1 ISNULL(AnnualUsage, 0) FROM LibertyPower..AccountUsage WITH (NOLOCK) WHERE AccountID = A.AccountID ORDER BY EffectiveDate DESC))
			,LibertyPower.dbo.ufn_GetLegacyFlowStartDate(ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate )
			,AC.SendEnrollmentDate
			,LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (ACS.[Status], ACS.[SubStatus], ASERVICE.EndDate )
			,CAST('1900-01-01 00:00:00' AS DATETIME)
			,UPPER(TAX.[Status])
			,CAST(0 AS INT)
			,CAST(0 AS INT)
			,CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END
			,CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END
			,BILLTYPE.[Type]
			,CAST(0 AS INT)	
			,@ProcessDate
		FROM LibertyPower.dbo.Account A WITH (NOLOCK)
		JOIN LibertyPower.dbo.AccountDetail DETAIL	 WITH (NOLOCK)	ON DETAIL.AccountID = A.AccountID
		JOIN LibertyPower.dbo.[Contract] C	WITH (NOLOCK)				ON A.CurrentContractID = C.ContractID
		JOIN LibertyPower.dbo.AccountContract AC	WITH (NOLOCK)		ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
		JOIN LibertyPower.dbo.AccountContractCommission ACC	WITH (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID
		JOIN LibertyPower.dbo.AccountStatus ACS	WITH (NOLOCK)			ON AC.AccountContractID = ACS.AccountContractID
		JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
		LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
				   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
				   WHERE ACRR.IsContractedRate = 0 
				   GROUP BY ACRR.AccountContractID
				  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
		 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
		JOIN LibertyPower.dbo.ContractType CT			WITH (NOLOCK)	ON C.ContractTypeID = CT.ContractTypeID
		JOIN LibertyPower.dbo.Customer CUST				WITH (NOLOCK)	ON A.CustomerID = CUST.CustomerID
		JOIN LibertyPower.dbo.ContractTemplateType CTT	WITH (NOLOCK)	ON C.ContractTemplateID= CTT.ContractTemplateTypeID
		JOIN LibertyPower.dbo.AccountType AT			WITH (NOLOCK)	ON A.AccountTypeID = AT.ID
		JOIN LibertyPower.dbo.Utility U			WITH (NOLOCK)			ON A.UtilityID = U.ID
		JOIN LibertyPower.dbo.Market M			WITH (NOLOCK)			ON A.RetailMktID = M.ID
		LEFT JOIN lp_account.dbo.[vw_AccountAddressNameContactIds] AddConNam ON A.AccountID = AddConNam.AccountID -- this way boosts 100ms less
		LEFT JOIN LibertyPower.dbo.BusinessType BT		WITH (NOLOCK)		ON CUST.BusinessTypeID = BT.BusinessTypeID
		LEFT JOIN LibertyPower.dbo.BusinessActivity BA	WITH (NOLOCK)		ON CUST.BusinessActivityID = BA.BusinessActivityID
		LEFT JOIN LibertyPower.dbo.SalesChannel SC		WITH (NOLOCK)		ON C.SalesChannelID = SC.ChannelID
		LEFT JOIN LibertyPower.dbo.TaxStatus TAX		WITH (NOLOCK)		ON A.TaxStatusID = TAX.TaxStatusID
		LEFT JOIN LibertyPower.dbo.CreditAgency CA		WITH (NOLOCK)		ON CUST.CreditAgencyID = CA.CreditAgencyID	
		LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE	WITH (NOLOCK)		ON A.BillingTypeID = BILLTYPE.BillingTypeID
		LEFT JOIN LibertyPower.dbo.MeterType MT			WITH (NOLOCK)		ON A.MeterTypeID = MT.ID 
		LEFT JOIN LibertyPower.dbo.ContractDealType CDT		WITH (NOLOCK)	ON C.ContractDealTypeID = CDT.ContractDealTypeID
		LEFT JOIN LibertyPower.dbo.AccountUsage USAGE	WITH (NOLOCK)		ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate
		LEFT JOIN LibertyPower.dbo.UsageReqStatus URS	WITH (NOLOCK)		ON USAGE.UsageReqStatusID = URS.UsageReqStatusID
		LEFT JOIN LibertyPower.dbo.[User] ManagerUser  WITH (NOLOCK)	ON C.SalesManagerID = ManagerUser.UserID
		LEFT JOIN LibertyPower.dbo.[User] USER1		WITH (NOLOCK)		ON C.CreatedBy = USER1.UserID
		LEFT JOIN LibertyPower.dbo.[User] USER2		WITH (NOLOCK)		ON A.ModifiedBy = USER2.UserID
		LEFT JOIN LibertyPower.dbo.[User] USER3		WITH (NOLOCK)		ON A.CreatedBy = USER3.UserID
		LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
		WHERE A.AccountIdLegacy = @w_account_id

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN UpdateContractData
			SET	@w_error								= 'E'
			SET	@w_msg_id								= '00000002'
			CLOSE curAcc 
			DEALLOCATE curAcc
	--				CLOSE cur 
	--				DEALLOCATE cur
			GOTO ERROR
		END

	   IF NOT EXISTS (	SELECT	account_id
						FROM	lp_account..account_comments WITH (NOLOCK)
						WHERE	account_id					= @w_account_id
						AND		process_id					= 'CONTRACT MERGE')
		begin
			INSERT INTO	lp_account..account_comments		
			SELECT		@w_account_id, GETDATE(), 'CONTRACT MERGE', 'Merging with Contract ' + @p_contract_nbr_retain, (SELECT username FROM lp_account..account WHERE account_id = @w_account_id), 0
		END

		FETCH NEXT FROM curAcc INTO @w_account_id
	END
	CLOSE curAcc 
	DEALLOCATE curAcc

	/* -- Added JMUNOZ 07/15/2013 TK# 1-134761177 003 Begin */
	SELECT TOP 1 @ContractNumberRetainID	= CC.ContractID 
		,@RateEnd							= ACR.RateEnd 
	FROM Libertypower..Contract CC WITH (NOLOCK)
	INNER JOIN LibertyPower..AccountContract AC WITH (NOLOCK)
	ON AC.ContractID						=  CC.ContractID
	INNER JOIN LibertyPower..AccountContractRate ACR WITH (NOLOCK)
	ON ACR.AccountContractID				= AC.AccountContractID 
	WHERE CC.Number							= @p_contract_nbr_retain 
	ORDER BY ACR.RateEnd DESC
	/* -- Added JMUNOZ 07/15/2013 TK# 1-134761177 003 End */

	----  CURSOR TO UPDATE CONTRACT DATA  --------------------------------------
	/*COMMENTED TO USE THE LEGACY TABLE INSTEAD VIEW
	DECLARE cur FAST_FORWARD CURSOR FOR
	-- split contract number array
	--SELECT DISTINCT contract_nbr FROM @Contracts
	SELECT DISTINCT contract_nbr FROM lp_account..account WITH (NOLOCK) 
	WHERE account_id IN (SELECT account_id FROM @Accounts) 
	AND utility_id IN (SELECT utility_id FROM @Utilities)
	*/

	DECLARE cur CURSOR FAST_FORWARD FOR
	-- split contract number array
	SELECT DISTINCT CC.NUMBER, CC.ContractID, AA.AccountID
	FROM Libertypower..Contract CC WITH (NOLOCK)
	INNER JOIN Libertypower..Account AA WITH (NOLOCK)
	ON AA.CurrentContractID		= CC.ContractID
	WHERE AA.AccountIDLegacy	IN (SELECT account_id FROM @Accounts) 
	AND AA.UtilityID			IN (SELECT ID FROM LibertyPower..Utility UT WITH (NOLOCK)
									WHERE UT.UtilityCode  IN ( SELECT DISTINCT utility_id FROM @Utilities))

	OPEN cur
	
	/* FETCH NEXT FROM cur INTO @w_contract_nbr */
	FETCH NEXT FROM cur INTO @w_contract_nbr, @ContractIDOld, @AccountIDAux
	
	-- loop through contract numbers in array
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		-- insert into look-up table
		IF NOT EXISTS (	SELECT	NULL
						FROM	lp_account..contract_merge WITH (NOLOCK)
						WHERE	contract_nbr_retain = @p_contract_nbr_retain 
						AND		contract_nbr_merge	= @w_contract_nbr)
		BEGIN
			INSERT INTO	lp_account..contract_merge	(contract_nbr_retain, contract_nbr_merge)
			VALUES (@p_contract_nbr_retain, @w_contract_nbr)

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN UpdateContractData
				SET	@w_error								= 'E'
				SET	@w_msg_id								= '00000002'
				CLOSE cur 
				DEALLOCATE cur
				GOTO ERROR
			END
		END

		/*
		-- update contract numbers and end dates
		UPDATE	lp_account..account
		SET		contract_nbr	= @p_contract_nbr_retain,
				date_end		= (SELECT TOP 1 date_end FROM lp_account..account WHERE contract_nbr = @p_contract_nbr_retain)
		WHERE	contract_nbr	= @w_contract_nbr AND account_id IN (SELECT account_id FROM @Accounts)
		*/

		/* -- Added JMUNOZ 07/15/2013 TK# 1-134761177 004 Begin */
		/* Update the Contract reference */
		UPDATE Libertypower..AccountContract
		SET ContractID				= @ContractNumberRetainID 
		WHERE ContractID			= @ContractIDOld 
		AND AccountID				= @AccountIDAux 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN UpdateContractData
			SET	@w_error								= 'E'
			SET	@w_msg_id								= '00000002'
			CLOSE cur 
			DEALLOCATE cur
			GOTO ERROR
		END
		
		/* Update the Date End */
		UPDATE Libertypower..AccountContractRate 
		SET RateEnd					= @RateEnd 
		FROM Libertypower..AccountContractRate ACR WITH (NOLOCK)
		WHERE ACR.AccountContractRateID		= (	SELECT MAX(ZZ.AccountContractRateID) 
												FROM Libertypower..AccountContractRate ZZ WITH (NOLOCK)
												INNER JOIN LibertyPower..AccountContract AC WITH (NOLOCK)
												ON AC.AccountContractID			= ZZ.AccountContractID 
												WHERE  AC.AccountID				= @AccountIDAux
												AND AC.ContractID				= @ContractNumberRetainID)

		/* -- Added JMUNOZ 07/15/2013 TK# 1-134761177 004 End*/

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN UpdateContractData
			SET	@w_error								= 'E'
			SET	@w_msg_id								= '00000002'
			CLOSE cur 
			DEALLOCATE cur
			GOTO ERROR
		END

	--		-- update contract numbers for associated documents
	--		UPDATE	lp_documents..documents_upload
	--		SET		request_id		= @p_contract_nbr_retain
	--		WHERE	request_id		= @w_contract_nbr

		EXECUTE [lp_documents].[dbo].[usp_document_history_copy_by_contract]    @w_contract_nbr  ,@p_contract_nbr_retain ,'SYSTEM'


		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN UpdateContractData
			SET	@w_error								= 'E'
			SET	@w_msg_id								= '00000002'
			CLOSE cur 
			DEALLOCATE cur
			GOTO ERROR
		END

		/* FETCH NEXT FROM cur INTO @w_contract_nbr */
		FETCH NEXT FROM cur INTO @w_contract_nbr, @ContractIDOld, @AccountIDAux
		
	END
	CLOSE cur 
	DEALLOCATE cur


	--select * from lp_account..account
	--where contract_nbr in (
	--'010000879   ',
	--'010001477   '
	----'01001135    ',
	----'01001336    '
	--)
	--order by contract_nbr
	--select * from lp_account..account_history where account_id in ('2010-0040335   ','2010-0040340    ', '2010-0040336   ')

	COMMIT TRAN UpdateContractData
	-----------------------------------------------------------------------
	--  END CONTRACT DATA UPDATES  ----------------------------------------
	-----------------------------------------------------------------------


	ERROR:
	IF	@w_error										<> 'N'
	BEGIN
		EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp output, 'ENROLLMENT'
	END
	 
	SELECT	error										= @w_error,
			msg_id										= @w_msg_id,
			descp										= 
			CASE WHEN @w_msg_id = '00000001' THEN (@w_descp + ' Contract(s): ' + @w_contract_nbr_err_list) 
			WHEN @w_msg_id = '00000003' THEN @w_descp + ' Account: ' + @w_account_id ELSE @w_descp END

	SET NOCOUNT OFF

END
