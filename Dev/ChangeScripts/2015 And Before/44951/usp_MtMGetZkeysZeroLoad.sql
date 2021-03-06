USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetZkeysZeroLoad]    Script Date: 08/07/2014 16:33:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	7/31/2014																								*
 *	Descp:		get the Zkeys that were not updated today																*
 *  To Run:		exec usp_MtMGetZkeysZeroLoad '12/31/2013'	
  *	Modified:																											*
 ************************************************************************************************************************/

ALTER PROCEDURE   [dbo].[usp_MtMGetZkeysZeroLoad] (
				@RunDate AS DATE)
AS

BEGIN

SET NOCOUNT ON; 

--SET @RunDate = '12/31/2013'
	DECLARE @RunDateYesterday AS DATETIME
	SET		@RunDateYesterday = (SELECT MAX(Rundate) FROM MtMZainetDailyData (nolock) WHERE Rundate < @RunDate)


	SELECT	DISTINCT ZKey
	INTO	#Yesterday
	FROM	MtMZainetDailyData dd (nolock)
	WHERE	RunDate = @RunDateYesterday

	CREATE CLUSTERED INDEX idx_Zkey_Y ON #Account (#Yesterday) 

	SELECT	DISTINCT ZKey
	INTO	#Today
	FROM	MtMZainetDailyData dd (nolock)
	WHERE	RunDate = @RunDate

	CREATE CLUSTERED INDEX idx_Zkey_T ON #Account (#Today) 

	SELECT	DISTINCT y.Zkey
	INTO	#Zkeys
	FROM	#Yesterday y
	LEFT	Join #Today t
	ON		y.Zkey = t.Zkey
	WHERE	t.Zkey IS NULL

	CREATE CLUSTERED INDEX idx_Zkey_Z ON #Account (#Zkeys) 

	SELECT	rzd.ZKeyDetailID, rzd.Zkey, rzd.StatusID, rz.ISOId, w.WholesaleMktId AS ISO, 
			rz.Zone AS ZainetLocation, rz.Year, BookId, rzd.CounterPartyID, rc.CounterParty, rc.BuySell
	FROM	MtMReportZkey rz (nolock)
	INNER	join MtMReportZkeyDetail rzd (nolock) 
	ON		rz.ZkeyID = rzd.ZkeyID 
	INNER	JOIN #Zkeys z
	ON		rzd.Zkey = z.Zkey
	INNER	JOIN MtMReportCounterParty rc (nolock)
	ON		rzd.CounterPartyID = rc.CounterPartyID
	INNER	Join LibertyPower..WholesaleMarket w (nolock)
	ON		rz.ISOId = w.ID

	WHERE	rz.Year >= YEAR(GETDATE())

	Order	by BookId, ISOId, ZainetLocationId, Year, CounterPartyID



SET NOCOUNT OFF; 

END
