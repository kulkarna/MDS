USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeyCountByCounterParty]    Script Date: 12/09/2013 15:46:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************/
 /********************** usp_MtMReportZkeyCountByCounterParty **********************************/
/**********************************************************************************************/

ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeyCountByCounterParty]
		@CounterPartyID	AS INT		
		
AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	COUNT(DISTINCT z.ZkeyID) as CountZkeys, MIN(z.ISO + '- ' + z.Zone) AS ZKeyDescrition
	FROM	MtMReportZkey z (nolock)
	INNER	JOIN MtMReportZkeyDetail zd (nolock)
	ON		z.ZkeyID = zd.ZkeyID
	WHERE	zd.CounterPartyID = @CounterPartyID
	
	SET NOCOUNT OFF;
END
