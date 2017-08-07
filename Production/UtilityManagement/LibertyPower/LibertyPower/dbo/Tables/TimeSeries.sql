CREATE TABLE [dbo].[TimeSeries] (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [TimeSeriesDescription] VARCHAR (200) NULL,
    CONSTRAINT [PK_TimeSeries] PRIMARY KEY CLUSTERED ([ID] ASC)
);

