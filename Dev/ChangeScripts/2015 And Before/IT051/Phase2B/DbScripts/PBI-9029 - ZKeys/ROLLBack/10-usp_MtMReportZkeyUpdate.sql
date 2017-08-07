USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeyUpdate]    Script Date: 12/09/2013 15:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  /**********************************************************************************************/
 /********************************* usp_MtMReportZkeyUpdate ************************************/
/**********************************************************************************************/

ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeyUpdate]
		@ZkeyID			AS INT,
		--@ZoneAlias		AS VARCHAR(50),
		@DateModified	AS DATETIME,
		@ModifiedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	
	UPDATE	MtMReportZkey 
	SET		--ZoneAlias		= @ZoneAlias,
			ModifiedBy		= @ModifiedBy,
			DateModified	= @DateModified
	WHERE	ZkeyID			= @ZkeyID
END

