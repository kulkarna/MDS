USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetISO]    Script Date: 03/14/2013 10:24:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  /**********************************************************************************************/
 /*********************************************** usp_GetISO  **********************************/
/**********************************************************************************************/

ALTER PROCEDURE	[dbo].[usp_GetISO]
		
AS

BEGIN
	
	SET NOCOUNT ON

	SELECT	ID, WholesaleMktId as ISO
	FROM	WholesaleMarket (nolock)
	WHERE	InactiveInd = 0
	
	SET NOCOUNT OFF
END



GO


