USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------
-- Added			: Fernando ML Alves
-- Date			: 07/12/2013
-- Description	: Proc to get the history of promotional codes, descriptions and status for a given account
-- Format:		: exec usp_PromotionCodesByContractNumberAndAccountNumberSelect contractNumber,accountNumber
-- Test data:	: INSERT INTO LibertyPower..ContractQualifier (ContractId, AccountId, QualifierId, PromotionStatusId) VALUES (160271, 138080, 2, 2);
---------------------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_PromotionCodesByContractNumberAndAccountNumberSelect (
	@p_contractNumber VARCHAR(50), @p_accountNumber VARCHAR(30)) AS 
BEGIN 
	SET NOCOUNT ON;

	DECLARE @contractId INT;
	DECLARE @accountId INT;

	SELECT @contractId = ContractID FROM Contract WITH (NOLOCK) WHERE Number=@p_contractNumber;
	SELECT @accountId = AccountID FROM Account WITH (NOLOCK) WHERE AccountNumber=@p_accountNumber;

	SELECT
		PC.Code, PC.Description, PS.Description AS Status
	FROM 
		AccountContract AS AC WITH (NOLOCK),
		ContractQualifier AS CQ WITH (NOLOCK), 
		Qualifier AS Q WITH (NOLOCK),
		PromotionCode AS PC WITH (NOLOCK), 
		PromotionStatus AS PS WITH (NOLOCK)
	WHERE
		AC.ContractID=CQ.ContractId 
	AND
		AC.AccountId=CQ.AccountId 
	AND 
		CQ.QualifierId=Q.QualifierId
	AND
		CQ.PromotionStatusId=PS.PromotionStatusId
	AND
		Q.PromotionCodeId=PC.PromotionCodeId
	AND
		AC.ContractID=@contractId AND AC.AccountID=@accountId
	ORDER BY 
		CQ.CreatedDate DESC;

	SET NOCOUNT OFF;	
END;
GO