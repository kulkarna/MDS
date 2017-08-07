CREATE TABLE [dbo].[zAudit_campaign_detail] (
    [campaign_id]           INT          NULL,
    [contract_nbr]          CHAR (12)    NULL,
    [phone]                 VARCHAR (20) NULL,
    [utility_id]            CHAR (12)    NULL,
    [select]                INT          NULL,
    [origin]                VARCHAR (50) NULL,
    [username]              NCHAR (1)    NULL,
    [date_created]          DATETIME     NULL,
    [chgstamp]              SMALLINT     NULL,
    [audit_change_type]     CHAR (3)     NOT NULL,
    [audit_change_dt]       DATETIME     CONSTRAINT [DF_zAuditcampaign_detail__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30) CONSTRAINT [DF_zAuditcampaign_detail__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30) CONSTRAINT [DF_zAuditcampaign_detail__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

