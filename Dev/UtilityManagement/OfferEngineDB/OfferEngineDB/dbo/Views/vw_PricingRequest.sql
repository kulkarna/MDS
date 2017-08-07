create view [dbo].[vw_PricingRequest]  as 

select 
pr.Request_id as [Price Request ID],
pr.Customer_Name as [Customer Name],
pr.Due_Date as [Price Request Due Date],
pr.Creation_Date as [Price Request Created Date],
pr.Sales_Representative as [Sales Rep],
pr.Status as [Price Request Status],
o.Offer_id as [Offer ID],
o.Status as [Offer Status],
a.account_number as [Account Number], 
a.Market,
a.Utility,
a.Zone,
a.annual_usage as [Annual Usage],
a.usage_date as [Usage Date]
--,pr.*
from 
OE_PRICING_REQUEST pr inner join
OE_PRICING_REQUEST_OFFER pro on pr.REQUEST_id=pro.REQUEST_id inner join
OE_OFFER o on pro.offer_id=o.offer_id inner join 
OE_OFFER_ACCOUNTS oa on o.offer_id=oa.offer_id inner join
OE_ACCOUNT a on oa.account_number=a.account_number
