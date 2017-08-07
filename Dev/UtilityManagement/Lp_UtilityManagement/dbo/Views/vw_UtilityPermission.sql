CREATE VIEW vw_UtilityPermission
AS
SELECT
	UPL.ID,
	UC.UtilityCode,
	M.Market AS RetailMktID,
	UP.PaperContractOnly
FROM
	[Lp_UtilityManagement].dbo.UtilityPermissionLegacy (NOLOCK) UPL
	LEFT OUTER JOIN [Lp_UtilityManagement].dbo.UtilityPermissionToUtilityPermissionLegacy (NOLOCK) UP2UPL
		ON UPL.ID = UP2UPL.UtilityPermissionLegacyId
	LEFT OUTER JOIN [Lp_UtilityManagement].dbo.UtilityPermission (NOLOCK) UP
		ON UP2UPL.UtilityPermissionId = UP.Id
	LEFT OUTER JOIN [Lp_UtilityManagement].dbo.UtilityCompany (NOLOCK) UC
		ON UP.UtilityCompanyId = UC.Id
	INNER JOIN [Lp_UtilityManagement].dbo.Market (NOLOCK) M
		ON UP.MarketId = M.Id
			AND M.MarketIdInt <> 14