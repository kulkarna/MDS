USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetIT059MigrationData]    Script Date: 08/19/2013 10:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetIT059MigrationData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetIT059MigrationData]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetIT059MigrationData]    Script Date: 08/19/2013 10:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku John
-- Create date: 8/21/2013
-- Description:	Getting all IT059 migration data

/*

*/
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetIT059MigrationData]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	SET NOCOUNT ON;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
	
	exec usp_GetIT059MigrationDataMissingEnrolled
	
	SET NOCOUNT OFF
END




GO
