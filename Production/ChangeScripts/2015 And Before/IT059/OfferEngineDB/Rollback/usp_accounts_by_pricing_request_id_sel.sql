USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_accounts_by_pricing_request_id_sel]    Script Date: 07/13/2013 14:03:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
-- Author:		Maurício Nogueira
-- Create date: 7/19/2010
-- Description:	
--
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
-- =============================================
ALTER PROCEDURE [dbo].[usp_accounts_by_pricing_request_id_sel]

@p_pricing_request_id		varchar(50)

AS
SELECT		a.ID,
			ISNULL(a.BillingAccountNumber,'') AS BillingAccountNumber,	-- INF83 TR006 / 05/08/2009 hbm
			a.ACCOUNT_NUMBER, 
			ISNULL(a.ACCOUNT_ID, '') AS ACCOUNT_ID, 
			ISNULL(a.MARKET, '') AS MARKET, 
			ISNULL(a.UTILITY, '') AS UTILITY, 
			ISNULL(a.METER_TYPE, '') AS METER_TYPE, 
			ISNULL(a.RATE_CLASS, '') AS RATE_CLASS, 
			ISNULL(a.VOLTAGE, '') AS VOLTAGE, 
			ISNULL(a.ZONE, '') AS ZONE, 
			ISNULL(a.VAL_COMMENT, '') AS VAL_COMMENT, 
			ISNULL(t.Tcap,ISNULL(a.TCAP,0)) AS TCAP, 
			ISNULL(i.Icap,ISNULL(a.ICAP,0)) AS ICAP,
			ISNULL(a.LOAD_SHAPE_ID,'') AS LOAD_SHAPE_ID,  
			ISNULL(a.LOSSES, 0) AS LOSSES, 
			ISNULL(a.ANNUAL_USAGE, 0) AS ANNUAL_USAGE,
			USAGE_DATE,
			ISNULL(c.METER_NUMBER, '') AS METER_NUMBER,
			ISNULL(d.ADDRESS, '') AS ADDRESS,
			ISNULL(d.SUITE, '') AS SUITE,
			ISNULL(d.CITY, '') AS CITY,
			ISNULL(d.STATE, '') AS STATE,
			ISNULL(d.ZIP, '') AS ZIP,
			CASE WHEN acc.AccountNumber IS NULL THEN 'false' ELSE 'true' END AS IsExisting,
			ISNULL(a.TarrifCode, '') AS TarrifCode,
			ISNULL(a.LOAD_PROFILE, '') AS LOAD_PROFILE,
			ISNULL(a.Grid, '') AS Grid, 
			ISNULL(a.LbmpZone, '') AS LbmpZone,
			ISNULL(a.NAME_KEY, '') AS NAME_KEY,
			ISNULL(acc.EntityID, u.EntityID) AS EntityID,	
			ISNULL(a.IsAnnualUsageEstimated, 0) AS IsAnnualUsageEstimated,
			ISNULL(a.EstimatedAnnualUsage, 0) AS EstimatedAnnualUsage	
FROM		OE_ACCOUNT a WITH (NOLOCK) 
			INNER JOIN dbo.OE_PRICING_REQUEST_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
			LEFT OUTER JOIN dbo.OE_ACCOUNT_METERS c WITH (NOLOCK) ON b.OE_ACCOUNT_ID = c.OE_ACCOUNT_ID
			LEFT OUTER JOIN dbo.OE_ACCOUNT_ADDRESS d WITH (NOLOCK) ON b.OE_ACCOUNT_ID = d.OE_ACCOUNT_ID
			LEFT JOIN dbo.OeIcaps i WITH (NOLOCK) ON a.ID = i.OeAccountID AND GETDATE() BETWEEN i.StartDate AND i.EndDate
			LEFT JOIN dbo.OeTcaps t WITH (NOLOCK) ON a.ID = t.OeAccountID AND GETDATE() BETWEEN t.StartDate AND t.EndDate	
			LEFT JOIN Libertypower.dbo.Utility u WITH (NOLOCK) ON a.UTILITY = u.UtilityCode
			LEFT JOIN Libertypower.dbo.Account acc WITH (NOLOCK) ON a.ACCOUNT_NUMBER = acc.AccountNumber and u.ID = acc.UtilityID
WHERE		b.PRICING_REQUEST_ID = @p_pricing_request_id
ORDER BY	a.UTILITY, a.ACCOUNT_NUMBER



GO

