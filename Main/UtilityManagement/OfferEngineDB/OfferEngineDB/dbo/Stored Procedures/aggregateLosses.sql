CREATE PROCEDURE [dbo].[aggregateLosses]
@PricingRequestID     varchar(50)
AS
BEGIN
-- aggregates value of Losses by offer(group), utility and voltage
-- mvelasco, Jan 1 2008 

select offer_id, utility, voltage, sum(Losses*Annual_Usage)/sum(Annual_Usage) as Losses from 
(select ac.utility,ac.voltage,ac.losses,ac.annual_usage,sap.offer_id from oe_account ac inner join 
(select oa.account_id, oa.offer_id from oe_offer_accounts oa inner join
OE_PRICING_REQUEST_OFFER pra on oa.offer_id = pra.offer_id where request_id=@PricingRequestID) sap on ac.account_id =
sap.account_id) sep
group by offer_id, utility, voltage
END


--ALTER table oe_account modify ICAP Decimal(18,9);
--ALTER table oe_account modify TCAP Decimal(18,9);
--ALTER table oe_account modify Losses Decimal(18,9);


