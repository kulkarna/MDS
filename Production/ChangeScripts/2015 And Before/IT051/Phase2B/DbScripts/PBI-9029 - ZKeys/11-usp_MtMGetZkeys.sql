USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetZkeys]    Script Date: 10/23/2013 10:43:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the list of all the Zkeys																			*
	 *  To Run:		exec usp_MtMGetZkeys																				*
 *	Modified: 10/03: Get the list of Zkeys alone																		*
 ************************************************************************************************************************/
ALTER	PROCEDURE [dbo].[usp_MtMGetZkeys]
AS

BEGIN

SET NOCOUNT ON; 

	SELECT	rzd.ZKeyDetailID, rzd.Zkey, rzd.StatusID, rz.ISOId, w.WholesaleMktId AS ISO, 
			/*ZainetLocationId, pv.Value*/ rz.Zone AS ZainetLocation, /*pv.InternalRefID as LocationInternalRefId, */
			rz.Year, BookId, rzd.CounterPartyID, rc.CounterParty, rc.BuySell
	FROM	MtMReportZkey rz (nolock)
	INNER	join MtMReportZkeyDetail rzd (nolock) 
	ON		rz.ZkeyID = rzd.ZkeyID 
	INNER	JOIN MtMReportCounterParty rc (nolock)
	ON		rzd.CounterPartyID = rc.CounterPartyID
	INNER	Join LibertyPower..WholesaleMarket w (nolock)
	ON		rz.ISOId = w.ID
	--INNER	JOIN LibertyPower..PropertyValue pv (nolock) 
	--ON		rz.ZainetLocationId = pv.ID
	
	WHERE	rz.Year >= YEAR(GETDATE())

	Order	by BookId, ISOId, ZainetLocationId, Year, CounterPartyID

SET NOCOUNT OFF; 

END
  