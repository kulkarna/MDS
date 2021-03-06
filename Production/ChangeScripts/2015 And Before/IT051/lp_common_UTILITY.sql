USE [Lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllActiveUtilities]    Script Date: 09/14/2011 10:39:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_GetAllActiveUtilities]

AS

BEGIN

SET NOCOUNT ON;

SELECT

ID = a.ID

, UtilityCode = RTRIM(a.utility_id)

, UtilityDescription = a.utility_descp

, DunsNumber = a.duns_number

, CompanyEntityCode = a.entity_id

, DateCreated = a.date_created

, CreatedBy = a.username

, AccountLength = a.account_length

, AccountNumberPrefix = a.account_number_prefix

, RetailMarketCode = a.retail_mkt_id

, BillingType = a.billing_type

, RateCodeFormat = a.rate_code_format

, RateCodeFields = a.rate_code_fields

, PricingModeID = u.PricingModeID

, RetailMarketID = u.MarketID

, WholeSaleMktID as ISO

, a.zone_default as ZoneID


FROM common_utility a (NOLOCK)

JOIN Libertypower.dbo.Utility u (NOLOCK)

ON a.utility_id = u.UtilityCode

JOIN common_views b WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 WITH (NOLOCK INDEX = common_views_idx)

ON b.return_value = a.inactive_ind

JOIN utility_permission p WITH (NOLOCK)

ON a.utility_id = p.utility_id

LEFT JOIN auxiliary_charge c WITH (NOLOCK)

ON a.utility_id = c.utility_id AND c.code = 'MeterCharge'

WHERE

b.process_id = 'INACTIVE IND'

AND

b.return_value = 0

ORDER BY

a.utility_id;

SET NOCOUNT OFF;

END

-- Copyright 11/11/2008 Liberty Power

