USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountExistsInOfferEngine]    Script Date: 10/30/2013 18:47:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountExistsInOfferEngine]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountExistsInOfferEngine]
GO

USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountExistsInOfferEngine]    Script Date: 10/30/2013 18:47:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 10/30/2013 6:30 PM
-- Description:	Checks if account exists in offer engine
-- =============================================
CREATE PROCEDURE [dbo].[usp_AccountExistsInOfferEngine]
	-- Add the parameters for the stored procedure here
	@AccountNumber VARCHAR(50), 
	@UtilityCode VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (EXISTS(SELECT ID FROM OE_ACCOUNT (NOLOCK) WHERE ACCOUNT_NUMBER = @AccountNumber AND UTILITY=@UtilityCode))
		SELECT 1 AS 'Exists'
	ELSE
		SELECT 0 AS 'Exists'
END

GO


