CREATE TABLE [dbo].[common_retail_market_table] (
    [retail_mkt_id]              CHAR (2)     NOT NULL,
    [retail_mkt_descp]           VARCHAR (50) NOT NULL,
    [wholesale_mkt_id]           CHAR (10)    NOT NULL,
    [puc_certification_number]   VARCHAR (20) NOT NULL,
    [date_created]               DATETIME     NOT NULL,
    [username]                   NCHAR (100)  NOT NULL,
    [inactive_ind]               CHAR (1)     NOT NULL,
    [active_date]                DATETIME     NOT NULL,
    [chgstamp]                   SMALLINT     NOT NULL,
    [transfer_ownership_enabled] SMALLINT     NOT NULL
);

