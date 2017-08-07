CREATE TABLE [dbo].[DailyPricingUpdateLegacyRates_Stage] (
    [StagingID]       INT            IDENTITY (1, 1) NOT NULL,
    [IsProcessed]     BIT            CONSTRAINT [DF_DailyPricingUpdateLegacyRates_Stage_IsProcessed] DEFAULT ((0)) NOT NULL,
    [ProductId]       VARCHAR (20)   NOT NULL,
    [RateId]          INT            NULL,
    [Rate]            FLOAT (53)     NULL,
    [Terms]           INT            NULL,
    [EffDate]         DATETIME       NULL,
    [DueDate]         DATETIME       NULL,
    [GrossMargin]     DECIMAL (9, 6) NULL,
    [RateDescription] VARCHAR (250)  NULL,
    CONSTRAINT [PK_DailyPricingUpdateLegacyRates_Stage] PRIMARY KEY CLUSTERED ([StagingID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingUpdateLegacyRates_Stage';

