
USE [lp_enrollment]
GO

BEGIN TRANSACTION _STRUCTURE_
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- =======================================
-- Created 05/31/2012 Isabelle Tamanini
-- Autoapproves the POR contracts in credit check step
-- IT043
-- =======================================
-- Modified 06/20/2012 Isabelle Tamanini
-- Logic changed to only call approval_reject proc if
-- the approval status is not pending.
-- 1-18272496
-- =======================================
-- Modified 11/12/2012 Isabelle Tamanini
-- Added logic to autoapprove credit check
-- 1-29548571
-- =======================================
-- Modified 12/3/2012 Sheri Scott
-- Changed hard-coded utilities to a flage check.
-- Added AutoApproval column to Libertypower..Utility table.
-- 1-29548571
-- =======================================

ALTER PROCEDURE [dbo].[usp_ApproveCreditCheckForPOR]
	@contract_nbr as varchar(30)
AS
BEGIN
	
	DECLARE @check_request_id VARCHAR(25)
	DECLARE @comment          VARCHAR(max)
	DECLARE @process_id       VARCHAR(50)
	DECLARE @approval_status  CHAR(15)
	DECLARE @w_getdate datetime
	SELECT @w_getdate = getdate()
	DECLARE @w_error     char(01)
	DECLARE @w_msg_id    char(08)
		
	SET @check_request_id = (SELECT TOP 1 check_request_id
							 FROM lp_enrollment..check_account
							 WHERE contract_nbr = @contract_nbr)
	
	SET @comment = 'Contract: ' + @contract_nbr + '.  Residential accounts are automatically approved by the system.' -- when the credit check step is enabled for automatic processing.'
	
	IF NOT EXISTS (
		SELECT *
		FROM LibertyPower..Account a (NOLOCK)
		JOIN LibertyPower..AccountContract ac (NOLOCK) 
		ON a.AccountId = ac.AccountId
		JOIN LibertyPower..Contract c (NOLOCK) 
		ON c.ContractID = ac.ContractId
		JOIN LibertyPower..AccountContractRate acr (NOLOCK) 
		ON acr.accountcontractid = ac.accountcontractid
		JOIN LibertyPower..Price p (NOLOCK) 
		on acr.PriceId = p.Id
		JOIN LibertyPower..ProductBrand pb (NOLOCK) 
		on p.productbrandid = pb.productbrandid
		JOIN LibertyPower..Utility u (NOLOCK) on u.Id = a.UtilityId
		WHERE c.Number = @contract_nbr
		AND (a.BillingTypeID not in (1, 3) --UCB Rate Ready or UCB Bill Ready
		OR pb.IsCustom = 1
		OR u.AutoApproval = 0)
			  )
	BEGIN
		SET @comment = 'Credit check auto-approved, contract ' + @contract_nbr + ' meets the following criteria: UCB, Daily Fixed Pricing, Non-Recourse POR utility.'
		SET @approval_status = 'APPROVED'
	END
	ELSE IF EXISTS (
				SELECT *
				FROM LibertyPower..Account a (NOLOCK)
				JOIN LibertyPower..Contract c (NOLOCK) ON a.CurrentContractID = c.ContractID OR a.CurrentRenewalContractID = c.ContractID
				WHERE c.Number = @contract_nbr
				AND a.AccountTypeID <> 3 -- 3 is Residential
			  )
	BEGIN
		SET @comment = 'Contract: ' + @contract_nbr + '.  Credit Check step could not be autoapproved, there are non-Residential accounts in the contract.'
		SET @approval_status = 'PENDING'		
	END
	ELSE IF EXISTS (
				SELECT *
				FROM LibertyPower..Account a (NOLOCK)
				JOIN LibertyPower..Contract c (NOLOCK) ON a.CurrentContractID = c.ContractID OR a.CurrentRenewalContractID = c.ContractID
				WHERE c.Number = @contract_nbr
				AND a.BillingTypeID NOT IN (1,3)
			  )
	BEGIN
		SET @comment = 'Contract: ' + @contract_nbr + '.  Credit Check step could not be autoapproved, there are non-UCB billing type in the contract.'
		SET @approval_status = 'PENDING'
	END
	ELSE IF EXISTS (
				SELECT *
				FROM LibertyPower..Account a (NOLOCK)
				JOIN LibertyPower..Contract c (NOLOCK) ON a.CurrentContractID = c.ContractID OR a.CurrentRenewalContractID = c.ContractID
				JOIN LibertyPower..Utility u (NOLOCK) ON a.UtilityID = u.ID
				WHERE c.Number = @contract_nbr
				AND u.PorOption = 'NO'
			  )
	BEGIN
		SET @comment = 'Contract: ' + @contract_nbr + '.  Credit Check step could not be autoapproved, there are non-POR utilities in the contract.'
		SET @approval_status = 'PENDING'
	END
	ELSE
	BEGIN
		SET @comment = 'Contract: ' + @contract_nbr + '.  Residential accounts are automatically approved by the system.' -- when the credit check step is enabled for automatic processing.'
		SET @approval_status = 'APPROVED'
	END
	
	IF(@approval_status = 'PENDING')
	BEGIN
		UPDATE lp_enrollment..check_account
		SET approval_comments = @comment,
		    approval_status = @approval_status
		WHERE contract_nbr = @contract_nbr
		  AND check_type = 'CREDIT CHECK'
	END
	ELSE
	BEGIN
		SET @approval_status = 'APPROVED'
	
		EXEC [LibertyPower].[dbo].[usp_WIPTaskUpdateStatus] @p_username = N'System', @p_contract_nbr = @contract_nbr, @p_check_type =  N'CREDIT CHECK', 
			@p_approval_status = @approval_status, @p_comment = @comment, @p_check_request_id = @check_request_id
	END

END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT TRANSACTION _STRUCTURE_
GO

SET NOEXEC OFF
GO
