USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeyDetailUpdate]    Script Date: 12/09/2013 15:47:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 /*************************** usp_MtMReportZkeyDetailUpdate ************************************/
/**********************************************************************************************/

ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeyDetailUpdate]
		@ZkeyDetailID	AS INT,
		@Zkey			AS VARCHAR(50),
		@DateModified	AS DATETIME,
		@ModifiedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	
	UPDATE	MtMReportZkeyDetail
	SET		Zkey			= @Zkey,
			DateModified	= @DateModified,
			ModifiedBy		= @ModifiedBy
	WHERE	ZkeyDetailID	= @ZkeyDetailID
END

