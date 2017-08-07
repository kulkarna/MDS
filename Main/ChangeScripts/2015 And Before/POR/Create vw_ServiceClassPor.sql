USE [LibertyPower]
GO

/****** Object:  View [dbo].[vw_ServiceClassPor]    Script Date: 05/23/2012 17:39:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_ServiceClassPor]

AS

SELECT DISTINCT
	por.[ID]									AS 'CreditPorID'
	,sc.service_rate_class_id
	,m.[ID]										AS 'MarketID'
	,u.[ID]										AS 'UtilityID'
	,m.MarketCode
	,u.UtilityCode
	,CASE u.PorOption
		WHEN 'YES' THEN CAST(1 AS bit)
		ELSE CAST(0 AS bit)
	END											AS 'UtilityPOR'
	,sc.service_rate_class						AS 'ServiceRateClassName'

	,por.[IsPoRAvailable]
	,por.[EffectiveDate]
	,por.[DateCreated]
	,por.[CreatedBy]
	,por.[DateModified]
	,por.[ModifiedBy]
FROM lp_common..service_rate_class				sc (NOLOCK)
JOIN LibertyPower..Utility						u (NOLOCK)
	ON u.UtilityCode = sc.utility_id
JOIN LibertyPower..Market						m (NOLOCK)
	ON m.ID = u.MarketID
LEFT JOIN [LibertyPower]..[CreditPoR]			por (NOLOCK)
	ON por.ServiceClassID = sc.service_rate_class_id
WHERE sc.service_rate_class NOT LIKE '%MWh%'



GO
