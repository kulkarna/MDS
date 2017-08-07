CREATE TABLE [dbo].[SourceType] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [SourceTypeDesc] VARCHAR (200) NOT NULL,
    [DateCreated]    DATETIME      NOT NULL,
    [CreatedBy]      INT           NOT NULL,
    [DateModified]   DATETIME      NULL,
    [ModifiedBy]     INT           NULL,
    CONSTRAINT [PK_SourceType] PRIMARY KEY CLUSTERED ([ID] ASC)
);

