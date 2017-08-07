CREATE TABLE [dbo].[PropertyRule] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [RuleCode]        VARCHAR (350) NULL,
    [RuleDescription] VARCHAR (MAX) NULL,
    [Inactive]        BIT           CONSTRAINT [DF_PropertyRule_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated]     DATETIME      CONSTRAINT [DF_PropertyRule_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT           NULL,
    [Modified]        DATETIME      NULL,
    [ModifiedBy]      INT           NULL,
    CONSTRAINT [PK_PropertyRule] PRIMARY KEY CLUSTERED ([ID] ASC)
);

