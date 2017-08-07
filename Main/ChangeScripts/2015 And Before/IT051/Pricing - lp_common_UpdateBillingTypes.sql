UPDATE r
SET  r.BillingTypeID = t.BillingTypeID

FROM lp_common.dbo.common_product_rate r

JOIN lp_common.dbo.common_product p 
ON  r.product_id = p.product_id 

JOIN LibertyPower..Utility u 
ON  p.utility_id = u.utilityCode

JOIN LibertyPower..BillingType t
On  u.BillingType = t.Type

WHERE r.BillingTypeID is null