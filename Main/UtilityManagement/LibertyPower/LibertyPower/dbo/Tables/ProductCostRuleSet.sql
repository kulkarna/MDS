CREATE TABLE [dbo].[ProductCostRuleSet] (
    [ProductCostRuleSetID] INT              IDENTITY (1, 1) NOT NULL,
    [EffectiveDate]        DATETIME         NOT NULL,
    [ExpirationDate]       DATETIME         NOT NULL,
    [FileGuid]             UNIQUEIDENTIFIER NOT NULL,
    [UploadedBy]           INT              NOT NULL,
    [UploadedDate]         DATETIME         NOT NULL,
    [UploadStatus]         INT              NULL,
    CONSTRAINT [PK_ProductCostRuleSet] PRIMARY KEY CLUSTERED ([ProductCostRuleSetID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductCostRuleSet_FileContext] FOREIGN KEY ([FileGuid]) REFERENCES [dbo].[FileContext] ([FileGuid])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductCostRuleSet';

