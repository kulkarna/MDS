CREATE TABLE [dbo].[UsageCLRLog] (
    [UsageCLRLogID] INT           IDENTITY (1, 1) NOT NULL,
    [contract_nbr]  VARCHAR (12)  NOT NULL,
    [contract_type] VARCHAR (25)  NULL,
    [date_created]  DATETIME      CONSTRAINT [DF_UsageCLRLog_date_created] DEFAULT (getdate()) NOT NULL,
    [error_msg]     VARCHAR (500) NULL
);

