CREATE TABLE [dbo].[deal_contract] (
    [contract_nbr]              CHAR (12)      NOT NULL,
    [contract_type]             VARCHAR (20)   NOT NULL,
    [status]                    VARCHAR (15)   NOT NULL,
    [retail_mkt_id]             CHAR (2)       NOT NULL,
    [utility_id]                CHAR (15)      NOT NULL,
    [account_type]              INT            NULL,
    [product_id]                CHAR (20)      NOT NULL,
    [rate_id]                   INT            NOT NULL,
    [rate]                      FLOAT (53)     NOT NULL,
    [customer_name_link]        INT            NOT NULL,
    [customer_address_link]     INT            NOT NULL,
    [customer_contact_link]     INT            NOT NULL,
    [billing_address_link]      INT            NOT NULL,
    [billing_contact_link]      INT            NOT NULL,
    [owner_name_link]           INT            NOT NULL,
    [service_address_link]      INT            NOT NULL,
    [business_type]             VARCHAR (35)   NOT NULL,
    [business_activity]         VARCHAR (35)   NOT NULL,
    [additional_id_nbr_type]    VARCHAR (10)   NOT NULL,
    [additional_id_nbr]         VARCHAR (30)   NOT NULL,
    [contract_eff_start_date]   DATETIME       NOT NULL,
    [enrollment_type]           INT            NULL,
    [term_months]               INT            NOT NULL,
    [date_end]                  DATETIME       NOT NULL,
    [date_deal]                 DATETIME       NOT NULL,
    [date_created]              DATETIME       NOT NULL,
    [date_submit]               DATETIME       NOT NULL,
    [sales_channel_role]        NVARCHAR (50)  NOT NULL,
    [username]                  NCHAR (100)    NOT NULL,
    [sales_rep]                 VARCHAR (100)  NOT NULL,
    [origin]                    VARCHAR (50)   NOT NULL,
    [grace_period]              INT            NOT NULL,
    [chgstamp]                  SMALLINT       NOT NULL,
    [contract_rate_type]        VARCHAR (50)   NULL,
    [requested_flow_start_date] DATETIME       NULL,
    [deal_type]                 CHAR (20)      NULL,
    [customer_code]             CHAR (5)       NULL,
    [customer_group]            CHAR (100)     NULL,
    [SSNClear]                  NVARCHAR (100) NULL,
    [SSNEncrypted]              NVARCHAR (512) NULL,
    [CreditScoreEncrypted]      NVARCHAR (512) NULL,
    [HeatIndexSourceID]         INT            NULL,
    [HeatRate]                  DECIMAL (9, 2) NULL,
    [evergreen_option_id]       INT            NULL,
    [evergreen_commission_end]  DATETIME       NULL,
    [residual_option_id]        INT            NULL,
    [residual_commission_end]   DATETIME       NULL,
    [initial_pymt_option_id]    INT            NULL,
    [sales_manager]             VARCHAR (100)  NULL,
    [evergreen_commission_rate] FLOAT (53)     NULL,
    [TaxStatus]                 INT            NULL,
    [PriceID]                   BIGINT         NULL,
    [PriceTier]                 INT            NULL,
    [RatesString]               VARCHAR (200)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [deal_contract_idx]
    ON [dbo].[deal_contract]([contract_nbr] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [deal_contract_idx1]
    ON [dbo].[deal_contract]([status] ASC, [contract_nbr] ASC);


GO
CREATE NONCLUSTERED INDEX [deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status]
    ON [dbo].[deal_contract]([sales_channel_role] ASC, [contract_nbr] ASC)
    INCLUDE([date_deal], [status]);

