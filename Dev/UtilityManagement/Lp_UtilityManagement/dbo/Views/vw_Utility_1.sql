CREATE VIEW vw_Utility
AS


SELECT 
	UC.UtilityIdInt
	,UC.[UtilityCode]
	,UC.[FullName]
	,UL.[ShortName]
	,M.MarketIdInt AS MarketID
	,UC.[PrimaryDunsNumber] AS DunsNumber
	,UC.[LpEntityId] AS EntityId
	,UC.[EnrollmentLeadDays]
	,BT.ShortName AS BillingType
	,UC.[AccountLength]
	,UC.[AccountNumberPrefix]
	,UL.[LeadScreenProcess]
	,UL.[DealScreenProcess]
	,CASE WHEN UC.[PorOption] = 1 THEN 'YES' ELSE 'NO' END AS PorOption
	,UL.[Field01Label]
	,UL.[Field01Type]
	,UL.[Field02Label]
	,UL.[Field02Type]
	,UL.[Field03Label]
	,UL.[Field03Type]
	,UL.[Field04Label]
	,UL.[Field04Type]
	,UL.[Field05Label]
	,UL.[Field05Type]
	,UL.[Field06Label]
	,UL.[Field06Type]
	,UL.[Field07Label]
	,UL.[Field07Type]
	,UL.[Field08Label]
	,UL.[Field08Type]
	,UL.[Field09Label]
	,UL.[Field09Type]
	,UL.[Field10Label]
	,UL.[Field10Type]
	,UL.[DateCreated]
	,UL.[UserName]
	,UL.[InactiveInd]
	,UL.[ActiveDate]
	,UL.[ChgStamp]
	,UC.[MeterNumberRequired]
	,UC.[MeterNumberLength]
	,UL.[AnnualUsageMin]
	,UL.[Qualifier]
	,UC.[EdiCapabale] AS EdiCapable
	,I.Name AS WholeSaleMktID
	,UC.[UtilityPhoneNumber] AS Phone
	,UL.[RateCodeRequired]
	,UL.[HasZones]
	,UL.[ZoneDefault]
	,UL.[Field11Label]
	,UL.[Field11Type]
	,UL.[Field12Label]
	,UL.[Field12Type]
	,UL.[Field13Label]
	,UL.[Field13Type]
	,UL.[Field14Label]
	,UL.[Field14Type]
	,UL.[Field15Label]
	,UL.[Field15Type]
	,UL.[RateCodeFormat]
	,UL.[RateCodeFields]
	,UL.[LegacyName]
	,UL.[SSNIsRequired]
	,UL.[PricingModeID]
	,UL.[isIDR_EDI_Capable]
	,UL.[HU_RequestType]
	,UL.[MultipleMeters]
	,UL.[MeterReadOverlap]
	,UL.[AutoApproval]
	,UL.[DeliveryLocationRefID]
	,UL.[DefaultProfileRefID]
	,UL.[SettlementLocationRefID]
  FROM 
	[Lp_UtilityManagement].[dbo].[UtilityLegacy] (NOLOCK) UL
	LEFT OUTER JOIN [Lp_UtilityManagement].[dbo].[UtilityCompanyToUtilityLegacy] (NOLOCK) UC2UL
		ON UL.ID = UC2UL.UtilityLegacyId
	LEFT OUTER JOIN [Lp_UtilityManagement].[dbo].[UtilityCompany] (NOLOCK) UC
		ON UC2UL.UtilityCompanyId = UC.Id
	LEFT OUTER JOIN [Lp_UtilityManagement].[dbo].[Market] (NOLOCK) M
		ON UC.MarketId = M.Id
	LEFT OUTER JOIN [Lp_UtilityManagement].[dbo].[BillingType] (NOLOCK) BT
		ON UC.BillingTypeId = BT.Id
	LEFT OUTER JOIN [Lp_UtilityManagement].[dbo].[ISO] (NOLOCK) I
		ON UC.IsoId = I.Id