USE lp_mtm
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MTMReportBookSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MTMReportBookSelect]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo 
-- Create date: 5/23/2013
-- Description:	Get list of report book 
-- =============================================
-- exec 
-- ============================================
CREATE PROCEDURE usp_MTMReportBookSelect
AS 
BEGIN 

	SET NOCOUNT ON;

	SELECT * 
	FROM [lp_mtm].[dbo].[MtMReportBook] (NOLOCK) 

	SET NOCOUNT OFF;
END 
GO


