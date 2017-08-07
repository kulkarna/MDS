CREATE TABLE [dbo].[product_transition] (
    [product_id]         CHAR (20) NOT NULL,
    [rate_id]            INT       NOT NULL,
    [MarketID]           INT       NULL,
    [UtilityID]          INT       NULL,
    [ZoneID]             INT       NULL,
    [ServiceClassID]     INT       NULL,
    [Term]               INT       NULL,
    [AccountTypeID]      INT       NULL,
    [ProductTypeID]      INT       NULL,
    [ChannelTypeID]      INT       NULL,
    [RelativeStartMonth] INT       NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_product_transition]
    ON [dbo].[product_transition]([product_id] ASC, [rate_id] ASC) WITH (FILLFACTOR = 90);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_product_transition_2]
    ON [dbo].[product_transition]([product_id] ASC, [rate_id] ASC, [UtilityID] ASC)
    INCLUDE([RelativeStartMonth]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_product_transition_3]
    ON [dbo].[product_transition]([product_id] ASC, [MarketID] ASC, [UtilityID] ASC, [ZoneID] ASC, [ServiceClassID] ASC, [AccountTypeID] ASC, [ProductTypeID] ASC, [ChannelTypeID] ASC, [RelativeStartMonth] ASC)
    INCLUDE([Term], [rate_id]) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'product_transition';

