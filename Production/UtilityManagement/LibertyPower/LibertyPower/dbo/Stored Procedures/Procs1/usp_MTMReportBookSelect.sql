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
	SELECT * 
	FROM [lp_mtm].[dbo].[MtMReportBook] (NOLOCK) 
END 
