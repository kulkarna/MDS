USE lp_mtm
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MTMReportZKeyListSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MTMReportZKeyListSelect]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo 
-- Create date: 5/23/2013
-- Description:	Get List of Zkey Detail
-- =============================================
-- exec lp_mtm..[usp_MTMReportZKeyListSelect]
-- ============================================
CREATE PROCEDURE [dbo].[usp_MTMReportZKeyListSelect]
AS 
BEGIN 

	SET NOCOUNT ON;

	SELECT zh.ZkeyID

		, zh.ISOId
		, w.WholesaleMktId 

		, InternalRefLocId = pir.id
		, InternalRefLocation = pir.Value 
		
		, ZainetLocationId
		, ZainetLocation = pv.Value
		
		, zh.Year
		, mrb.BookID
		, mrb.BookName 
		
		, zd.ZKeyDetailID
		, zd.CounterPartyID
		, mrc.CounterParty
		, zd.ZKey
		
	FROM lp_MtM..MtMReportZkey zh (NOLOCK) 
		LEFT JOIN lp_MtM..MtMReportZkeyDetail zd (NOLOCK) 
			ON zh.ZkeyID = zd.ZkeyID
		LEFT JOIN LibertyPower..WholesaleMarket w (NOLOCK) 
			ON w.ID = zh.ISOId 
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = zh.ZainetLocationId			
		LEFT JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) 
			ON pir.ID = pv.InternalRefID
		LEFT JOIN lp_mtm..MtMReportBook mrb  (NOLOCK) 
			ON mrb.BookId = zh.BookId
		LEFT JOIN lp_mtm..MtMReportCounterParty mrc (NOLOCK) 
			ON mrc.CounterPartyID = zd.CounterPartyID
	
	SET NOCOUNT OFF;		
END 
GO 