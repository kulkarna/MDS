CREATE TABLE [dbo].[RateCodeDailyPricingSheetErrors] (
    [ID]          INT            NULL,
    [Error]       NVARCHAR (256) NULL,
    [DateCreated] DATETIME       NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RateCodeDailyPricingSheetErrors';

