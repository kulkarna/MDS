﻿CREATE TABLE [dbo].[zAudit_campaign_comment] (
    [campaign_id]           INT           NULL,
    [contract_nbr]          CHAR (12)     NULL,
    [date_comment]          DATETIME      NULL,
    [call_status]           VARCHAR (2)   NULL,
    [call_reason_code]      VARCHAR (5)   NULL,
    [comment]               VARCHAR (MAX) NULL,
    [nextcalldate]          DATETIME      NULL,
    [username]              NCHAR (1)     NULL,
    [chgstamp]              SMALLINT      NULL,
    [audit_change_type]     CHAR (3)      NOT NULL,
    [audit_change_dt]       DATETIME      CONSTRAINT [DF_zAuditcampaign_comment__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30)  CONSTRAINT [DF_zAuditcampaign_comment__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30)  CONSTRAINT [DF_zAuditcampaign_comment__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);
