CREATE TABLE [dbo].[zAudit_deal_name] (
    [contract_nbr]          CHAR (12)     NULL,
    [name_link]             INT           NULL,
    [full_name]             VARCHAR (100) NULL,
    [chgstamp]              SMALLINT      NULL,
    [audit_change_type]     CHAR (3)      NOT NULL,
    [audit_change_dt]       DATETIME      CONSTRAINT [DF_zAuditdeal_name__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30)  CONSTRAINT [DF_zAuditdeal_name__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30)  CONSTRAINT [DF_zAuditdeal_name__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

