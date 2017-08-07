CREATE TABLE [dbo].[deal_contract_default] (
    [contract_type]          VARCHAR (25)  NOT NULL,
    [utility_id]             CHAR (15)     NOT NULL,
    [account_type]           VARCHAR (35)  NOT NULL,
    [product_id]             CHAR (20)     NOT NULL,
    [rate_id]                INT           NOT NULL,
    [business_type]          VARCHAR (35)  NOT NULL,
    [business_activity]      VARCHAR (35)  NOT NULL,
    [additional_id_nbr_type] VARCHAR (10)  NOT NULL,
    [additional_id_nbr]      VARCHAR (30)  NOT NULL,
    [term_months]            INT           NOT NULL,
    [sales_channel_role]     NVARCHAR (50) NOT NULL,
    [sales_rep]              VARCHAR (5)   NOT NULL,
    [chgstamp]               SMALLINT      NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [deal_contract_default_idx]
    ON [dbo].[deal_contract_default]([contract_type] ASC, [utility_id] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

