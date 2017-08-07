CREATE TABLE [dbo].[ContractStatus] (
    [ContractStatusID] INT          IDENTITY (1, 1) NOT NULL,
    [Descp]            VARCHAR (50) NOT NULL,
    [DateCreated]      DATETIME     CONSTRAINT [DF_ContractStatus_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ContractStatus] PRIMARY KEY CLUSTERED ([ContractStatusID] ASC)
);

