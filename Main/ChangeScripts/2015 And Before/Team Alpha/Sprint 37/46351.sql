USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountTypeDescription]    Script Date: 08/11/2014 10:04:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAccountTypeDescriptionforproductAccountTypeId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAccountTypeDescriptionforproductAccountTypeId]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountTypeDescription]    Script Date: 08/11/2014 10:04:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 8/11/2014
-- Description:Get the AccoumntType CODE for the given productAccountTypeID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetAccountTypeDescriptionforproductAccountTypeId]
	@p_AccountTypeId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		AccountType
	From 
		LibertyPower.dbo.AccountType A with (nolock)		
	Where 
		A.ProductAccountTypeID=@p_AccountTypeId
		
	SET NOCOUNT OFF;
END


GO


