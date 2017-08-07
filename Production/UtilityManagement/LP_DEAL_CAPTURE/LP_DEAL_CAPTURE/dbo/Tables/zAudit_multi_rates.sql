CREATE TABLE [dbo].[zAudit_multi_rates] (
    [contract_nbr]          CHAR (12)    NULL,
    [utility_id]            CHAR (15)    NULL,
    [utility_descp]         VARCHAR (50) NULL,
    [product_id]            CHAR (20)    NULL,
    [product_descp]         VARCHAR (50) NULL,
    [rate_id]               INT          NULL,
    [rate]                  FLOAT (53)   NULL,
    [rate_descp]            VARCHAR (50) NULL,
    [audit_change_type]     CHAR (3)     NOT NULL,
    [audit_change_dt]       DATETIME     CONSTRAINT [DF_zAuditmulti_rates__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30) CONSTRAINT [DF_zAuditmulti_rates__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30) CONSTRAINT [DF_zAuditmulti_rates__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

