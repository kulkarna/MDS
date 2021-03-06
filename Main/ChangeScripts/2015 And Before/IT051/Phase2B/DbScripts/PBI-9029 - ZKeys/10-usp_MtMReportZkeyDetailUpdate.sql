USE [lp_mtm]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeyDetailUpdate]    Script Date: 06/13/2013 03:02:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************** usp_MtMReportZkeyDetailUpdate ************************************/
/**********************************************************************************************/

ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeyDetailUpdate]
		@ZkeyDetailID	AS INT,
		@Zkey			AS VARCHAR(50),
		@DateModified	AS DATETIME = null,
		@ModifiedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	SET NOCOUNT ON;

	UPDATE	MtMReportZkeyDetail
	SET		Zkey			= @Zkey,
			DateModified	= GETDATE(),
			ModifiedBy		= @ModifiedBy
	WHERE	ZkeyDetailID	= @ZkeyDetailID

	SET NOCOUNT OFF;
END
