USE [LibertyPower]
GO

/****** Object:  Table [dbo].[AccountEvent]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AccountEvent](
	[EventInstanceId] [int] NOT NULL,
	[AccountEventTypeId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
 CONSTRAINT [PK_AccountEvent_1] PRIMARY KEY CLUSTERED 
(
	[EventInstanceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccountEvent'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[AccountEventType]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AccountEventType](
	[AccountEventTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](250) NULL,
	[IsUsedForFinancials] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_AccountEventType] PRIMARY KEY CLUSTERED 
(
	[AccountEventTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccountEventType'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ContractEvent]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ContractEvent](
	[EventInstanceId] [int] NOT NULL,
	[ContractEventTypeId] [int] NOT NULL,
	[ContractId] [int] NOT NULL,
 CONSTRAINT [PK_ContractEvent_1] PRIMARY KEY CLUSTERED 
(
	[EventInstanceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractEvent'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ContractEventType]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ContractEventType](
	[ContractEventTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_ContractEventType] PRIMARY KEY CLUSTERED 
(
	[ContractEventTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractEventType'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[CustomerEvent]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustomerEvent](
	[EventInstanceId] [int] NOT NULL,
	[CustomerEventTypeId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_CustomerEvent_1] PRIMARY KEY CLUSTERED 
(
	[EventInstanceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerEvent'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[CustomerEventType]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CustomerEventType](
	[CustomerEventTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_CustomerEventType] PRIMARY KEY CLUSTERED 
(
	[CustomerEventTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerEventType'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[EventDomain]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EventDomain](
	[EventDomainId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_EventTypes] PRIMARY KEY CLUSTERED 
(
	[EventDomainId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EventDomain'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[EventError]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EventError](
	[EventErrorId] [int] IDENTITY(1,1) NOT NULL,
	[EventInstanceId] [int] NOT NULL,
	[ErrorTypeId] [int] NULL,
	[ErrorMessage] [varchar](max) NOT NULL,
	[ErrorDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EventError] PRIMARY KEY CLUSTERED 
(
	[EventErrorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For future use when we identify actionable types of errors' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EventError', @level2type=N'COLUMN',@level2name=N'ErrorTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stack trace for the error that occurred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EventError', @level2type=N'COLUMN',@level2name=N'ErrorMessage'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[EventInstance]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EventInstance](
	[EventInstanceId] [int] IDENTITY(1,1) NOT NULL,
	[ParentEventId] [int] NULL,
	[EventDomainId] [int] NOT NULL,
	[EventStatusId] [int] NOT NULL,
	[ScheduledTime] [datetime] NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
	[IsStarted] [bit] NOT NULL,
	[IsSuspended] [bit] NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	[Notes] [nvarchar](500) NULL,
	[CreatedBy] [varchar](200) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_EventInstances] PRIMARY KEY CLUSTERED 
(
	[EventInstanceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EventInstance'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[EventStatus]    Script Date: 06/07/2012 15:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EventStatus](
	[EventStatusId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_EventStatus] PRIMARY KEY CLUSTERED 
(
	[EventStatusId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EventStatus'
GO

ALTER TABLE [dbo].[AccountEvent]  WITH CHECK ADD  CONSTRAINT [FK_AccountEvent_AccountEventType] FOREIGN KEY([AccountEventTypeId])
REFERENCES [dbo].[AccountEventType] ([AccountEventTypeId])
GO

ALTER TABLE [dbo].[AccountEvent] CHECK CONSTRAINT [FK_AccountEvent_AccountEventType]
GO

ALTER TABLE [dbo].[AccountEvent]  WITH CHECK ADD  CONSTRAINT [FK_AccountEvent_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([EventInstanceId])
GO

ALTER TABLE [dbo].[AccountEvent] CHECK CONSTRAINT [FK_AccountEvent_EventInstance]
GO

ALTER TABLE [dbo].[AccountEventType] ADD  CONSTRAINT [DF_AccountEventType_IsUsedForFinancials]  DEFAULT ((0)) FOR [IsUsedForFinancials]
GO

ALTER TABLE [dbo].[AccountEventType] ADD  CONSTRAINT [DF_AccountEventTypes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[AccountEventType] ADD  CONSTRAINT [DF_AccountEventType_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[ContractEvent]  WITH CHECK ADD  CONSTRAINT [FK_ContractEvent_ContractEventType] FOREIGN KEY([ContractEventTypeId])
REFERENCES [dbo].[ContractEventType] ([ContractEventTypeId])
GO

ALTER TABLE [dbo].[ContractEvent] CHECK CONSTRAINT [FK_ContractEvent_ContractEventType]
GO

ALTER TABLE [dbo].[ContractEvent]  WITH CHECK ADD  CONSTRAINT [FK_ContractEvent_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([EventInstanceId])
GO

ALTER TABLE [dbo].[ContractEvent] CHECK CONSTRAINT [FK_ContractEvent_EventInstance]
GO

ALTER TABLE [dbo].[ContractEventType] ADD  CONSTRAINT [DF_ContractEventTypes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[ContractEventType] ADD  CONSTRAINT [DF_ContractEventType_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[CustomerEvent]  WITH CHECK ADD  CONSTRAINT [FK_CustomerEvent_CustomerEventType] FOREIGN KEY([CustomerEventTypeId])
REFERENCES [dbo].[CustomerEventType] ([CustomerEventTypeId])
GO

ALTER TABLE [dbo].[CustomerEvent] CHECK CONSTRAINT [FK_CustomerEvent_CustomerEventType]
GO

ALTER TABLE [dbo].[CustomerEvent]  WITH CHECK ADD  CONSTRAINT [FK_CustomerEvent_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([EventInstanceId])
GO

ALTER TABLE [dbo].[CustomerEvent] CHECK CONSTRAINT [FK_CustomerEvent_EventInstance]
GO

ALTER TABLE [dbo].[CustomerEventType] ADD  CONSTRAINT [DF_CustomerEventTypes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[CustomerEventType] ADD  CONSTRAINT [DF_CustomerEventType_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[EventDomain] ADD  CONSTRAINT [DF_EventTypes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[EventDomain] ADD  CONSTRAINT [DF_EventType_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[EventError]  WITH CHECK ADD  CONSTRAINT [FK_EventError_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([EventInstanceId])
GO

ALTER TABLE [dbo].[EventError] CHECK CONSTRAINT [FK_EventError_EventInstance]
GO

ALTER TABLE [dbo].[EventError] ADD  CONSTRAINT [DF_EventError_ErrorDate]  DEFAULT (getdate()) FOR [ErrorDate]
GO

ALTER TABLE [dbo].[EventInstance]  WITH CHECK ADD  CONSTRAINT [FK_EventInstance_EventDomain] FOREIGN KEY([EventDomainId])
REFERENCES [dbo].[EventDomain] ([EventDomainId])
GO

ALTER TABLE [dbo].[EventInstance] CHECK CONSTRAINT [FK_EventInstance_EventDomain]
GO

ALTER TABLE [dbo].[EventInstance]  WITH CHECK ADD  CONSTRAINT [FK_EventInstance_EventStatus] FOREIGN KEY([EventStatusId])
REFERENCES [dbo].[EventStatus] ([EventStatusId])
GO

ALTER TABLE [dbo].[EventInstance] CHECK CONSTRAINT [FK_EventInstance_EventStatus]
GO

ALTER TABLE [dbo].[EventInstance]  WITH CHECK ADD  CONSTRAINT [FK_ParentEventInstance_EventInstance] FOREIGN KEY([ParentEventId])
REFERENCES [dbo].[EventInstance] ([EventInstanceId])
GO

ALTER TABLE [dbo].[EventInstance] CHECK CONSTRAINT [FK_ParentEventInstance_EventInstance]
GO

ALTER TABLE [dbo].[EventInstance] ADD  CONSTRAINT [DF__EventInst__Statu__03317E3D]  DEFAULT (NULL) FOR [EventStatusId]
GO

ALTER TABLE [dbo].[EventInstance] ADD  CONSTRAINT [DF_EventInstance_ScheduledTime]  DEFAULT (getdate()) FOR [ScheduledTime]
GO

ALTER TABLE [dbo].[EventInstance] ADD  CONSTRAINT [DF__EventInst__LastU__7F60ED59]  DEFAULT (getdate()) FOR [LastUpdated]
GO

ALTER TABLE [dbo].[EventInstance] ADD  CONSTRAINT [DF__EventInst__IsSta__00551192]  DEFAULT ((0)) FOR [IsStarted]
GO

ALTER TABLE [dbo].[EventInstance] ADD  CONSTRAINT [DF__EventInst__IsSus__014935CB]  DEFAULT ((0)) FOR [IsSuspended]
GO

ALTER TABLE [dbo].[EventInstance] ADD  CONSTRAINT [DF__EventInst__IsCom__023D5A04]  DEFAULT ((0)) FOR [IsCompleted]
GO

ALTER TABLE [dbo].[EventInstance] ADD  CONSTRAINT [DF_EventInstance_CreatedBy]  DEFAULT (user_name()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[EventInstance] ADD  CONSTRAINT [DF__EventInst__Creat__7E6CC920]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[EventStatus] ADD  CONSTRAINT [DF_EventStatus_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[EventStatus] ADD  CONSTRAINT [DF_EventStatus_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO


