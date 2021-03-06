USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetISO]    Script Date: 05/29/2013 15:10:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  /**********************************************************************************************/
 /*********************************************** usp_GetISO  **********************************/
/**********************************************************************************************/
-- Modified 5/28/2013 Gail Mangaroo - Added ID
ALTER	PROCEDURE	[dbo].[usp_GetISO]
		
AS

BEGIN
	SET NOCOUNT ON;

	SELECT	WholesaleMktId as ISO, ID
	FROM	WholesaleMarket (nolock)
	WHERE	InactiveInd = 0
	
	SET NOCOUNT OFF;
END

