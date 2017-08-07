CREATE TABLE [dbo].[zAudit_campaign] (
    [campaign_id]           INT            NULL,
    [title]                 VARCHAR (500)  NULL,
    [description]           VARCHAR (5000) NULL,
    [start_date]            DATETIME       NULL,
    [end_date]              DATETIME       NULL,
    [date_type]             VARCHAR (50)   NULL,
    [date_created]          DATETIME       NULL,
    [audit_change_type]     CHAR (3)       NOT NULL,
    [audit_change_dt]       DATETIME       CONSTRAINT [DF_zAuditcampaign__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30)   CONSTRAINT [DF_zAuditcampaign__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30)   CONSTRAINT [DF_zAuditcampaign__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

