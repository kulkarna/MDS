CREATE TABLE [dbo].[TimeTrackerTimeEntry] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [TaskID]       INT            NOT NULL,
    [EmployeeID]   INT            NOT NULL,
    [LegacyID]     VARCHAR (40)   NULL,
    [ExecutedDate] DATETIME       NOT NULL,
    [WorkedHours]  DECIMAL (4, 2) NOT NULL,
    [Comments]     VARCHAR (MAX)  NULL,
    [InsertedDate] DATETIME       CONSTRAINT [DF_TimeTrackerTimeEntry_InsertedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TimeTrackerTimeEntry] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TimeTrackerTimeEntry_TimeTrackerEmployee] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[TimeTrackerEmployee] ([ID]),
    CONSTRAINT [FK_TimeTrackerTimeEntry_TimeTrackerTask] FOREIGN KEY ([TaskID]) REFERENCES [dbo].[TimeTrackerTask] ([ID]) ON DELETE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TimeTrackerTimeEntry_TaskID_EmployeeID_LegacyID]
    ON [dbo].[TimeTrackerTimeEntry]([TaskID] ASC, [EmployeeID] ASC, [LegacyID] ASC, [ExecutedDate] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'TimeTracker', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TimeTrackerTimeEntry';

