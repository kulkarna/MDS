USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeyUpdate]    Script Date: 06/13/2013 02:41:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  /**********************************************************************************************/
 /********************************* usp_MtMReportZkeyUpdate ************************************/
/**********************************************************************************************/
-- =============================================
-- Author:		
-- Create date: 
-- Description:	Update ZKeys
-- =============================================
-- Modified:	Gail Mangaroo 
-- Modified date: 6/13/2013
-- Description:	Ignore DateModified parameter
-- =============================================
-- exec 
-- ============================================
ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeyUpdate]
		@ZkeyID			AS INT,
		--@ZoneAlias		AS VARCHAR(50),
		@DateModified	AS DATETIME = null ,
		@ModifiedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	SET NOCOUNT ON;

	UPDATE	MtMReportZkey 
	SET		--ZoneAlias		= @ZoneAlias,
			ModifiedBy		= @ModifiedBy,
			DateModified	= GETDATE()
	WHERE	ZkeyID			= @ZkeyID

	SET NOCOUNT OFF;
END

