CREATE TABLE [dbo].[ForecastFunction] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [FunctionDescription] VARCHAR (200) NOT NULL,
    [DateCreated]         DATETIME      NOT NULL,
    [CreatedBy]           INT           NOT NULL,
    [DateModified]        DATETIME      NULL,
    [ModifiedBy]          INT           NULL,
    CONSTRAINT [PK_ForecastFunction] PRIMARY KEY CLUSTERED ([ID] ASC)
);

