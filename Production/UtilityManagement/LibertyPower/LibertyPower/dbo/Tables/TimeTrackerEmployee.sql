CREATE TABLE [dbo].[TimeTrackerEmployee] (
    [ID]                INT              IDENTITY (1, 1) NOT NULL,
    [WindowsLogon]      VARCHAR (100)    NOT NULL,
    [ProjectServerGuid] UNIQUEIDENTIFIER NOT NULL,
    [ServiceDeskID]     INT              NOT NULL,
    [WebTimeSheetID]    INT              NOT NULL,
    CONSTRAINT [PK_TimeTrackerEmployee] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [IX_TimeTrackerEmployee_Logon] UNIQUE NONCLUSTERED ([WindowsLogon] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'TimeTracker', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TimeTrackerEmployee';

