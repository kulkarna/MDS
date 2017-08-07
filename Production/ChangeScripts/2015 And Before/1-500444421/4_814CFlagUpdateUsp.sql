USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_814CFlagByUtilityUpdate]    Script Date: 03/11/2013 14:26:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_814CFlagByUtilityUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_814CFlagByUtilityUpdate]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_814CFlagByUtilityUpdate]    Script Date: 03/11/2013 14:26:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku John
-- Create date: 03-11-2013
-- Description:	Sets the 814C Flag for a utility
-- =============================================
CREATE PROCEDURE [dbo].[usp_814CFlagByUtilityUpdate]
	-- Add the parameters for the stored procedure here
	@utilityCode VARCHAR(50), 
	@flg814C bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Utility
	SET Flag814C = @flg814C
	WHERE UtilityCode = @utilityCode
END

GO


