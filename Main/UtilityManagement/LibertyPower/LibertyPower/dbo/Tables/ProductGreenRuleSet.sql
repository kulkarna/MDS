CREATE TABLE [dbo].[ProductGreenRuleSet] (
    [ProductGreenRuleSetID] INT              IDENTITY (1, 1) NOT NULL,
    [FileGuid]              UNIQUEIDENTIFIER NOT NULL,
    [UploadedBy]            INT              NOT NULL,
    [UploadedDate]          DATETIME         NOT NULL,
    [UploadStatus]          INT              NULL,
    CONSTRAINT [PK_ProductGreenRuleSet] PRIMARY KEY CLUSTERED ([ProductGreenRuleSetID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductGreenRuleSet_FileContext] FOREIGN KEY ([FileGuid]) REFERENCES [dbo].[FileContext] ([FileGuid])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductGreenRuleSet';

