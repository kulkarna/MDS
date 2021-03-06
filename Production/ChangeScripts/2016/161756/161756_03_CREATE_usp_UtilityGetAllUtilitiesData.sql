USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_UtilityGetAllUtilitiesData]    Script Date: 01/13/2017 12:25:13 ******/
DROP PROCEDURE [dbo].[usp_UtilityGetAllUtilitiesData]
GO
/****** Object:  StoredProcedure [dbo].[usp_UtilityGetAllUtilitiesData]    Script Date: 01/13/2017 12:25:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC [usp_UtilityGetAllUtilitiesData]
*/

CREATE PROCEDURE [dbo].[usp_UtilityGetAllUtilitiesData]
AS
BEGIN

	SELECT
		UC.lpc_utility_id AS UtilityLegacyId,
		UC.lpc_utilityId AS UtilityCompanyId,
		UC.lpc_UtilityCode AS UtilityCode,
		UC.lpc_utility_id as UtilityIdInt,
		UC.lpc_name as FullName,
		M.lpc_marketId as MarketId,
		M.lpc_wholesale_market_id as MarketIdInt,
		M.lpc_MarketCode as Market
	FROM
		LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK)
		INNER JOIN LibertyCrm_MSCRM.dbo.lpc_market M WITH (NOLOCK)
		ON UC.lpc_markets= M.lpc_marketId

END
GO
