CREATE TABLE [dbo].[DailyPricingTemplateConfiguration] (
    [ID]                       INT            IDENTITY (1, 1) NOT NULL,
    [SegmentID]                INT            NULL,
    [ChannelTypeID]            INT            NULL,
    [ChannelGroupID]           INT            NULL,
    [MarketID]                 INT            NULL,
    [UtilityID]                INT            NULL,
    [HeaderStatement]          VARCHAR (1000) NULL,
    [SizeRequirement]          VARCHAR (500)  NULL,
    [SubmissionStatement]      VARCHAR (1000) NULL,
    [CustomerClassStatement]   VARCHAR (1000) NULL,
    [ProductTaxStatement]      VARCHAR (1000) NULL,
    [ConfidentialityStatement] VARCHAR (1000) NULL,
    [Header]                   VARCHAR (1000) NULL,
    [Footer1]                  VARCHAR (1000) NULL,
    [Footer2]                  VARCHAR (1000) NULL,
    [PromoMessage]             VARCHAR (1000) NULL,
    [PromoImageFileGuid]       VARCHAR (100)  NULL,
    CONSTRAINT [PK_DailyPricingTemplateConfiguration3] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingTemplateConfiguration';

