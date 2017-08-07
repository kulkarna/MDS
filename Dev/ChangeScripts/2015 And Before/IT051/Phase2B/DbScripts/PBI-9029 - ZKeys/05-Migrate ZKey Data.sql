USE [lp_mtm]
GO

-- Upsate ISO Id
-- ======================================
--SELECT * 
UPDATE zh SET ISOId = w.ID 
FROM MtMReportZkey zh 
	jOIN LibertyPower..wholesalemarket w ON zh.ISO = w.WholeSaleMktID 
WHERE ISNULL(ISOid, 0) <> w.ID  
-- ======================================

	
-- Update LocationRefID	
-- ================================
-- Find missing LocationID -- 
SELECT distinct zh.ISo , zh.Zone 
FROM lp_MtM..MtMReportZkey zh (NOLOCK)
	LEFT JOIN LibertyPower..vw_ExternalEntityMapping eem WITH (NOLOCK) ON eem.ExtEntityID = 9 -- Zainet
		AND eem.ExtEntityValue = zh.Zone
WHERE eem.ExtEntityValueID IS NULL 

/*
ISo		Zone
MISO	AMIL
MISO	CILCO
MISO	IP
MISO	MISO
NEISO	NEPOOL
PJM		AEPGHB
PJM		ATSGHB
PJM		CHIGHB
PJM		CHIHB
PJM		DOMHB
PJM		NJHB
PJM		OHHB
PJM		WINTHB
*/

-- Update location ID --- 
UPDATE zh set ZainetLocationId = eem.ExtPropertyValueID 
FROM lp_MtM..MtMReportZkey zh 
	LEFT JOIN LibertyPower.dbo.vw_ExternalEntityMapping eem ON eem.ExtEntityID = 9 -- Zainet
		AND eem.ExtEntityValue = zh.Zone
WHERE ISNULL(ZainetLocationId,0) <> eem.ExtPropertyValueID

	
-- Update BookID
-- ================================
UPDATE zh set BookId = Book
FROM lp_MtM..MtMReportZkey zh 
	


--select * from LibertyPower..Property
--select * from LibertyPower..vw_ExternalEntityMapping where ExtEntityValue = 'ZONE A'
-- select * from  Libertypower..wholesalemarket

--update lp_MtM..MtMReportZkey set Zonerefid = 0 where Zonerefid is null 
--update lp_MtM..MtMReportZkey set SettlementLocRefId = 0 where SettlementLocRefId is null 
--update lp_MtM..MtMReportZkey set ISOId = 0 where ISOId is null 
--update lp_MtM..MtMReportZkey set BookId = 0 where BookId is null 

