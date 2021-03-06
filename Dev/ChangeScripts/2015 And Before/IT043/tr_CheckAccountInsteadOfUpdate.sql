USE [lp_enrollment]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 8/31/2012
-- Description:	Instead of trigger to handle backwards compatibility
-- =============================================

CREATE TRIGGER [dbo].[tr_CheckAccountInsteadOfUpdate]
   ON  [dbo].[check_account]
   INSTEAD OF UPDATE
AS 
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @pUsername NCHAR(100)
	DECLARE @pContractNumber CHAR(12)
	DECLARE @pCheckType CHAR(30)
	DECLARE @pCheckRequestId CHAR(15)
	DECLARE @pApprovalStatus CHAR(15)
	DECLARE @pComment VARCHAR(max)
	
	
	DECLARE inserted_cursor CURSOR FOR 
	SELECT  [contract_nbr],
			[check_type],
			[check_request_id],
			[approval_status],
			[approval_comments],
			[username]
	FROM inserted;
	
	OPEN inserted_cursor;
	
	FETCH NEXT FROM inserted_cursor 
	INTO @pContractNumber,
		 @pCheckType,
		 @pCheckRequestId,
		 @pApprovalStatus,
		 @pComment,
		 @pUsername;
	
	-- ================================================================================================================================================
	-- Global checks and trigger overrides
	-- ================================================================================================================================================
	
	-- ========================================
	-- tr_check_account_upd
	-- ========================================
	DECLARE @HasTaxDoc INT
	SET @HasTaxDoc = 0
	IF EXISTS (	SELECT history_id
				FROM lp_documents.dbo.document_history
				WHERE document_type_id = 9 AND contract_nbr = @pContractNumber)
		SET @HasTaxDoc = 1					

	-- Check if we need to insert a Tax Exemption Review step for the contract.  IT060
	IF @pCheckType = 'LETTER' AND @pApprovalStatus='APPROVED'
		AND EXISTS (SELECT * FROM lp_account..account 
					WHERE contract_nbr = @pContractNumber AND (original_tax_designation = 1 OR @HasTaxDoc = 1))
	BEGIN
		DECLARE @UtilityCode VARCHAR(50)
		SELECT TOP 1 @UtilityCode = U.UtilityCode
		FROM LibertyPower..Contract C (NOLOCK)
		JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.ContractId = C.ContractId
		JOIN LibertyPower..Account A (NOLOCK) ON A.AccountId = AC.AccountId
		JOIN LibertyPower..Utility U (NOLOCK) ON U.ID = A.UtilityId
		WHERE C.Number = @pContractNumber
		
		EXEC usp_tax_exemption_review_step @pContractNumber, @pCheckRequestId, @UtilityCode
	END
	-- ========================================
	-- END tr_check_account_upd
	-- ========================================

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DECLARE @pContractId INT		
		SELECT @pContractId = ContractID
		FROM LibertyPower..[Contract]
		WHERE Number = @pContractNumber
		
		IF NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTaskHeader
					   WHERE ContractId = @pContractId)
		BEGIN
			EXEC [LibertyPower].[dbo].[usp_WorkflowStartItem] @pContractNumber, @pUsername
		END
		ELSE
		BEGIN
			IF UPDATE(approval_status) 
			BEGIN
				--call approval reject
				
				EXEC [LibertyPower].[dbo].[usp_WIPTaskUpdateStatus] @pUsername, @pContractNumber, @pCheckType, 
					@pApprovalStatus, @pComment, @pCheckRequestId 
			END
		END
		
		FETCH NEXT FROM inserted_cursor 
		INTO @pContractNumber,
			 @pCheckType,
			 @pCheckRequestId,
			 @pApprovalStatus,
			 @pComment,
			 @pUsername;
		OPEN inserted_cursor;
	
	END
	
	CLOSE inserted_cursor;
	DEALLOCATE inserted_cursor;

END
