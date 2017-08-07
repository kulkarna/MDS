USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Send814cUtilitiesSelect]    Script Date: 04/04/2013 12:43:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Send814cUtilitiesSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Send814cUtilitiesSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Send814cUtilitiesSelect]    Script Date: 04/04/2013 12:43:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 03-12-2013
-- Description:	Gets all Utilities where Flag814C is set to 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_Send814cUtilitiesSelect]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UtilityCode
	FROM Utility 
	Where Flag814C = 1
END

GO


