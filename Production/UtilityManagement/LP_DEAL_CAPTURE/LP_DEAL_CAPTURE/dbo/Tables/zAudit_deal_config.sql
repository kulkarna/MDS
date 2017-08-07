CREATE TABLE [dbo].[zAudit_deal_config] (
    [contract_grace_period]       INT           NULL,
    [email_role]                  INT           NULL,
    [contract_template_directory] VARCHAR (100) NULL,
    [enabled_check_user]          INT           NULL,
    [usage]                       FLOAT (53)    NULL,
    [header_enrollment_1]         VARCHAR (8)   NULL,
    [header_enrollment_2]         VARCHAR (8)   NULL,
    [audit_change_type]           CHAR (3)      NOT NULL,
    [audit_change_dt]             DATETIME      CONSTRAINT [DF_zAuditdeal_config__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]             VARCHAR (30)  CONSTRAINT [DF_zAuditdeal_config__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location]       VARCHAR (30)  CONSTRAINT [DF_zAuditdeal_config__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

