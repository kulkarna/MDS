CREATE TABLE [dbo].[TimeTrackerTask] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [ProjectID]         INT           NOT NULL,
    [LegacyID]          VARCHAR (40)  NULL,
    [Name]              VARCHAR (100) NOT NULL,
    [HasHistoryEntries] BIT           CONSTRAINT [DF_TimeTrackerTask_HasHistoryEntry] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_TimeTrackerTask] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TimeTrackerTask_TimeTrackerProject] FOREIGN KEY ([ProjectID]) REFERENCES [dbo].[TimeTrackerProject] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TimeTrackerTask_ProjectID_LegacyID]
    ON [dbo].[TimeTrackerTask]([ProjectID] ASC, [LegacyID] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'TimeTracker', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TimeTrackerTask';

