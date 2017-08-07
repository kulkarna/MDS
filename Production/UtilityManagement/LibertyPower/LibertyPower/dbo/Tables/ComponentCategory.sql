CREATE TABLE [dbo].[ComponentCategory] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [CompCatCode]        VARCHAR (20)  NOT NULL,
    [CompCatDescription] VARCHAR (200) NOT NULL,
    [DateCreated]        DATETIME      NOT NULL,
    [CreatedBy]          INT           NOT NULL,
    [DateModified]       DATETIME      NOT NULL,
    [ModifiedBy]         INT           NOT NULL,
    CONSTRAINT [PK_ComponentCategory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

