CREATE TABLE [dbo].[TimeTrackerTaskHistory] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [TaskID] INT           NOT NULL,
    [Name]   VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_TimeTrackerTaskHistory] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TimeTrackerTaskHistory_TimeTrackerTask] FOREIGN KEY ([TaskID]) REFERENCES [dbo].[TimeTrackerTask] ([ID]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'TimeTracker', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TimeTrackerTaskHistory';

