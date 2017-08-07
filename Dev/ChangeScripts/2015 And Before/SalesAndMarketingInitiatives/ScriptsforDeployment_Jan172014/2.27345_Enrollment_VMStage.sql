-------------------------------------------------------------------------
--SQL Scripts: promoCode
--1.  27345 add/update the Promo Code assigned to a given contract through the Account Detail screen
-----------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteContractQualifier]    Script Date: 12/24/2013 18:19:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DeleteContractQualifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DeleteContractQualifier]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteContractQualifier]    Script Date: 12/24/2013 18:19:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------
-- Added			: Fernando ML Alves
-- Date			: 20/12/2013
-- Description	: Proc to delete a promotion code association from the ContractQualifier table based 
--			      in the contractQualifierId.
-- Format:		: exec usp_DeleteContractQualifier contractQualifierId
---------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_DeleteContractQualifier] (
	@p_contractQualifierId INT) AS 
BEGIN 
	SET NOCOUNT ON;

	DELETE FROM ContractQualifier WHERE ContractQualifierId=@p_contractQualifierId;

	SET NOCOUNT OFF;	
END;

GO


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodesByContractNumberAndAccountNumberSelect]    Script Date: 12/24/2013 18:23:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromotionCodesByContractNumberAndAccountNumberSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromotionCodesByContractNumberAndAccountNumberSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodesByContractNumberAndAccountNumberSelect]    Script Date: 12/24/2013 18:23:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------
-- Added			: Fernando ML Alves
-- Date			: 20/12/2013
-- Description	: Proc that get the history of promotional codes, descriptions and status for a 
--				  given contract-account.
-- Format:		: exec usp_PromotionCodesByContractNumberAndAccountNumberSelect contractNumber,accountNumber
-- Test data:	: INSERT INTO LibertyPower..ContractQualifier (ContractId, AccountId, QualifierId, PromotionStatusId) VALUES (160271, 138080, 2, 2);
---------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_PromotionCodesByContractNumberAndAccountNumberSelect] (
	@p_contractNumber VARCHAR(50), @p_accountNumber VARCHAR(30)) AS 
BEGIN 
	SET NOCOUNT ON;

	SELECT
		PC.Code, PC.Description, PS.Description AS Status, CQ.ContractQualifierId
	FROM
		Contract AS C WITH (NOLOCK), 
		Account AS A WITH (NOLOCK),
		AccountContract AS AC WITH (NOLOCK),
		ContractQualifier AS CQ WITH (NOLOCK), 
		Qualifier AS Q WITH (NOLOCK),
		PromotionCode AS PC WITH (NOLOCK), 
		PromotionStatus AS PS WITH (NOLOCK)
	WHERE
		A.AccountID=AC.AccountId AND AC.AccountId=CQ.AccountId 
	AND
		AC.ContractID=C.ContractID
	AND
		AC.ContractID=CQ.ContractId AND CQ.QualifierId=Q.QualifierId
	AND
		CQ.PromotionStatusId=PS.PromotionStatusId AND Q.PromotionCodeId=PC.PromotionCodeId
	AND 
		C.Number=@p_contractNumber AND A.AccountNumber=@p_accountNumber 
	ORDER BY 
		CQ.CreatedDate DESC;

	SET NOCOUNT OFF;	
END;

GO

