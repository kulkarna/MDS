CREATE TABLE [dbo].[CurveDefinition] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [CurveName]          VARCHAR (200) NOT NULL,
    [SourceTypeID]       INT           NOT NULL,
    [SourceLocation]     VARCHAR (200) NOT NULL,
    [TimeSeriesID]       INT           NOT NULL,
    [TSConvertToID]      INT           NULL,
    [ForecastRequired]   BIT           NOT NULL,
    [ForecastFunctionID] INT           NOT NULL,
    [DateCreated]        DATETIME      NOT NULL,
    [CreatedBy]          INT           NOT NULL,
    [DateModified]       DATETIME      NULL,
    [ModifiedBy]         INT           NULL,
    CONSTRAINT [PK_CurveDefinition] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_CurveDefinition_ForecastFunction] FOREIGN KEY ([ForecastFunctionID]) REFERENCES [dbo].[ForecastFunction] ([ID]),
    CONSTRAINT [FK_CurveDefinition_SourceType] FOREIGN KEY ([SourceTypeID]) REFERENCES [dbo].[SourceType] ([ID]),
    CONSTRAINT [FK_CurveDefinition_TimeSeries] FOREIGN KEY ([TimeSeriesID]) REFERENCES [dbo].[TimeSeries] ([ID])
);

