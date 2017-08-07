﻿CREATE TABLE [dbo].[tbl_usp_contract_deal_ins_err] (
    [contract_nbr]              CHAR (12)      NULL,
    [contract_type]             VARCHAR (25)   NULL,
    [account_number]            VARCHAR (30)   NULL,
    [status]                    VARCHAR (15)   NULL,
    [account_id]                CHAR (12)      NULL,
    [retail_mkt_id]             CHAR (2)       NULL,
    [utility_id]                CHAR (15)      NULL,
    [account_type]              INT            NULL,
    [product_id]                CHAR (20)      NULL,
    [rate_id]                   INT            NULL,
    [rate]                      FLOAT (53)     NULL,
    [account_name_link]         INT            NULL,
    [customer_name_link]        INT            NULL,
    [customer_address_link]     INT            NULL,
    [customer_contact_link]     INT            NULL,
    [billing_address_link]      INT            NULL,
    [billing_contact_link]      INT            NULL,
    [owner_name_link]           INT            NULL,
    [service_address_link]      INT            NULL,
    [business_type]             VARCHAR (35)   NULL,
    [business_activity]         VARCHAR (35)   NULL,
    [additional_id_nbr_type]    VARCHAR (10)   NULL,
    [additional_id_nbr]         VARCHAR (30)   NULL,
    [contract_eff_start_date]   DATETIME       NULL,
    [enrollment_type]           INT            NULL,
    [term_months]               INT            NULL,
    [date_end]                  DATETIME       NULL,
    [date_deal]                 DATETIME       NULL,
    [date_created]              DATETIME       NULL,
    [date_submit]               DATETIME       NULL,
    [sales_channel_role]        NVARCHAR (50)  NULL,
    [username]                  NCHAR (100)    NULL,
    [sales_rep]                 VARCHAR (100)  NULL,
    [origin]                    VARCHAR (50)   NULL,
    [grace_period]              INT            NULL,
    [chgstamp]                  SMALLINT       NULL,
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
    [evergreen_commission_rate] FLOAT (53)     NULL,
    [ProcessDate]               DATETIME       NULL,
    [ProcessUser]               VARCHAR (60)   NULL,
    [ErrorText]                 VARCHAR (300)  NULL
);
