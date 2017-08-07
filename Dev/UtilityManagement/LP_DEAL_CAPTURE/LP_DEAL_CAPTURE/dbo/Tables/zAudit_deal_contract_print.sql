CREATE TABLE [dbo].[zAudit_deal_contract_print] (
    [request_id]               VARCHAR (20) NULL,
    [status]                   VARCHAR (15) NULL,
    [contract_nbr]             CHAR (12)    NULL,
    [username]                 NCHAR (1)    NULL,
    [retail_mkt_id]            CHAR (2)     NULL,
    [puc_certification_number] VARCHAR (20) NULL,
    [utility_id]               CHAR (15)    NULL,
    [product_id]               CHAR (20)    NULL,
    [rate_id]                  INT          NULL,
    [rate]                     FLOAT (53)   NULL,
    [rate_descp]               VARCHAR (50) NULL,
    [term_months]              INT          NULL,
    [contract_eff_start_date]  DATETIME     NULL,
    [grace_period]             INT          NULL,
    [date_created]             DATETIME     NULL,
    [contract_template]        VARCHAR (25) NULL,
    [audit_change_type]        CHAR (3)     NOT NULL,
    [audit_change_dt]          DATETIME     CONSTRAINT [DF_zAuditdeal_contract_print__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]          VARCHAR (30) CONSTRAINT [DF_zAuditdeal_contract_print__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location]    VARCHAR (30) CONSTRAINT [DF_zAuditdeal_contract_print__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

