﻿CREATE TABLE [dbo].[zAudit_multi_rate_product] (
    [contract_nbr]          CHAR (12)    NULL,
    [product_id]            CHAR (20)    NULL,
    [audit_change_type]     CHAR (3)     NOT NULL,
    [audit_change_dt]       DATETIME     CONSTRAINT [DF_zAuditmulti_rate_product__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30) CONSTRAINT [DF_zAuditmulti_rate_product__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30) CONSTRAINT [DF_zAuditmulti_rate_product__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

