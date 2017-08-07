CREATE TABLE [dbo].[zAudit_campaign_status] (
    [campaign_id]           INT          NULL,
    [status]                VARCHAR (15) NULL,
    [sub_status]            VARCHAR (15) NULL,
    [audit_change_type]     CHAR (3)     NOT NULL,
    [audit_change_dt]       DATETIME     CONSTRAINT [DF_zAuditcampaign_status__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30) CONSTRAINT [DF_zAuditcampaign_status__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30) CONSTRAINT [DF_zAuditcampaign_status__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

