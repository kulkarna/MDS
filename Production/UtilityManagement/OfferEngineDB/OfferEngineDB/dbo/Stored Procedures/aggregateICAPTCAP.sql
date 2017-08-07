CREATE PROCEDURE [dbo].[aggregateICAPTCAP]
@PricingRequesID     varchar(50)
AS
BEGIN
-- aggreagates values of ICAP and TCAP by offer(group), utility and zone
-- mvelasco, Jan 1 2008 

select offer_id, utility, zone, sum(ICAP) as ICAP, sum(TCAP) as TCAP from 
(select ac.utility,ac.zone,ac.ICAP,ac.TCAP,sap.offer_id from oe_account ac inner join 
(select oa.account_id, oa.offer_id from oe_offer_accounts oa inner join
OE_PRICING_REQUEST_OFFER pra on oa.offer_id = pra.offer_id where request_id=@PricingRequesID) 
sap on ac.account_id = sap.account_id) sep
group by offer_id, utility, zone
END
