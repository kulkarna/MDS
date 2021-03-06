USE [lp_mtm]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMReportZkeyCountByCounterParty]    Script Date: 05/28/2013 16:14:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************/
 /********************** usp_MtMReportZkeyCountByCounterParty **********************************/
/**********************************************************************************************/
-- ===========================================================================
-- Author:		
-- Create date: 
-- Description:	Get ZKey Count By CounterParty
-- ===========================================================================
-- Modified:	Gail Mangaroo 
-- Modified date: 5/28/2013
-- Description:	Use LocationId and Iso id 
-- ===========================================================================
-- exec lp_mtm..[usp_MtMReportZkeyCountByCounterParty] 1
-- ===========================================================================
/**********************************************************************************************/
ALTER	PROCEDURE	[dbo].[usp_MtMReportZkeyCountByCounterParty]
		@CounterPartyID	AS INT		
		
AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	COUNT(DISTINCT z.ZkeyID) as CountZkeys, MIN(ltrim(rtrim(wso.WholesaleMktId)) + '- ' + pv.Value) AS ZKeyDescrition
	FROM	MtMReportZkey z (nolock)
	INNER JOIN MtMReportZkeyDetail zd (nolock)
		ON	z.ZkeyID = zd.ZkeyID
	INNER JOIN LibertyPower..WholesaleMarket wso (nolock) 
		ON	wso.ID = z.ISOId 
	LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
		ON pv.ID = z.ZainetLocationId			
	WHERE	zd.CounterPartyID = @CounterPartyID
	
	SET NOCOUNT OFF;
END
