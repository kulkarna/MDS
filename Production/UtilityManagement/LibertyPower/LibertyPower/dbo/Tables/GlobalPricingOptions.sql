CREATE TABLE [dbo].[GlobalPricingOptions] (
    [ID]             INT             IDENTITY (1, 1) NOT NULL,
    [UsageTolerance] DECIMAL (12, 6) NULL,
    CONSTRAINT [PK_GlobalPricingOptions] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Allowed differential between estimated and actual usage expressed as a percentage.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GlobalPricingOptions', @level2type = N'COLUMN', @level2name = N'UsageTolerance';

