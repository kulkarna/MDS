USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeySelect]    Script Date: 12/09/2013 15:47:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  /**********************************************************************************************/
 /********************************* usp_MtMReportZkeySelect ************************************/
/**********************************************************************************************/

ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeySelect]
		@ISO	AS VARCHAR(50),
		@Zone	AS VARCHAR(50)
		
AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	*
	FROM	MtMReportZkey (nolock)
	WHERE	ISO = @ISO
	AND		Zone = @Zone

	SET NOCOUNT OFF;
END

