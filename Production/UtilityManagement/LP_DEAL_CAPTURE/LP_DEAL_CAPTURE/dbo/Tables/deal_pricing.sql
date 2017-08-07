CREATE TABLE [dbo].[deal_pricing] (
    [deal_pricing_id]    INT          IDENTITY (1, 1) NOT NULL,
    [account_name]       VARCHAR (50) NOT NULL,
    [sales_channel_role] VARCHAR (50) NOT NULL,
    [commission_rate]    FLOAT (53)   NULL,
    [date_expired]       DATETIME     NULL,
    [date_created]       DATETIME     CONSTRAINT [DF_deal_pricing_date_created] DEFAULT (getdate()) NOT NULL,
    [username]           VARCHAR (50) NOT NULL,
    [date_modified]      DATETIME     NULL,
    [modified_by]        VARCHAR (50) NULL,
    [pricing_request_id] VARCHAR (50) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_deal_pricing]
    ON [dbo].[deal_pricing]([deal_pricing_id] ASC);


GO
CREATE NONCLUSTERED INDEX [deal_pricing__date_expired_I]
    ON [dbo].[deal_pricing]([date_expired] ASC)
    INCLUDE([deal_pricing_id], [sales_channel_role]);

