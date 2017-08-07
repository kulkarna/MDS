
CREATE PROCEDURE [dbo].[usp_RateCodeGetRateCodeSlicesAllZones]
AS

SELECT DISTINCT
	b.utility_id AS [Utility],
	b.retail_mkt_id AS [Market],
    ISNULL(ServiceClass, '') AS [ServiceClass],
    ISNULL(z.zone, '') AS [ZoneCode],
    ISNULL(MeterType , '') AS [MeterType],
	b.billing_type as [Utility Billing Type],
    b.rate_code_required AS [Utility Rate Code Preference],
    '' AS [Rate Codes Available],
    b.rate_code_format AS [Rate Code Format],
    b.rate_code_fields AS [Rate Code Fields]
FROM
    lp_common..common_utility AS b LEFT JOIN RateCode AS a 
ON  a.Utility = b.utility_id 
LEFT JOIN lp_common..zone as z
ON b.utility_id = z.utility_id
WHERE b.billing_type = 'RR' 
UNION
SELECT
    b.utility_id AS [Utility],
	b.retail_mkt_id AS [Market], 
    '' ,
    ISNULL(z.zone,'') AS [ZoneCode],
    '' ,
    b.billing_type AS [Utility Billing Type] ,
    3 AS [Utility Rate Code Preference] , -- 3 is enum for None
    '' AS [Rate Codes Available] ,
    0 AS [Rate Code Format] ,
    0 AS [Rate Code Fields]
FROM
    lp_common..common_utility b
LEFT JOIN lp_common..zone as z
ON b.utility_id = z.utility_id    
WHERE
    billing_type <> 'RR' 
ORDER BY
	Market,
    Utility,
    ServiceClass,
    ZoneCode,
    MeterType



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeGetRateCodeSlicesAllZones';

