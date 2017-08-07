CREATE VIEW Utility_vw
AS
      SELECT
            UC.UtilityIdInt AS ID,
            UC.UtilityCode,
            UC.FullName,
            U.ShortName,						
            UC.MarketID,						-- need UI access
            UC.PrimaryDunsNumber AS DunsNumber,	-- need UI access
            UC.LpEntityId AS EntityId,			-- need UI access
            U.EnrollmentLeadDays,				-- need UI access
            U.BillingType,						-- need UI access
            U.AccountLength,					-- need UI access
            U.AccountNumberPrefix,				-- need UI access
            U.LeadScreenProcess,
            U.DealScreenProcess,
            U.PorOption,						-- need UI access
            U.Field01Label,
            U.Field01Type,
            U.Field02Label,
            U.Field02Type,
            U.Field03Label,
            U.Field03Type,
            U.Field04Label,
            U.Field04Type,
            U.Field05Label,
            U.Field05Type,
            U.Field06Label,
            U.Field06Type,
            U.Field07Label,
            U.Field07Type,
            U.Field08Label,
            U.Field08Type,
            U.Field09Label,
            U.Field09Type,
            U.Field10Label,
            U.Field10Type,
            UC.CreatedDate AS DateCreated,
            UC.CreatedBy AS UserName,
            UC.Inactive AS InactiveInd,
            U.ActiveDate,
            U.ChgStamp,
            U.MeterNumberRequired,				
            U.MeterNumberLength,				
            U.AnnualUsageMin,
            U.Qualifier,
            U.EdiCapable,						
            I.Name AS WholeSaleMktID,			-- need UI access
            U.Phone,							-- need UI access
            U.RateCodeRequired,					
            U.HasZones,							
            U.ZoneDefault,						
            U.Field11Label,
            U.Field11Type,
            U.Field12Label,
            U.Field12Type,
            U.Field13Label,
            U.Field13Type,
            U.Field14Label,
            U.Field14Type,
            U.Field15Label,
            U.Field15Type,
            U.RateCodeFormat,
            U.RateCodeFields,
            U.LegacyName,
            U.SSNIsRequired,					
            U.PricingModeID,
            U.isIDR_EDI_Capable,
            U.HU_RequestType,
            U.MultipleMeters,
            U.MeterReadOverlap,
            U.AutoApproval
	FROM Lp_UtilityManagement..UtilityCompany UC (NOLOCK)
	LEFT JOIN Lp_UtilityManagement..UtilityLegacy U (NOLOCK) ON UC.UtilityIdInt = U.ID
	LEFT JOIN Lp_UtilityManagement..ISO I (NOLOCK) ON UC.IsoId = I.Id