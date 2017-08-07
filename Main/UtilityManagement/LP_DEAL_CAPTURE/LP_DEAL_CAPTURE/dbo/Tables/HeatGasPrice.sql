CREATE TABLE [dbo].[HeatGasPrice] (
    [ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [DealPricingDetailID] INT            NOT NULL,
    [Month]               INT            NOT NULL,
    [GasPrice]            DECIMAL (9, 6) NULL,
    [Inactive]            BIT            CONSTRAINT [DF_HeatGasPrice_Inactive] DEFAULT ((0)) NULL,
    [DatePriceLocked]     DATETIME       NULL,
    [DateCreated]         DATETIME       CONSTRAINT [DF_HeatGasPrice_DateCreated] DEFAULT (getdate()) NULL,
    [DateModified]        DATETIME       NULL,
    CONSTRAINT [PK_HeatGasPrice] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([DealPricingDetailID]) REFERENCES [dbo].[deal_pricing_detail] ([deal_pricing_detail_id])
);

