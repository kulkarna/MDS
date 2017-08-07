CREATE TABLE [dbo].[ProductCostRuleSetupSet] (
    [ProductCostRuleSetupSetID] INT              IDENTITY (1, 1) NOT NULL,
    [FileGuid]                  UNIQUEIDENTIFIER NOT NULL,
    [UploadedBy]                INT              NOT NULL,
    [UploadedDate]              DATETIME         NOT NULL,
    [UploadStatus]              INT              NULL,
    CONSTRAINT [PK_ProductCostRuleSetupSet] PRIMARY KEY CLUSTERED ([ProductCostRuleSetupSetID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductCostRuleSetupSet_FileContext] FOREIGN KEY ([FileGuid]) REFERENCES [dbo].[FileContext] ([FileGuid])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductCostRuleSetupSet';

