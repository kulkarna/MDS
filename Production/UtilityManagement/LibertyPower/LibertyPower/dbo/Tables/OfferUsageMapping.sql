CREATE TABLE [dbo].[OfferUsageMapping] (
    [OfferAccountsId] BIGINT  NOT NULL,
    [UsageId]         BIGINT  NOT NULL,
    [UsageType]       TINYINT NULL
);


GO
CREATE CLUSTERED INDEX [IDX_AccountUsageIds]
    ON [dbo].[OfferUsageMapping]([UsageId] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ndx_OfferAccountsId_UsageId]
    ON [dbo].[OfferUsageMapping]([OfferAccountsId] ASC)
    INCLUDE([UsageId], [UsageType]) WITH (FILLFACTOR = 90);

