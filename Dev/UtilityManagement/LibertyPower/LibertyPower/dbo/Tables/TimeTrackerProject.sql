CREATE TABLE [dbo].[TimeTrackerProject] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [ApplicationID]     INT           NOT NULL,
    [LegacyID]          VARCHAR (40)  NULL,
    [Name]              VARCHAR (100) NOT NULL,
    [HasHistoryEntries] BIT           CONSTRAINT [DF_TimeTrackerProject_HasHistoryEntry] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_TimeTrackerProject] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TimeTrackerProject_ApplicationID_LegacyID]
    ON [dbo].[TimeTrackerProject]([ApplicationID] ASC, [LegacyID] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'TimeTracker', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TimeTrackerProject';

