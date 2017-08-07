USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteContractQualifier]    Script Date: 01/20/2014 13:08:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DeleteContractQualifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DeleteContractQualifier]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteContractQualifier]    Script Date: 01/20/2014 13:08:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------
-- Added		: Fernando ML Alves
-- Date			: 20/01/2014
-- Description	: Proc to delete a promotion code association from the ContractQualifier table (for 
--				  all accounts) based in the contractQualifierId. 
-- Format:		: exec usp_DeleteContractQualifier contractQualifierId
---------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_DeleteContractQualifier] (
	@p_contractQualifierId INT) AS 
BEGIN 
	SET NOCOUNT ON;

	DELETE FROM 
		ContractQualifier 
	WHERE 
		ContractQualifierId IN (
			SELECT 
				C2.ContractQualifierId
			FROM 
				ContractQualifier C1, ContractQualifier C2
			WHERE 
				C1.ContractId=C2.ContractId AND C1.QualifierId=C2.QualifierId
			AND
				C1.ContractQualifierId=@p_contractQualifierId
		);

	SET NOCOUNT OFF;	
END;

GO


