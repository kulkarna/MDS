USE [Lp_transactions]
GO

/****** Object:  StoredProcedure [dbo].[usp_EdiGetAccountAgregatedData]    Script Date: 03/25/2013 17:01:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:  Miguel Vazquez
-- Create date: 2/25/2013
-- Description: Returns agregated EDI data
--    (support for multiple meters)
-- =============================================
CREATE PROCEDURE [dbo].[usp_EdiGetAccountAgregatedData] 
 @UtilityCode varchar(50),
 @AccountNumber varchar(50)
AS
BEGIN
 SELECT ea.UtilityCode, ea.AccountNumber, iuh.Date,
  SUM(iuh.[0]) AS C0, SUM(iuh.[15]) AS C15, SUM(iuh.[30]) AS C30, SUM(iuh.[45]) AS C45,
  SUM(iuh.[100]) AS C100, SUM(iuh.[115]) AS C115, SUM(iuh.[130]) AS C130, SUM(iuh.[145]) AS C145,
  SUM(iuh.[200]) AS C200, SUM(iuh.[215]) AS C215, SUM(iuh.[230]) AS C230, SUM(iuh.[245]) AS C245,
  SUM(iuh.[300]) AS C300, SUM(iuh.[315]) AS C315, SUM(iuh.[330]) AS C330, SUM(iuh.[345]) AS C345,
  SUM(iuh.[400]) AS C400, SUM(iuh.[415]) AS C415, SUM(iuh.[430]) AS C430, SUM(iuh.[445]) AS C445,
  SUM(iuh.[500]) AS C500, SUM(iuh.[515]) AS C515, SUM(iuh.[530]) AS C530, SUM(iuh.[545]) AS C545,
  SUM(iuh.[600]) AS C600, SUM(iuh.[615]) AS C615, SUM(iuh.[630]) AS C630, SUM(iuh.[645]) AS C645,
  SUM(iuh.[700]) AS C700, SUM(iuh.[715]) AS C715, SUM(iuh.[730]) AS C730, SUM(iuh.[745]) AS C745,
  SUM(iuh.[800]) AS C800, SUM(iuh.[815]) AS C815, SUM(iuh.[830]) AS C830, SUM(iuh.[845]) AS C845,
  SUM(iuh.[900]) AS C900, SUM(iuh.[915]) AS C915, SUM(iuh.[930]) AS C930, SUM(iuh.[945]) AS C945,
  SUM(iuh.[1000]) AS C1000, SUM(iuh.[1015]) AS C1015, SUM(iuh.[1030]) AS C1030, SUM(iuh.[1045]) AS C1045,
  SUM(iuh.[1100]) AS C1100, SUM(iuh.[1115]) AS C1115, SUM(iuh.[1130]) AS C1130, SUM(iuh.[1145]) AS C1145,
  SUM(iuh.[1200]) AS C1200, SUM(iuh.[1215]) AS C1215, SUM(iuh.[1230]) AS C1230, SUM(iuh.[1245]) AS C1245,
  SUM(iuh.[1300]) AS C1300, SUM(iuh.[1315]) AS C1315, SUM(iuh.[1330]) AS C1330, SUM(iuh.[1345]) AS C1345,
  SUM(iuh.[1400]) AS C1400, SUM(iuh.[1415]) AS C1415, SUM(iuh.[1430]) AS C1430, SUM(iuh.[1445]) AS C1445,
  SUM(iuh.[1500]) AS C1500, SUM(iuh.[1515]) AS C1515, SUM(iuh.[1530]) AS C1530, SUM(iuh.[1545]) AS C1545,
  SUM(iuh.[1600]) AS C1600, SUM(iuh.[1615]) AS C1615, SUM(iuh.[1630]) AS C1630, SUM(iuh.[1645]) AS C1645,
  SUM(iuh.[1700]) AS C1700, SUM(iuh.[1715]) AS C1715, SUM(iuh.[1730]) AS C1730, SUM(iuh.[1745]) AS C1745,
  SUM(iuh.[1800]) AS C1800, SUM(iuh.[1815]) AS C1815, SUM(iuh.[1830]) AS C1830, SUM(iuh.[1845]) AS C1845,
  SUM(iuh.[1900]) AS C1900, SUM(iuh.[1915]) AS C1915, SUM(iuh.[1930]) AS C1930, SUM(iuh.[1945]) AS C1945,
  SUM(iuh.[2000]) AS C2000, SUM(iuh.[2015]) AS C2015, SUM(iuh.[2030]) AS C2030, SUM(iuh.[2045]) AS C2045,
  SUM(iuh.[2100]) AS C2100, SUM(iuh.[2115]) AS C2115, SUM(iuh.[2130]) AS C2130, SUM(iuh.[2145]) AS C2145,
  SUM(iuh.[2200]) AS C2200, SUM(iuh.[2215]) AS C2215, SUM(iuh.[2230]) AS C2230, SUM(iuh.[2245]) AS C2245,
  SUM(iuh.[2300]) AS C2300, SUM(iuh.[2315]) AS C2315, SUM(iuh.[2330]) AS C2330, SUM(iuh.[2345]) AS C2345,
  SUM(iuh.[2359]) AS C2359, SUM(iuh.[Int98]) AS Int98, SUM(iuh.[Int99]) AS Int99, SUM(iuh.[Int100]) AS Int100
 FROM IdrUsageHorizontal (nolock) iuh
 INNER JOIN EdiAccount (nolock) ea ON iuh.EdiAccountId = ea.ID
 WHERE ea.UtilityCode = @UtilityCode AND ea.AccountNumber = @AccountNumber AND iuh.UnitOfMeasurement IN ('KH')
 GROUP BY ea.UtilityCode, ea.AccountNumber, iuh.Date
 ORDER BY ea.UtilityCode, ea.AccountNumber, iuh.Date DESC
END

GO