CREATE TABLE [dbo].[RateChangeQueue] (
    [ID]                  INT      IDENTITY (1, 1) NOT NULL,
    [CurrentRateChangeId] INT      NULL,
    [NumUpdates]          INT      NOT NULL,
    [ActualUpdates]       INT      CONSTRAINT [DF_RateChangeQueue_ActualUpdates] DEFAULT ((0)) NOT NULL,
    [Finished]            BIT      CONSTRAINT [DF_RateChangeQueue_Finished] DEFAULT ((0)) NOT NULL,
    [LastUpdate]          DATETIME NULL,
    [CreatedBy]           INT      NOT NULL,
    [DateCreated]         DATETIME CONSTRAINT [DF_RateChangeQueues_DateCreated] DEFAULT (getdate()) NOT NULL,
    [Failed]              BIT      CONSTRAINT [DF_RateChangeQueue_Failed] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_RateChangeQueue] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_RateChangeQueue_RateChange] FOREIGN KEY ([CurrentRateChangeId]) REFERENCES [dbo].[RateChange] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RateChangeQueue';

