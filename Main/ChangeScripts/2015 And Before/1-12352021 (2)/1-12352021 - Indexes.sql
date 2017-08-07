USE [LibertyPower]
GO

/****** Object:  Index [PriceDetailSelect]    Script Date: 02/28/2013 11:54:15 ******/
CREATE NONCLUSTERED INDEX [ProductMarkupRuleIndex] ON [dbo].[ProductMarkupRule] 
(
	[ProductMarkupRuleSetID] ASC,
	[ChannelTypeID] ASC,
	[ChannelGroupID] ASC,
	[SegmentID] ASC,
	[MarketID] ASC,
	[UtilityID] ASC,
	[ServiceClassID] ASC,
	[ZoneID] ASC,
	[ProductTypeID] ASC,
	[PriceTier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




USE [LibertyPower]
GO

/****** Object:  Index [PriceDetailSelect]    Script Date: 02/28/2013 11:53:58 ******/
CREATE NONCLUSTERED INDEX [ProductCostRuleIndex] ON [dbo].[ProductCostRule] 
(
	[ProductCostRuleSetID] ASC,
	[MarketID] ASC,
	[UtilityID] ASC,
	[ServiceClassID] ASC,
	[ZoneID] ASC,
	[ProductTypeID] ASC,
	[StartDate] ASC,
	[Term] ASC,
	[PriceTier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


