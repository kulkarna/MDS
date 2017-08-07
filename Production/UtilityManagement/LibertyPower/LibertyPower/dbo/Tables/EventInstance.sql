CREATE TABLE [dbo].[EventInstance] (
    [EventInstanceId] INT            IDENTITY (1, 1) NOT NULL,
    [ParentEventId]   INT            NULL,
    [EventDomainId]   INT            NOT NULL,
    [EventStatusId]   INT            CONSTRAINT [DF__EventInst__Statu__03317E3D] DEFAULT (NULL) NOT NULL,
    [ScheduledTime]   DATETIME       CONSTRAINT [DF_EventInstance_ScheduledTime] DEFAULT (getdate()) NOT NULL,
    [LastUpdated]     DATETIME       CONSTRAINT [DF__EventInst__LastU__7F60ED59] DEFAULT (getdate()) NOT NULL,
    [IsStarted]       BIT            CONSTRAINT [DF__EventInst__IsSta__00551192] DEFAULT ((0)) NOT NULL,
    [IsSuspended]     BIT            CONSTRAINT [DF__EventInst__IsSus__014935CB] DEFAULT ((0)) NOT NULL,
    [IsCompleted]     BIT            CONSTRAINT [DF__EventInst__IsCom__023D5A04] DEFAULT ((0)) NOT NULL,
    [Notes]           NVARCHAR (500) NULL,
    [CreatedBy]       VARCHAR (200)  CONSTRAINT [DF_EventInstance_CreatedBy] DEFAULT (user_name()) NOT NULL,
    [DateCreated]     DATETIME       CONSTRAINT [DF__EventInst__Creat__7E6CC920] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EventInstances] PRIMARY KEY CLUSTERED ([EventInstanceId] ASC),
    CONSTRAINT [FK_EventInstance_EventDomain] FOREIGN KEY ([EventDomainId]) REFERENCES [dbo].[EventDomain] ([EventDomainId]),
    CONSTRAINT [FK_EventInstance_EventStatus] FOREIGN KEY ([EventStatusId]) REFERENCES [dbo].[EventStatus] ([EventStatusId]),
    CONSTRAINT [FK_ParentEventInstance_EventInstance] FOREIGN KEY ([ParentEventId]) REFERENCES [dbo].[EventInstance] ([EventInstanceId])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EventInstance';

