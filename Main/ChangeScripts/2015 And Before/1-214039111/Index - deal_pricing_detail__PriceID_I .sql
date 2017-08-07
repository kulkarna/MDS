Use lp_deal_capture
Go

Drop index deal_pricing_detail .deal_pricing_detail__PriceID_I
Go 

CREATE NONCLUSTERED INDEX [deal_pricing_detail__PriceID_I] ON [dbo].[deal_pricing_detail] 
(
      [PriceID] ASC
)
INCLUDE 
( [rate_submit_ind]
, [ContractRate]
, [deal_pricing_id] ) 
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO 
