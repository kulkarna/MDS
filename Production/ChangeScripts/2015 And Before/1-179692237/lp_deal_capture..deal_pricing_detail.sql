Use lp_deal_capture
Go

DROP INDEX [deal_pricing_detail__PriceID_I] ON [lp_deal_capture].[dbo].[deal_pricing_detail] WITH ( ONLINE = OFF )

ALTER TABLE lp_deal_capture..deal_pricing_detail
ALTER COLUMN PriceID bigint

CREATE NONCLUSTERED INDEX [deal_pricing_detail__PriceID_I] ON [lp_deal_capture].[dbo].[deal_pricing_detail] 
(
	[PriceID] ASC
)
INCLUDE ( [rate_submit_ind],
[ContractRate]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO