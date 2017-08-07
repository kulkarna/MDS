CREATE TABLE [dbo].[ValueType] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [ValueDescription] VARCHAR (200) NOT NULL,
    [DateCreated]      DATETIME      NOT NULL,
    [CreatedBy]        INT           NOT NULL,
    [DateModified]     DATETIME      NULL,
    [ModifiedBy]       INT           NULL,
    CONSTRAINT [PK_ValueType] PRIMARY KEY CLUSTERED ([ID] ASC)
);

