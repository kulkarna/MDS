CREATE TABLE [dbo].[ChannelGroupCommission] (
    [ChannelGroupCommissionID] INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ChannelGroupID]           INT              NOT NULL,
    [CommissionRate]           DECIMAL (18, 10) NOT NULL,
    [EffectiveDate]            DATETIME         NOT NULL,
    [ExpirationDate]           DATETIME         NULL,
    CONSTRAINT [PK_ChannelGroupCommission] PRIMARY KEY NONCLUSTERED ([ChannelGroupCommissionID] ASC)
);


GO
CREATE CLUSTERED INDEX [idx_ChannelGroupCommission_EffectiveDate]
    ON [dbo].[ChannelGroupCommission]([ChannelGroupID] ASC, [EffectiveDate] ASC);

