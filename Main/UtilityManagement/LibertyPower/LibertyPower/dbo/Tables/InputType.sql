CREATE TABLE [dbo].[InputType] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [TypeDescription] VARCHAR (200) NOT NULL,
    [DateCreated]     DATETIME      NOT NULL,
    [CreatedBy]       INT           NOT NULL,
    [DateModified]    DATETIME      NULL,
    [ModifiedBy]      INT           NULL,
    CONSTRAINT [PK_InputType] PRIMARY KEY CLUSTERED ([ID] ASC)
);

