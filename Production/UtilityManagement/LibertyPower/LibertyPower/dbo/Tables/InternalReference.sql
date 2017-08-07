CREATE TABLE [dbo].[InternalReference] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [InternalReference] VARCHAR (100) NOT NULL,
    [DateCreated]       DATETIME      NOT NULL,
    [CreatedBy]         INT           NOT NULL,
    [DateModified]      DATETIME      NULL,
    [ModifiedBy]        INT           NULL,
    CONSTRAINT [PK_InternalReference] PRIMARY KEY CLUSTERED ([ID] ASC)
);

