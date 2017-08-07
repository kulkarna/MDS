CREATE TABLE [dbo].[DailyPricingTemplateTags] (
    [ID]                          INT            IDENTITY (1, 1) NOT NULL,
    [SheetTemplate]               VARCHAR (500)  NULL,
    [SheetName]                   VARCHAR (500)  NULL,
    [HeaderTag]                   VARCHAR (1000) NULL,
    [Footer1Tag]                  VARCHAR (1000) NULL,
    [Footer2Tag]                  VARCHAR (1000) NULL,
    [ExpirationTag]               VARCHAR (100)  NULL,
    [HeaderStatementTag]          VARCHAR (100)  NULL,
    [SubmissionStatementTag]      VARCHAR (100)  NULL,
    [CustomerClassStatementTag]   VARCHAR (100)  NULL,
    [ProductTaxStatementTag]      VARCHAR (100)  NULL,
    [ConfidentialityStatementTag] VARCHAR (100)  NULL,
    [SizeRequirementTag]          VARCHAR (100)  NULL,
    [MarketTag]                   VARCHAR (100)  NULL,
    [UtilityTag]                  VARCHAR (100)  NULL,
    [SegmentTag]                  VARCHAR (100)  NULL,
    [ChannelTypeTag]              VARCHAR (100)  NULL,
    [ZoneTag]                     VARCHAR (100)  NULL,
    [ServiceClassTag]             VARCHAR (100)  NULL,
    [StartDateTag]                VARCHAR (100)  NULL,
    [TermTag]                     VARCHAR (100)  NULL,
    [PriceTag]                    VARCHAR (100)  NULL,
    [SalesChannelTag]             VARCHAR (100)  NULL,
    [DateTimeTag]                 VARCHAR (100)  NULL,
    [WorkbookAllowEditing]        TINYINT        NULL,
    [WorkbookPassword]            VARCHAR (100)  NULL,
    [PromoMessage]                VARCHAR (1000) NULL,
    CONSTRAINT [PK_DailyPricingTemplateTags3] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingTemplateTags';

