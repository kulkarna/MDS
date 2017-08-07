CREATE TABLE [dbo].[CreditAgency] (
    [CreditAgencyID]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]               NVARCHAR (50) NOT NULL,
    [Code]               VARCHAR (30)  NULL,
    [TypeOfCreditAgency] CHAR (1)      NOT NULL,
    [SortOrder]          INT           NULL,
    [DateCreated]        DATETIME      CONSTRAINT [DF_CreditAgency_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_CreditAgency] PRIMARY KEY CLUSTERED ([CreditAgencyID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CreditAgency';

