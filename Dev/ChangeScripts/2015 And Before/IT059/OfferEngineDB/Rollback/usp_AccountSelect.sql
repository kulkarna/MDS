USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountsSelect]    Script Date: 07/13/2013 14:03:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	

ALTER PROCEDURE [dbo].[usp_AccountsSelect]

@PricingRequestID		varchar(50)

AS

--could not alias legacy column definition to new standard. Existing UPD/INS SPs currently use this column name
SELECT		a.ID 	,
a.ACCOUNT_NUMBER 	,
a.ACCOUNT_ID 	,
a.MARKET 	,
a.UTILITY 	,
a.METER_TYPE 	,
a.RATE_CLASS 	,
a.VOLTAGE 	,
a.ZONE 	,
a.VAL_COMMENT 	,
ISNULL(t.Tcap,ISNULL(a.TCAP,0)) AS TCAP, 
ISNULL(i.Icap,ISNULL(a.ICAP,0)) AS ICAP,
a.LOAD_SHAPE_ID 	,
a.LOSSES 	,
a.ANNUAL_USAGE 	,
a.USAGE_DATE 	,
a.NAME_KEY,
CASE WHEN acc.AccountNumber IS NULL THEN 'false' ELSE 'true' END AS IsExisting
FROM		OE_ACCOUNT a WITH (NOLOCK)
INNER JOIN OE_PRICING_REQUEST_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
LEFT JOIN dbo.OeIcaps i WITH (NOLOCK) ON a.ID = i.OeAccountID AND GETDATE() BETWEEN i.StartDate AND i.EndDate
LEFT JOIN dbo.OeTcaps t WITH (NOLOCK) ON a.ID = t.OeAccountID AND GETDATE() BETWEEN t.StartDate AND t.EndDate
LEFT JOIN Libertypower..Utility u WITH (NOLOCK) ON a.UTILITY = u.UtilityCode
LEFT JOIN Libertypower..Account acc WITH (NOLOCK) ON a.ACCOUNT_NUMBER = acc.AccountNumber and u.ID = acc.UtilityID
WHERE		b.PRICING_REQUEST_ID = @PricingRequestID
ORDER BY	UTILITY, ACCOUNT_NUMBER


GO

