CREATE TABLE [dbo].[TimeTrackerProjectHistory] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [ProjectID] INT           NOT NULL,
    [Name]      VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_TimeTrackerProjectHistory] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TimeTrackerProjectHistory_TimeTrackerProject] FOREIGN KEY ([ProjectID]) REFERENCES [dbo].[TimeTrackerProject] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'TimeTracker', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TimeTrackerProjectHistory';

