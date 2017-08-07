CREATE TABLE [dbo].[contract_tracking_details] (
    [transaction_id]     VARCHAR (50)  NOT NULL,
    [account_number]     VARCHAR (25)  NOT NULL,
    [account_name]       VARCHAR (100) NOT NULL,
    [retail_mkt_id]      CHAR (15)     NOT NULL,
    [utility_id]         CHAR (12)     NOT NULL,
    [entity_id]          NCHAR (15)    NOT NULL,
    [product_id]         CHAR (20)     NOT NULL,
    [rate_id]            INT           NOT NULL,
    [rate]               FLOAT (53)    NOT NULL,
    [por_option]         CHAR (3)      NOT NULL,
    [account_type]       VARCHAR (35)  NOT NULL,
    [business_activity]  VARCHAR (35)  NOT NULL,
    [customer_id]        VARCHAR (10)  NOT NULL,
    [contract_type]      VARCHAR (15)  NOT NULL,
    [contract_nbr]       CHAR (12)     NOT NULL,
    [sales_rep]          VARCHAR (5)   NOT NULL,
    [sales_channel_role] VARCHAR (50)  NOT NULL,
    [eff_start_date]     DATETIME      NOT NULL,
    [end_date]           DATETIME      NOT NULL,
    [term_months]        INT           NOT NULL,
    [deal_date]          DATETIME      NOT NULL,
    [submit_date]        DATETIME      NOT NULL,
    [flow_start_date]    DATETIME      NOT NULL,
    [enrollment_type]    INT           NOT NULL,
    [tax_status]         VARCHAR (20)  NOT NULL,
    [tax_float]          INT           NOT NULL,
    [annual_usage]       BIGINT        NOT NULL,
    [date_created]       DATETIME      NOT NULL,
    [service_address]    CHAR (50)     NOT NULL,
    [service_suite]      CHAR (50)     NOT NULL,
    [service_city]       CHAR (50)     NOT NULL,
    [service_state]      CHAR (2)      NOT NULL,
    [service_zip]        CHAR (10)     NOT NULL,
    [billing_address]    CHAR (50)     NOT NULL,
    [billing_suite]      CHAR (50)     NOT NULL,
    [billing_city]       CHAR (50)     NOT NULL,
    [billing_state]      CHAR (2)      NOT NULL,
    [billing_zip]        CHAR (10)     NOT NULL,
    [origin]             VARCHAR (15)  NOT NULL,
    [status]             VARCHAR (15)  NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [contract_tracking_detials_ndx]
    ON [dbo].[contract_tracking_details]([transaction_id] ASC, [account_number] ASC);

