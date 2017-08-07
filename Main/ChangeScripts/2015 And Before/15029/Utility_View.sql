USE [integration]
GO

/****** Object:  View [dbo].[Utility]    Script Date: 11/06/2013 08:13:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[Utility]
AS

SELECT 
	utility_id = ID
	, utility = UtilityCode
	, description = FullName
	, market_id = MarketID
	, wholesale_market_id = WholeSaleMktID 
	, date_created = DateCreated
	, date_last_mod = DateCreated
	, active = 1 - InactiveInd
FROM LibertyPower..Utility (nolock)

GO


