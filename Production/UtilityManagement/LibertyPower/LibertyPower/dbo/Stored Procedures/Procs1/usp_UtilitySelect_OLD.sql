
CREATE procedure [dbo].[usp_UtilitySelect_OLD] ( 
	@UtilityCode VARCHAR(50) = null
	,@Username VARCHAR(100) = null
	,@MarketCode VARCHAR(2) = null
	,@MarketID INT = null
	,@ActiveIndicator INT = null
	,@UtilityID INT = null
)
AS

SET NOCOUNT ON

SET	@UtilityCode = REPLACE(@UtilityCode, 'ampersand', '&')

CREATE TABLE #UtilitiesByUser (UtilityCode VARCHAR(50))

-- If Username was provided, get list of utilities into temp table.  Used as a filter below.
IF (@Username IS NOT NULL)
BEGIN
	INSERT INTO #UtilitiesByUser
	SELECT s.utility_id
	FROM LibertyPower..[User] u (NOLOCK)
	JOIN LibertyPower..UserRole ur (NOLOCK) ON ur.userid = u.userid 
	JOIN LibertyPower..Role r (NOLOCK) ON r.RoleID = ur.RoleID	
	JOIN lp_security..security_role_utility s (NOLOCK) ON r.RoleName = s.role_name
	WHERE u.Username = @Username
END


SELECT 
	u.ID
	,u.UtilityCode
	,UtilityDescription = u.LegacyName
	,CompanyEntityCode = u.EntityID
	,entity_id = u.EntityID
	,por_option = u.PorOption
	,billing_type = u.BillingType
	,enrollment_lead_days = u.EnrollmentLeadDays
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
	,PaperContractOnly = 0
FROM Utility u WITH (NOLOCK)
JOIN Market m WITH (NOLOCK) ON u.MarketID = m.ID
--JOIN UtilityPermission p (NOLOCK) on u.UtilityCode = p.UtilityCode
WHERE 1=1
AND (@UtilityCode		IS NULL OR u.UtilityCode = @UtilityCode)
AND (@MarketCode		IS NULL OR m.MarketCode = @MarketCode)
AND (@MarketID			IS NULL OR u.MarketID = @MarketID)
AND (@UtilityID			IS NULL OR u.ID = @UtilityID)
AND (@ActiveIndicator	IS NULL OR u.InactiveInd = 1-@ActiveIndicator)
-- If username is specified, only return utilities for the security level of the user.
AND ((@Username IS NULL OR LEN(@Username) = 0) OR u.UtilityCode IN (select utilitycode from #UtilitiesByUser))
ORDER BY u.UtilityCode


SET NOCOUNT OFF

-- Copywrite LibertyPower 02/24/2010

