USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetISO]    Script Date: 12/09/2013 15:24:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  /**********************************************************************************************/
 /*********************************************** usp_GetISO  **********************************/
/**********************************************************************************************/

ALTER	PROCEDURE	[dbo].[usp_GetISO]
		
AS

BEGIN
	SELECT	WholesaleMktId as ISO
	FROM	WholesaleMarket (nolock)
	WHERE	InactiveInd = 0
	
END

