CREATE TABLE [dbo].[zAudit_deal_contract_error] (
    [process_id]            VARCHAR (15)  NULL,
    [contract_nbr]          VARCHAR (25)  NULL,
    [account_number]        VARCHAR (30)  NULL,
    [application]           VARCHAR (20)  NULL,
    [error]                 CHAR (1)      NULL,
    [msg_id]                VARCHAR (50)  NULL,
    [descp_add]             VARCHAR (100) NULL,
    [audit_change_type]     CHAR (3)      NOT NULL,
    [audit_change_dt]       DATETIME      CONSTRAINT [DF_zAuditdeal_contract_error__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30)  CONSTRAINT [DF_zAuditdeal_contract_error__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30)  CONSTRAINT [DF_zAuditdeal_contract_error__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

