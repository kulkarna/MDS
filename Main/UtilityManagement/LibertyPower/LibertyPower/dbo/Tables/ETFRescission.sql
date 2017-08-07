CREATE TABLE [dbo].[ETFRescission] (
    [ETFRescissionID]         INT      IDENTITY (1, 1) NOT NULL,
    [UtilityID]               INT      NULL,
    [AccountTypeID]           INT      NULL,
    [ContractTypeID]          INT      NULL,
    [DaysAfterWelcomeLetter]  INT      NULL,
    [DaysAfterContractSubmit] INT      NULL,
    [DaysAfterUtilityLetter]  INT      NULL,
    [DateCreated]             DATETIME CONSTRAINT [DF_ETFRescission_DateCreated] DEFAULT (getdate()) NULL
);

