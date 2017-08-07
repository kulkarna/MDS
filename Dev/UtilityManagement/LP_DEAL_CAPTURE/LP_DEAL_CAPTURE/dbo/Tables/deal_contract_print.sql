CREATE TABLE [dbo].[deal_contract_print] (
    [request_id]               VARCHAR (20)   NOT NULL,
    [status]                   VARCHAR (15)   NOT NULL,
    [contract_nbr]             CHAR (12)      NOT NULL,
    [username]                 NCHAR (100)    NOT NULL,
    [retail_mkt_id]            CHAR (2)       NOT NULL,
    [puc_certification_number] VARCHAR (20)   NOT NULL,
    [utility_id]               CHAR (15)      NOT NULL,
    [product_id]               CHAR (20)      NOT NULL,
    [rate_id]                  INT            NOT NULL,
    [rate]                     FLOAT (53)     NOT NULL,
    [rate_descp]               VARCHAR (50)   NOT NULL,
    [term_months]              INT            NOT NULL,
    [contract_eff_start_date]  DATETIME       NOT NULL,
    [grace_period]             INT            NOT NULL,
    [date_created]             DATETIME       NOT NULL,
    [contract_template]        VARCHAR (25)   NOT NULL,
    [contract_rate_type]       VARCHAR (50)   NULL,
    [TemplateId]               INT            NULL,
    [sales_channel_role]       NVARCHAR (50)  NULL,
    [PriceID]                  BIGINT         NULL,
    [PriceTier]                INT            NULL,
    [RateString]               NVARCHAR (200) NULL,
    [SubTermString]            NVARCHAR (50)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [deal_contract_print_idx]
    ON [dbo].[deal_contract_print]([request_id] ASC, [contract_nbr] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [deal_contract_print_idx1]
    ON [dbo].[deal_contract_print]([contract_nbr] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [deal_contract_print_idx2]
    ON [dbo].[deal_contract_print]([username] ASC, [request_id] ASC, [contract_nbr] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Added field to capture same info as other new contract tables', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'deal_contract_print', @level2type = N'COLUMN', @level2name = N'sales_channel_role';

