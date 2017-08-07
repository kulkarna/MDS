CREATE TABLE [dbo].[common_wholesale_market_table] (
    [wholesale_mkt_id]    CHAR (10)    NOT NULL,
    [wholesale_mkt_descp] VARCHAR (50) NOT NULL,
    [date_created]        DATETIME     NOT NULL,
    [username]            NCHAR (100)  NOT NULL,
    [inactive_ind]        CHAR (1)     NOT NULL,
    [active_date]         DATETIME     NOT NULL,
    [chgstamp]            SMALLINT     NOT NULL
);

