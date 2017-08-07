
/**************************************************************************************************************************************************************
* usp_UtilityGetAllUtilitiesData
* Retrieves All Utility Company Records and Their Associated Market and Legacy Data
*
* History
**************************************************************************************************************************************************************
* 08/20/2015 - Paul Hasselbring 
* Created.
**************************************************************************************************************************************************************/

CREATE PROC usp_UtilityGetAllUtilitiesData
AS
BEGIN

	SELECT
		UC2UL.UtilityLegacyId,
		UC.Id [UtilityCompanyId],
		UC.UtilityCode,
		UC.UtilityIdInt,
		UC.FullName,
		M.Id [MarketId],
		M.MarketIdInt,
		M.Market
	FROM
		Lp_UtilityManagement.dbo.UtilityCompany (NOLOCK) UC
		INNER JOIN Lp_UtilityManagement.dbo.UtilityCompanyToUtilityLegacy (NOLOCK) UC2UL
			ON UC.Id = UC2UL.UtilityCompanyId 
		INNER JOIN Lp_UtilityManagement.dbo.Market (NOLOCK) M
			ON UC.MarketId = M.Id

END