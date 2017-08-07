CREATE TABLE [dbo].[zAudit_account_meters] (
    [account_id]            CHAR (12)    NULL,
    [meter_number]          VARCHAR (50) NULL,
    [audit_change_type]     CHAR (3)     NOT NULL,
    [audit_change_dt]       DATETIME     CONSTRAINT [DF_zAuditaccount_meters__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30) CONSTRAINT [DF_zAuditaccount_meters__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30) CONSTRAINT [DF_zAuditaccount_meters__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

