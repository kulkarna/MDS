CREATE TABLE [dbo].[zAudit_deal_contract_batch] (
    [request_id]            VARCHAR (50) NULL,
    [contract_nbr]          VARCHAR (15) NULL,
    [contract_type]         VARCHAR (15) NULL,
    [audit_change_type]     CHAR (3)     NOT NULL,
    [audit_change_dt]       DATETIME     CONSTRAINT [DF_zAuditdeal_contract_batch__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30) CONSTRAINT [DF_zAuditdeal_contract_batch__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30) CONSTRAINT [DF_zAuditdeal_contract_batch__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

