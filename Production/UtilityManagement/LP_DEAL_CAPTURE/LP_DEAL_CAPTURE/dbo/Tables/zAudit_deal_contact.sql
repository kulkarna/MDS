CREATE TABLE [dbo].[zAudit_deal_contact] (
    [contract_nbr]          CHAR (12)      NULL,
    [contact_link]          INT            NULL,
    [first_name]            VARCHAR (50)   NULL,
    [last_name]             VARCHAR (50)   NULL,
    [title]                 VARCHAR (20)   NULL,
    [phone]                 VARCHAR (20)   NULL,
    [fax]                   VARCHAR (20)   NULL,
    [email]                 NVARCHAR (512) NULL,
    [birthday]              VARCHAR (5)    NULL,
    [chgstamp]              SMALLINT       NULL,
    [audit_change_type]     CHAR (3)       NOT NULL,
    [audit_change_dt]       DATETIME       CONSTRAINT [DF_zAuditdeal_contact__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30)   CONSTRAINT [DF_zAuditdeal_contact__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30)   CONSTRAINT [DF_zAuditdeal_contact__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

