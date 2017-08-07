CREATE TABLE [dbo].[DailyPricingLegacyRatesTemp] (
    [ID]                   INT           IDENTITY (1, 1) NOT NULL,
    [ProductID]            VARCHAR (20)  NULL,
    [RateID]               INT           NULL,
    [MarketID]             INT           NULL,
    [UtilityID]            INT           NULL,
    [ZoneID]               INT           NULL,
    [ServiceClassID]       INT           NULL,
    [ChannelGroupID]       INT           NULL,
    [Term]                 INT           NULL,
    [AccountTypeID]        INT           NULL,
    [ChannelTypeID]        INT           NULL,
    [ProductTypeID]        INT           NULL,
    [RateDesc]             VARCHAR (250) NULL,
    [DueDate]              DATETIME      NULL,
    [ContractEffStartDate] DATETIME      NULL,
    [TermMonths]           INT           NULL,
    [Rate]                 DECIMAL (12)  NULL,
    [IsTermRange]          TINYINT       NULL
);


GO
CREATE NONCLUSTERED INDEX [ndx_RateSelect]
    ON [dbo].[DailyPricingLegacyRatesTemp]([MarketID] ASC, [UtilityID] ASC, [ZoneID] ASC, [ServiceClassID] ASC, [ChannelGroupID] ASC, [AccountTypeID] ASC, [ChannelTypeID] ASC, [ProductTypeID] ASC) WITH (FILLFACTOR = 100, PAD_INDEX = ON);

