﻿-- =============================================
-- Author:		Gabor Kovacs
-- Create date: 4/8/2011
-- =============================================
CREATE PROCEDURE [dbo].usp_VRE_ErcotHubPricesSelect
	@startingDate datetime,
	@endingDate datetime
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT
	[ZoneID]
      ,[CMZone]
      ,[PriceDate]
      ,[PriceH01]
      ,[PriceH02]
      ,[PriceH03]
      ,[PriceH04]
      ,[PriceH05]
      ,[PriceH06]
      ,[PriceH07]
      ,[PriceH08]
      ,[PriceH09]
      ,[PriceH10]
      ,[PriceH11]
      ,[PriceH12]
      ,[PriceH13]
      ,[PriceH14]
      ,[PriceH15]
      ,[PriceH16]
      ,[PriceH17]
      ,[PriceH18]
      ,[PriceH19]
      ,[PriceH20]
      ,[PriceH21]
      ,[PriceH22]
      ,[PriceH23]
      ,[PriceH24]
      ,[PriceH25]
      ,[PriceH26]
      ,[PriceH27]
      ,[PriceH28]
      ,[PriceH29]
      ,[PriceH30]
      ,[PriceH31]
      ,[PriceH32]
      ,[PriceH33]
      ,[PriceH34]
      ,[PriceH35]
      ,[PriceH36]
      ,[PriceH37]
      ,[PriceH38]
      ,[PriceH39]
      ,[PriceH40]
      ,[PriceH41]
      ,[PriceH42]
      ,[PriceH43]
      ,[PriceH44]
      ,[PriceH45]
      ,[PriceH46]
      ,[PriceH47]
      ,[PriceH48]
      ,[PriceH49]
      ,[PriceH50]
      ,[PriceH51]
      ,[PriceH52]
      ,[PriceH53]
      ,[PriceH54]
      ,[PriceH55]
      ,[PriceH56]
      ,[PriceH57]
      ,[PriceH58]
      ,[PriceH59]
      ,[PriceH60]
      ,[PriceH61]
      ,[PriceH62]
      ,[PriceH63]
      ,[PriceH64]
      ,[PriceH65]
      ,[PriceH66]
      ,[PriceH67]
      ,[PriceH68]
      ,[PriceH69]
      ,[PriceH70]
      ,[PriceH71]
      ,[PriceH72]
      ,[PriceH73]
      ,[PriceH74]
      ,[PriceH75]
      ,[PriceH76]
      ,[PriceH77]
      ,[PriceH78]
      ,[PriceH79]
      ,[PriceH80]
      ,[PriceH81]
      ,[PriceH82]
      ,[PriceH83]
      ,[PriceH84]
      ,[PriceH85]
      ,[PriceH86]
      ,[PriceH87]
      ,[PriceH88]
      ,[PriceH89]
      ,[PriceH90]
      ,[PriceH91]
      ,[PriceH92]
      ,[PriceH93]
      ,[PriceH94]
      ,[PriceH95]
      ,[PriceH96]
      ,[PriceH97]
      ,[PriceH98]
      ,[PriceH99]
      ,[PriceH100]
      ,[TRADE_DATE]
  FROM [ERCOT].[dbo].[tblHubPriceByZone_vw]
	Where
		[PriceDate] >= @startingDate and [PriceDate] < @endingDate	
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ErcotHubPricesSelect';
