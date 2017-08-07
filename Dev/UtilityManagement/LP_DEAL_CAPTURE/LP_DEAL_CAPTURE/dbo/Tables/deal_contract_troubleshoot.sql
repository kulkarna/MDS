CREATE TABLE [dbo].[deal_contract_troubleshoot] (
    [contract_nbr]       CHAR (12)     NULL,
    [sales_channel_role] NVARCHAR (50) NULL,
    [sales_rep]          VARCHAR (5)   NULL,
    [username]           NCHAR (100)   NULL,
    [line]               INT           NULL,
    [sproc]              VARCHAR (50)  NULL,
    [rows_affected]      INT           NULL,
    [insert_date]        DATETIME      CONSTRAINT [DF_deal_contract_troubleshoot_insert_date] DEFAULT (getdate()) NOT NULL
);

