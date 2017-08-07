

CREATE PROC [dbo].[usp_zAuditLpBillingType_SELECT]
AS
BEGIN

	SELECT 
		ABT.IdPrimary,
		ABT.Id,
		ABT.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		PD.Name AS PorDriver,
		PDPrev.Name AS PorDriverPrevious,
		RC.RateClassCode,
		RCPrev.RateClassCode AS RateClassCodePrevious,
		LP.LoadProfileCode,
		LPPrev.LoadProfileCode AS LoadProfileCodePrevious,
		TC.TariffCodeCode AS TariffCode,
		TCPrev.TariffCodeCode AS TariffCodePrevious,
		DBT.Name AS DefaultBillingType,
		DBTPrev.Name AS DefaultBillingTypePrevious,
		ABT.Inactive,
		ABT.InactivePrevious,
		ABT.CreatedBy,
		ABT.CreatedByPrevious,
		ABT.CreatedDate,
		ABT.CreatedDatePrevious,
		ABT.LastModifiedBy,
		ABT.LastModifiedByPrevious,
		ABT.LastModifiedDate,
		ABT.LastModifiedDatePrevious,
		REPLACE(ABT.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		ABT.SYS_CHANGE_CREATION_VERSION,
		ABT.SYS_CHANGE_OPERATION,
		ABT.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditLpBillingType (NOLOCK) ABT
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON ABT.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON ABT.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.PorDriver (NOLOCK) PD
			ON ABT.PorDriverId = PD.Id
		LEFT OUTER JOIN dbo.PorDriver (NOLOCK) PDPrev
			ON ABT.PorDriverIdPrevious = PDPrev.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON ABT.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RCPrev
			ON ABT.RateClassIdPrevious = RCPrev.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON ABT.LoadProfileId = LP.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LPPrev
			ON ABT.LoadProfileIdPrevious = LPPrev.Id
		LEFT OUTER JOIN dbo.TariffCode (NOLOCK) TC
			ON ABT.TariffCodeId = TC.Id
		LEFT OUTER JOIN dbo.TariffCode (NOLOCK) TCPrev
			ON ABT.TariffCodeIdPrevious = TCPrev.Id
		LEFT OUTER JOIN dbo.BillingType (NOLOCK) DBT
			ON ABT.DefaultBillingTypeId = DBT.Id
		LEFT OUTER JOIN dbo.BillingType (NOLOCK) DBTPrev
			ON ABT.DefaultBillingTypeIdPrevious = DBTPrev.Id
END