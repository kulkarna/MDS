CREATE TABLE [dbo].[deal_pricing_detail] (
    [deal_pricing_detail_id] INT            IDENTITY (1, 1) NOT NULL,
    [deal_pricing_id]        INT            NOT NULL,
    [product_id]             VARCHAR (50)   NOT NULL,
    [rate_id]                INT            NOT NULL,
    [date_created]           DATETIME       CONSTRAINT [DF_deal_pricing_details_date_created] DEFAULT (getdate()) NOT NULL,
    [username]               VARCHAR (50)   NULL,
    [date_modified]          DATETIME       NULL,
    [modified_by]            VARCHAR (50)   NULL,
    [rate_submit_ind]        BIT            CONSTRAINT [DF_deal_pricing_detail_is_submitted] DEFAULT ((0)) NOT NULL,
    [ContractRate]           DECIMAL (9, 6) CONSTRAINT [DF_deal_pricing_detail_ContractRate_1] DEFAULT ((0)) NOT NULL,
    [Commission]             DECIMAL (9, 6) CONSTRAINT [DF_deal_pricing_detail_Commission_1] DEFAULT ((0)) NOT NULL,
    [Cost]                   DECIMAL (9, 6) NULL,
    [MTM]                    DECIMAL (9, 6) NULL,
    [HasPassThrough]         INT            NULL,
    [BackToBack]             INT            NULL,
    [HeatIndexSourceID]      INT            NULL,
    [HeatRate]               DECIMAL (9, 2) NULL,
    [ExpectedTermUsage]      INT            NULL,
    [ExpectedAccountsAmount] INT            NULL,
    [ETP]                    DECIMAL (9, 6) NULL,
    [PriceID]                INT            NULL,
    [SelfGenerationID]       INT            NULL,
    CONSTRAINT [PK_deal_pricing_detail] PRIMARY KEY CLUSTERED ([deal_pricing_detail_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_deal_pricing_detail]
    ON [dbo].[deal_pricing_detail]([BackToBack] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_product_rate]
    ON [dbo].[deal_pricing_detail]([product_id] ASC, [rate_id] ASC)
    INCLUDE([ContractRate], [deal_pricing_id]);


GO
CREATE NONCLUSTERED INDEX [deal_pricing_detail__PriceID_I]
    ON [dbo].[deal_pricing_detail]([PriceID] ASC)
    INCLUDE([rate_submit_ind], [ContractRate]);

