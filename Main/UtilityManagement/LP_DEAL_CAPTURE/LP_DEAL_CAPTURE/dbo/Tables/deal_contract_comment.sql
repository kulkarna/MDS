CREATE TABLE [dbo].[deal_contract_comment] (
    [contract_nbr] CHAR (12)     NULL,
    [date_comment] DATETIME      NOT NULL,
    [process_id]   VARCHAR (20)  NULL,
    [comment]      VARCHAR (MAX) NULL,
    [username]     NCHAR (100)   NULL,
    [chgstamp]     SMALLINT      NOT NULL
);

