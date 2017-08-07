CREATE TABLE [dbo].[ContractDealType] (
    [ContractDealTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [DealType]           VARCHAR (50) NOT NULL,
    [Sequence]           INT          CONSTRAINT [DF_ContractDealType_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]             BIT          CONSTRAINT [DF_ContractDealType_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]        DATETIME     CONSTRAINT [DF_ContractDealType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ContractDealType] PRIMARY KEY CLUSTERED ([ContractDealTypeID] ASC)
);

