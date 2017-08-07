CREATE TABLE [dbo].[zAudit_deal_contract_default] (
    [contract_type]          VARCHAR (25)   NULL,
    [utility_id]             CHAR (15)      NULL,
    [account_type]           VARCHAR (35)   NULL,
    [product_id]             CHAR (20)      NULL,
    [rate_id]                INT            NULL,
    [business_type]          VARCHAR (35)   NULL,
    [business_activity]      VARCHAR (35)   NULL,
    [additional_id_nbr_type] VARCHAR (10)   NULL,
    [additional_id_nbr]      VARCHAR (30)   NULL,
    [term_months]            INT            NULL,
    [sales_channel_role]     NVARCHAR (100) NULL,
    [sales_rep]              VARCHAR (5)    NULL,
    [chgstamp]               SMALLINT       NULL,
    [audit_change_type]      CHAR (3)       NOT NULL,
    [audit_change_dt]        DATETIME       CONSTRAINT [DF_zAuditdeal_contract_default__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]        VARCHAR (30)   CONSTRAINT [DF_zAuditdeal_contract_default__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location]  VARCHAR (30)   CONSTRAINT [DF_zAuditdeal_contract_default__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

