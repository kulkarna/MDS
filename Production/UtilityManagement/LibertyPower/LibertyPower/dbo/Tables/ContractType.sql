CREATE TABLE [dbo].[ContractType] (
    [ContractTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Type]           VARCHAR (50) NOT NULL,
    [Sequence]       INT          CONSTRAINT [DF_ContractType_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]         BIT          CONSTRAINT [DF_ContractType_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]    DATETIME     CONSTRAINT [DF_ContractType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ContractType] PRIMARY KEY CLUSTERED ([ContractTypeID] ASC)
);

