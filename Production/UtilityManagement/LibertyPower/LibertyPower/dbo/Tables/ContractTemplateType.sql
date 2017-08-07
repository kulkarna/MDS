CREATE TABLE [dbo].[ContractTemplateType] (
    [ContractTemplateTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Type]                   VARCHAR (50) NOT NULL,
    [Sequence]               INT          NOT NULL,
    [Active]                 BIT          NOT NULL,
    [DateCreated]            DATETIME     CONSTRAINT [DF_ContractTemplateType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ContractTemplateType] PRIMARY KEY CLUSTERED ([ContractTemplateTypeID] ASC)
);

