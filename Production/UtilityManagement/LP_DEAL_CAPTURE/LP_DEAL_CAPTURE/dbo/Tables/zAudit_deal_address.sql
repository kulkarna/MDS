CREATE TABLE [dbo].[zAudit_deal_address] (
    [contract_nbr]          CHAR (12)    NULL,
    [address_link]          INT          NULL,
    [address]               CHAR (50)    NULL,
    [suite]                 CHAR (10)    NULL,
    [city]                  CHAR (28)    NULL,
    [state]                 CHAR (2)     NULL,
    [zip]                   CHAR (10)    NULL,
    [county]                CHAR (10)    NULL,
    [state_fips]            CHAR (2)     NULL,
    [county_fips]           CHAR (3)     NULL,
    [chgstamp]              SMALLINT     NULL,
    [audit_change_type]     CHAR (3)     NOT NULL,
    [audit_change_dt]       DATETIME     CONSTRAINT [DF_zAuditdeal_address__audit_change_dt] DEFAULT (getdate()) NOT NULL,
    [audit_change_by]       VARCHAR (30) CONSTRAINT [DF_zAuditdeal_address__audit_change_by] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [audit_change_location] VARCHAR (30) CONSTRAINT [DF_zAuditdeal_address__audit_change_location] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);

