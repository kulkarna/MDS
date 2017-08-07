/*******************************************************************************
 * usp_
 * Desc
 *
 * History
 *******************************************************************************
 * 1/3/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_zIstaUsageRequest]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT		DISTINCT pr.REQUEST_ID AS PricingRequestId, 
				ISNULL(a.BillingAccountNumber,'') AS BillingAccountNumber,
				a.ACCOUNT_NUMBER AS AccountNumber,  
				a.UTILITY AS UtilityCode, 
				ISNULL(a.METER_TYPE, '') AS MeterType,  
				ISNULL(d.ZIP, '') AS Zip,
				ISNULL(pr.CUSTOMER_NAME, '') AS AccountName,
				ISNULL(a.NAME_KEY, '') AS NameKey,
				ISNULL(u.DunsNumber, '') AS DunsNumber,
				ISNULL(e.duns_number, '') AS EntityDuns
	FROM		dbo.OE_ACCOUNT a WITH (NOLOCK) 
				INNER JOIN dbo.OE_PRICING_REQUEST_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID			
				LEFT OUTER JOIN dbo.OE_ACCOUNT_METERS c WITH (NOLOCK) ON b.OE_ACCOUNT_ID = c.OE_ACCOUNT_ID
				LEFT OUTER JOIN dbo.OE_ACCOUNT_ADDRESS d WITH (NOLOCK) ON b.OE_ACCOUNT_ID = d.OE_ACCOUNT_ID	
				INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON a.UTILITY = u.UtilityCode
				INNER JOIN lp_common..common_entity e WITH (NOLOCK) ON u.EntityId = e.entity_id
				INNER JOIN 
				(
					SELECT	PricingRequestID
					FROM	Workspace..PjmPricingRequests010312
					WHERE	(IsProcessed IS NULL OR IsProcessed <> 1)
				) pjm ON pjm.PricingRequestID = b.PRICING_REQUEST_ID
				INNER JOIN dbo.OE_PRICING_REQUEST pr WITH (NOLOCK) ON pr.REQUEST_ID = pjm.PricingRequestID						
	ORDER BY	a.UTILITY, a.ACCOUNT_NUMBER    


    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

