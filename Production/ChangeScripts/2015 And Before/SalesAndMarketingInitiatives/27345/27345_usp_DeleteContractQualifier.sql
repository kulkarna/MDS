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


