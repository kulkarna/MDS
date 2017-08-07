USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_UtilitiesSelectByZipCode]    Script Date: 10/31/2012 16:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER procedure [dbo].[usp_UtilitiesSelectByZipCode] ( 
	 @Zipcode NVARCHAR(5)	
	,@Username VARCHAR(100)
	,@PorOption nvarchar(4) = 'YES'
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT DISTINCT s.utility_id as UtilityCode
	INTO #UtilitiesByUser
	FROM [Libertypower]..[User] u
	JOIN Libertypower..UserRole ur ON ur.userid = u.userid 
	JOIN Libertypower..Role r ON r.RoleID = ur.RoleID	
	JOIN lp_security..security_role_utility s ON r.RoleName = s.role_name
	WHERE u.Username = @Username


	SELECT DISTINCT  u.Id
					,u.ID as UtilityID
					,u.UtilityCode
					,UtilityDescription = u.LegacyName
					,CompanyEntityCode = u.EntityID
					,CreatedBy = u.UserName
					,RetailMarketCode = m.MarketCode
					,u.FullName
					,u.ShortName
					,u.MarketID
					,u.DunsNumber	
					,u.EntityId
					,u.EnrollmentLeadDays
					,u.BillingType
					,u.AccountLength
					,u.AccountNumberPrefix
					,u.LeadScreenProcess
					,u.DealScreenProcess
					,u.PorOption
					,u.DateCreated
					,u.UserName
					,u.InactiveInd
					,u.ActiveDate
					,u.ChgStamp
					,u.MeterNumberRequired
					,u.MeterNumberLength
					,u.AnnualUsageMin
					,u.Qualifier
					,u.EdiCapable
					,u.WholeSaleMktID
					,u.Phone
					,u.RateCodeRequired
					,u.HasZones
					,u.ZoneDefault
					,u.RateCodeFormat
					,u.RateCodeFields
					,u.SSNIsRequired
					,u.PricingModeID
					,u.HU_RequestType
					,u.Field01Label	,u.Field01Type	,u.Field02Label	,u.Field02Type	,u.Field03Label	,u.Field03Type	,u.Field04Label	,u.Field04Type	,u.Field05Label	,u.Field05Type	,u.Field06Label	,u.Field06Type	,u.Field07Label	,u.Field07Type	,u.Field08Label	,u.Field08Type	,u.Field09Label	,u.Field09Type	,u.Field10Label	,u.Field10Type
					,u.Field11Label	,u.Field11Type	,u.Field12Label	,u.Field12Type	,u.Field13Label	,u.Field13Type	,u.Field14Label	,u.Field14Type	,u.Field15Label	,u.Field15Type
					,MultipleMeters
					,isScrapable = CASE WHEN s.utility_id IS NULL THEN 0 ELSE 1 END
	FROM ZipCode z WITH (NOLOCK)
	JOIN Market  m WITH (NOLOCK) ON m.MarketCode = z.StateAbbreviation
	JOIN Utility u WITH (NOLOCK) ON m.ID = u.MarketId
	JOIN #UtilitiesByUser u2 ON u2.UtilityCode = u.UtilityCode
	LEFT	JOIN lp_historical_info..zScraperUtilities s WITH (NOLOCK) ON u.UtilityCode = s.utility_id
	WHERE z.ZipCode = @Zipcode
	  and u.InactiveInd = 0
	  and u.PorOption = @PorOption
	ORDER BY u.UtilityCode
	
	--select * from utility

	SET NOCOUNT OFF

END
