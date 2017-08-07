USE [lp_mtm]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMReportZkeyByIsoLocSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMReportZkeyByIsoLocSelect]
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/28/2013
-- Description:	ZKeys by ISo and Location IDs.
-- =============================================
-- exec [lp_mtm]..[usp_MtMReportZkeyByIsoLocSelect] 2 , 89819 , null  , null 
-- ==============================================
 CREATE	PROCEDURE	[dbo].[usp_MtMReportZkeyByIsoLocSelect]
		@ISOId	AS int,
		@LocationId	AS int = null, 
		@year int = null ,
		@bookID int = null 		
		
AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	*
	FROM	lp_mtm..MtMReportZkey z (nolock)
	WHERE	z.ISOId = @ISOID
		AND	isnull(z.ZainetLocationId, 0) = ISNULL( @LocationId ,isnull(z.ZainetLocationId, 0) ) 
		AND isnull(z.Year, 0) = ISNULL ( @year , isnull(z.Year, 0)) 
		AND isnull(z.BookId, 0) = ISNULL ( @bookID , isnull(z.BookId, 0)) 

	SET NOCOUNT OFF;
END
