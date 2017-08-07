--begin tran

USE [Libertypower]
GO

----------------------------------------------------------------------------------------------------------
IF EXISTS (select * from sys.tables where name = 'ApplicationFeatureSettings')
BEGIN
	DROP TABLE LibertyPower..ApplicationFeatureSettings
END
IF EXISTS (select * from sys.tables where name = 'WorkflowEventTrigger')
BEGIN
	DROP TABLE LibertyPower..WorkflowEventTrigger
END
IF EXISTS (select * from sys.tables where name = 'WIPTask')
BEGIN
	DROP TABLE LibertyPower..WIPTask
END
IF EXISTS (select * from sys.tables where name = 'WIPTaskHeader')
BEGIN
	DROP TABLE LibertyPower..WIPTaskHeader
END
IF EXISTS (select * from sys.tables where name = 'WorkflowAssignment')
BEGIN
	DROP TABLE LibertyPower..WorkflowAssignment
END
IF EXISTS (select * from sys.tables where name = 'WorkflowPathLogic')
BEGIN
	DROP TABLE LibertyPower..WorkflowPathLogic
END
IF EXISTS (select * from sys.tables where name = 'WorkflowTaskLogic')
BEGIN
	DROP TABLE LibertyPower..WorkflowTaskLogic
END
IF EXISTS (select * from sys.tables where name = 'WorkflowTask')
BEGIN
	DROP TABLE LibertyPower..WorkflowTask
END
IF EXISTS (select * from sys.tables where name = 'Workflow')
BEGIN
	DROP TABLE LibertyPower..Workflow
END
IF EXISTS (select * from sys.tables where name = 'TaskType')
BEGIN
	DROP TABLE LibertyPower..TaskType
END
IF EXISTS (select * from sys.tables where name = 'TaskStatus')
BEGIN
	DROP TABLE LibertyPower..TaskStatus
END
IF EXISTS (select * from sys.tables where name = 'ItemType')
BEGIN
	DROP TABLE LibertyPower..ItemType
END
GO

----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TaskType](
	[TaskTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TaskName] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL
 CONSTRAINT [PK_TaskType] PRIMARY KEY CLUSTERED 
(
	[TaskTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

INSERT INTO [TaskType] VALUES ('Usage Acquire',	1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Credit Check',	1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Documents',	    1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Enrollment Cancelation',  1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Post-Usage Credit Check', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('TPV', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Letter', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Check Account', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Customer Assignment', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Finance', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Rate Code Approval', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Post-Usage Min Usage Check', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Post-Usage Max Usage Check', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Price Validation', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Acquire Service Class', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Acquire Service Class', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Billing Tax Exemption', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('CustomerCare Tax Exemption', 1, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [TaskType] VALUES ('Profitability', 0, 0,	'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())


DELETE FROM [TaskType]
WHERE TaskTypeID = 16

GO

----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TaskStatus](
	[TaskStatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_TaskStatus] PRIMARY KEY CLUSTERED 
(
	[TaskStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO [LibertyPower].[dbo].[TaskStatus] VALUES ('NEW', 1, 0,  'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [LibertyPower].[dbo].[TaskStatus] VALUES ('PENDING', 1, 0, 'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [LibertyPower].[dbo].[TaskStatus] VALUES ('APPROVED', 1, 0, 'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [LibertyPower].[dbo].[TaskStatus] VALUES ('REJECTED', 1, 0, 'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [LibertyPower].[dbo].[TaskStatus] VALUES ('INCOMPLETE', 1, 0, 'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [LibertyPower].[dbo].[TaskStatus] VALUES ('ON HOLD', 1, 0, 'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())
INSERT INTO [LibertyPower].[dbo].[TaskStatus] VALUES ('PENDINGSYS', 1, 0, 'libertypower\itamanini', getdate(), 'libertypower\itamanini', getdate())


GO

----------------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[ItemType](
	[ItemTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ItemTypeName] [nvarchar](50) NOT NULL,
	[ItemTypeDescription] [nvarchar](50) NOT NULL,
	[ContractTypeID] [int] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_ItemType] PRIMARY KEY CLUSTERED 
(
	[ItemTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ItemType]  WITH CHECK ADD  CONSTRAINT [FK_ItemType_ContractType] FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO

ALTER TABLE [dbo].[ItemType] CHECK CONSTRAINT [FK_ItemType_ContractType]
GO

----------------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Workflow](
	[WorkflowID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowName] [nvarchar](25) NOT NULL,
	[WorkflowDescription] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Version] [nchar](5) NOT NULL,
	[IsRevisionOfRecord] [bit] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED 
(
	[WorkflowID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET IDENTITY_INSERT [dbo].[Workflow] ON
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (0, N'AllSteps', N'All Steps', 0, N'1    ', 0, NULL, N'libertypower\e3hernandez', CAST(0x0000A0D2006FF919 AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D2006FF919 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (9, N'Paper New Contract', N'Generic workflow for New Paper Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00E9F6FD AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00EEF900 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (10, N'Voice New Contract', N'Voice New Contract Generic', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F0AA05 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F0AA05 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (11, N'Voice New TX', N'Voice New Texas', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F5E2C6 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE010BB133 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (12, N'Voice New IL', N'Voice New IL Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F8F9B3 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F8F9B3 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (15, N'Paper New TX', N'Paper New TX Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0108DE14 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0108DE14 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (18, N'Corporate New', N'Corporate New Contract', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01125B25 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01125B25 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (19, N'Paper Renewal', N'Paper Renewal Contract', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01135D1A AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01135D1A AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (20, N'Coporate Renewal', N'Corporate Renewal Contract', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE011589A9 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE011589A9 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (21, N'Voice Renewal', N'Voice Renewal', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01170063 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01170063 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (22, N'POLR', N'POLR Texas Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0119CC80 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0119CC80 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (23, N'Power Move', N'Power Move Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\itamanini', CAST(0x0000A0D300FC5138 AS DateTime), N'LIBERTYPOWER\itamanini', CAST(0x0000A0D300FC5138 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (25, N'Paper New IL', N'Paper New IL', 1, N'1.1  ', 1, NULL, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF786D AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E10102B298 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (26, N'Voice New IL', N'Voice New IL Contracts', 1, N'1.1  ', 0, 1, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E101009ADF AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E10100B784 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (27, N'Paper New BGE', N'Paper New BGE contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E10115D2DA AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E700ECD6DD AS DateTime))
SET IDENTITY_INSERT [dbo].[Workflow] OFF
SET IDENTITY_INSERT [dbo].[Workflow] OFF

GO

---- Workflow to contain all steps.
--SET IDENTITY_INSERT Workflow ON
--INSERT INTO LibertyPower.dbo.Workflow
--        (WorkflowID, WorkflowName, WorkflowDescription, IsActive, Version, IsRevisionOfRecord, CreatedBy                 , DateCreated, UpdatedBy                 , DateUpdated)
--SELECT 0         , 'AllSteps'  , 'All Steps'        , 0       , 1      , 0                 , 'libertypower\e3hernandez', getdate()  , 'libertypower\e3hernandez', getdate()
--SET IDENTITY_INSERT Workflow OFF
 
--INSERT INTO LibertyPower.dbo.WorkflowTask
--        (WorkflowID, TaskTypeID, TaskSequence, IsDeleted, CreatedBy                 , DateCreated, UpdatedBy                 , DateUpdated)
--SELECT 0         , TaskTypeID, 1           , 0        , 'libertypower\e3hernandez', getdate()  , 'libertypower\e3hernandez', getdate()
--FROM LibertyPower.dbo.TaskType

GO

----------------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[WorkflowTask](
	[WorkflowTaskID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[TaskTypeID] [int] NOT NULL,
	[TaskSequence] [int] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_WorkflowTask] PRIMARY KEY CLUSTERED 
(
	[WorkflowTaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WorkflowTask]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTask_TaskType] FOREIGN KEY([TaskTypeID])
REFERENCES [dbo].[TaskType] ([TaskTypeID])
GO

ALTER TABLE [dbo].[WorkflowTask] CHECK CONSTRAINT [FK_WorkflowTask_TaskType]
GO

ALTER TABLE [dbo].[WorkflowTask]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTask_Workflow] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[Workflow] ([WorkflowID])
GO

ALTER TABLE [dbo].[WorkflowTask] CHECK CONSTRAINT [FK_WorkflowTask_Workflow]
GO

SET IDENTITY_INSERT [dbo].[WorkflowTask] ON
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (30, 9, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00EAA4B9 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00EAA4B9 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (31, 9, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00EAB272 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00EAB272 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (32, 9, 3, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00EAC3CE AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00EAC3CE AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (33, 9, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00EC23DE AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00EC23DE AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (34, 9, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00EC3CB8 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00EC3CB8 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (35, 9, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00EC48CE AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00EC48CE AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (36, 10, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F0C80E AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F0C80E AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (37, 10, 6, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F0DE4E AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F0DE4E AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (38, 10, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F0F877 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F0F877 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (39, 10, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F10899 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F10899 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (40, 10, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F12D45 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F12D45 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (41, 10, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F13D0E AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F13D0E AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (42, 11, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F5F04E AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F5F04E AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (43, 11, 6, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F5FCBF AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F5FCBF AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (44, 11, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F6399D AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F6399D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (45, 11, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F68F40 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F68F40 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (46, 11, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00F6D2C8 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F6D2C8 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (47, 12, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FA4BD5 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FA4BD5 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (48, 12, 6, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FA5C91 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FA5C91 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (49, 12, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FA6FDE AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FA6FDE AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (50, 12, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FA860F AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FA860F AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (51, 12, 15, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FA946D AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FA946D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (52, 12, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FB7CD6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FB7CD6 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (53, 12, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FBAD47 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FBAD47 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (67, 15, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01092498 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01092498 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (68, 15, 3, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01093BD6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01093BD6 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (69, 15, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0109A072 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0109A072 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (70, 15, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010A1327 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010A1327 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (71, 15, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010A60D6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010A60D6 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (72, 15, 5, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010AD162 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010AD162 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (73, 15, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010B1976 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010B1976 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (89, 18, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01127C10 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01127C10 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (90, 18, 10, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01128F12 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01128F12 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (91, 18, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0112A1AE AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0112A1AE AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (92, 19, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01136DF4 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01136DF4 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (93, 19, 3, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0113815C AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0113815C AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (94, 19, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01139919 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01139919 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (95, 19, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0113B8C6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0113B8C6 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (96, 19, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0113CCDA AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0113CCDA AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (97, 20, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0115A00A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0115A00A AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (98, 20, 10, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0115B33C AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0115B33C AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (99, 20, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0115C86C AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0115C86C AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (100, 21, 2, 0, 1, N'libertypower\atafur', CAST(0x0000A0BE01173033 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE011795F3 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (101, 21, 15, 0, 1, N'libertypower\atafur', CAST(0x0000A0BE01174DFF AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01175BC3 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (102, 21, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0117F460 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0117F460 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (103, 21, 6, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE011803C5 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE011803C5 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (104, 21, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01181703 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01181703 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (105, 21, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01182CB0 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01182CB0 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (106, 21, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE011846F8 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE011846F8 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (107, 22, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0119DC80 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0119DC80 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (108, 22, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0119ED51 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0119ED51 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (109, 22, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE011A0629 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE011A0629 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (110, 0, 1, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (111, 0, 2, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (112, 0, 3, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (113, 0, 4, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (114, 0, 5, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (115, 0, 6, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (116, 0, 7, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (117, 0, 8, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (118, 0, 9, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (119, 0, 10, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (120, 0, 11, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (121, 0, 12, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (122, 0, 13, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (123, 0, 14, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (124, 0, 15, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (125, 0, 17, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (126, 0, 18, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0D200713D6D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (127, 23, 2, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FC604D AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FC604D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (128, 23, 1, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FC6CF6 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FC6CF6 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (129, 23, 14, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FC9C2E AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FC9C2E AS DateTime))
GO
print 'Processed 100 total records'
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (130, 23, 7, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FCC4B5 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FCC4B5 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (131, 11, 5, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FDAE67 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FDAE67 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (132, 11, 7, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FDD756 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FDD756 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (133, 0, 19, 1, 0, N'libertypower\e3hernandez', CAST(0x0000A0DA00AC866E AS DateTime), N'libertypower\e3hernandez', CAST(0x0000A0DA00AC866E AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (134, 25, 8, 0, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7870 AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7870 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (135, 25, 1, 0, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF787D AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF787D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (136, 25, 15, 0, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF787E AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF787E AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (137, 25, 2, 0, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF787F AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF787F AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (138, 25, 14, 0, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7880 AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7880 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (139, 25, 3, 0, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7881 AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7881 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (140, 25, 7, 0, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7881 AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7881 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (141, 25, 5, 0, 1, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7882 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E10101116E AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (149, 18, 2, 0, 0, N'libertypower\sshapansky', CAST(0x0000A0E1011049DA AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E1011049DA AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (150, 27, 8, 0, 0, N'libertypower\sshapansky', CAST(0x0000A0E10115E98F AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E10115E98F AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (151, 27, 2, 0, 0, N'libertypower\sshapansky', CAST(0x0000A0E101161DFB AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E101161DFB AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (152, 27, 3, 0, 0, N'libertypower\sshapansky', CAST(0x0000A0E101162F9C AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E101162F9C AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (153, 27, 14, 0, 0, N'libertypower\sshapansky', CAST(0x0000A0E1011654FC AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E1011654FC AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (154, 27, 1, 0, 0, N'libertypower\sshapansky', CAST(0x0000A0E1011670BA AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E1011670BA AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (155, 27, 7, 0, 0, N'libertypower\sshapansky', CAST(0x0000A0E101168ED9 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E10117384D AS DateTime))
SET IDENTITY_INSERT [dbo].[WorkflowTask] OFF
GO

----------------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[WorkflowTaskLogic](
	[WorkflowTaskLogicID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTaskID] [int] NOT NULL,
	[LogicParam] [nvarchar](50) NOT NULL,
	[LogicCondition] [int] NOT NULL,
	[IsAutomated] [bit] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_WorkflowTaskLogic] PRIMARY KEY CLUSTERED 
(
	[WorkflowTaskLogicID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WorkflowTaskLogic]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTaskLogic_WorkflowTask] FOREIGN KEY([WorkflowTaskID])
REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID])
GO

ALTER TABLE [dbo].[WorkflowTaskLogic] CHECK CONSTRAINT [FK_WorkflowTaskLogic_WorkflowTask]
GO

INSERT INTO [WorkflowTaskLogic] VALUES (132, 'SubmitEnrollment', 1,	0,	0,	'libertypower\atafur',	'2012-10-15 00:00:00.000',	NULL,	NULL)
INSERT INTO [WorkflowTaskLogic] VALUES ( 73, 'SubmitEnrollment',	1,	0,	0,	'libertypower\atafur',	'2012-10-15 00:00:00.000',	NULL,	NULL)
GO
----------------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[WorkflowPathLogic](
	[WorkflowPathLogicID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTaskID] [int] NOT NULL,
	[WorkflowTaskIDRequired] [int] NOT NULL,
	[ConditionTaskStatusID] [int] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_WorkflowPathLogic] PRIMARY KEY CLUSTERED 
(
	[WorkflowPathLogicID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WorkflowPathLogic]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowPathLogic_TaskStatus] FOREIGN KEY([ConditionTaskStatusID])
REFERENCES [dbo].[TaskStatus] ([TaskStatusID])
GO

ALTER TABLE [dbo].[WorkflowPathLogic] CHECK CONSTRAINT [FK_WorkflowPathLogic_TaskStatus]
GO

ALTER TABLE [dbo].[WorkflowPathLogic]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowPathLogic_WorkflowTask] FOREIGN KEY([WorkflowTaskID])
REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID])
GO

ALTER TABLE [dbo].[WorkflowPathLogic] CHECK CONSTRAINT [FK_WorkflowPathLogic_WorkflowTask]
GO

ALTER TABLE [dbo].[WorkflowPathLogic]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowPathLogic_WorkflowTask_Required] FOREIGN KEY([WorkflowTaskIDRequired])
REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID])
GO

ALTER TABLE [dbo].[WorkflowPathLogic] CHECK CONSTRAINT [FK_WorkflowPathLogic_WorkflowTask_Required]
GO

SET IDENTITY_INSERT [dbo].[WorkflowPathLogic] ON
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (25, 31, 30, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00EC67F2 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00EC67F2 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (26, 32, 31, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00EC8653 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00EC8653 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (27, 33, 32, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00ECAA2F AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00ECAA2F AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (28, 34, 33, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00ECC81E AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00ECC81E AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (29, 35, 34, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00ECE333 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00ECE333 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (30, 37, 36, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F15E5B AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F15E5B AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (31, 38, 37, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F1785B AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F1785B AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (32, 39, 38, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F1AAE8 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F1AAE8 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (33, 40, 39, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F1C63A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F1C63A AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (34, 41, 40, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F1E40D AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F1E40D AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (35, 43, 42, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F60B93 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F60B93 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (36, 44, 43, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F64C9F AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F64C9F AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (37, 45, 132, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F6A600 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E801072B38 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (38, 46, 44, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F6E65C AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E8010711C6 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (39, 48, 47, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FAA80A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FAA80A AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (40, 49, 48, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FAE105 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FAE105 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (41, 50, 52, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FB4AF1 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E10107503D AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (42, 51, 49, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FB65A3 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E101071D52 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (43, 52, 51, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FB9525 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FB9525 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (44, 53, 50, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FBC538 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E101078EB0 AS DateTime))

INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (56, 68, 67, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0109807A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0109807A AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (57, 69, 68, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0109C09A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0109C09A AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (58, 70, 73, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010A32E6 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E801020723 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (59, 71, 69, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010A7DFB AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E80101B38E AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (60, 72, 70, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010AE8C1 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E801022127 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (61, 73, 71, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010B4425 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E1010D0498 AS DateTime))

INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (75, 91, 149, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0112BF1D AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E101108CB4 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (76, 90, 89, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0112DF4F AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0112DF4F AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (77, 96, 95, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0113EB0B AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0113EB0B AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (78, 95, 94, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01140DB5 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01140DB5 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (79, 94, 93, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01145424 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01145424 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (80, 93, 92, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0114841D AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0114841D AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (81, 99, 98, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0115F816 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0115F816 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (82, 98, 97, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0116121B AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0116121B AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (83, 106, 105, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01188139 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01188139 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (84, 105, 104, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0118B0A0 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0118B0A0 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (85, 104, 103, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0118D951 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0118D951 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (86, 103, 102, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0119026F AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0119026F AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (87, 109, 108, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE011A2395 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE011A2395 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (88, 108, 107, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE011B19FB AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE011B19FB AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (89, 128, 127, 3, 0, N'libertypower\itamanini', CAST(0x0000A0D300FC8753 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FC8753 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (90, 129, 128, 3, 0, N'libertypower\itamanini', CAST(0x0000A0D300FCB3B1 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FCB3B1 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (91, 130, 129, 3, 0, N'libertypower\itamanini', CAST(0x0000A0D300FCD9BE AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FCD9BE AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (92, 131, 45, 3, 0, N'libertypower\itamanini', CAST(0x0000A0D300FDC4A2 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E80107467D AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (93, 132, 46, 3, 0, N'libertypower\itamanini', CAST(0x0000A0D300FDF773 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E1010E53C3 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (94, 135, 134, 3, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7886 AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7886 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (95, 136, 135, 3, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF788E AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF788E AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (96, 137, 136, 3, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7890 AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7890 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (97, 138, 139, 3, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7891 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E101053017 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (98, 139, 137, 3, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7893 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E1010544B1 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (99, 140, 138, 3, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7894 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E101056FF7 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (100, 141, 140, 3, 0, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7895 AS DateTime), N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E100FF7895 AS DateTime))

INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (107, 149, 90, 3, 0, N'libertypower\sshapansky', CAST(0x0000A0E101106D78 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E1011109E5 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (108, 151, 150, 3, 0, N'libertypower\sshapansky', CAST(0x0000A0E10116B79E AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E10116B79E AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (109, 152, 150, 3, 0, N'libertypower\sshapansky', CAST(0x0000A0E10116D339 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E10116D339 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (110, 154, 150, 3, 0, N'libertypower\sshapansky', CAST(0x0000A0E10116F3DC AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E10116F3DC AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (111, 153, 154, 3, 0, N'libertypower\sshapansky', CAST(0x0000A0E1011727FB AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E1011727FB AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (112, 155, 153, 3, 0, N'libertypower\sshapansky', CAST(0x0000A0E101174EBE AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0E101174EBE AS DateTime))
SET IDENTITY_INSERT [dbo].[WorkflowPathLogic] OFF

GO

----------------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[WorkflowAssignment](
	[WorkflowAssignmentId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowId] [int] NOT NULL,
	[MarketId] [int] NULL,
	[UtilityId] [int] NULL,
	[ContractTypeId] [int] NOT NULL,
	[ContractDealTypeId] [int] NOT NULL,
	[ContractTemplateTypeId] [int] NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_WorkflowAssignment] PRIMARY KEY CLUSTERED 
(
	[WorkflowAssignmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WorkflowAssignment]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowAssignment_ContractType] FOREIGN KEY([ContractTypeId])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO

ALTER TABLE [dbo].[WorkflowAssignment] CHECK CONSTRAINT [FK_WorkflowAssignment_ContractType]
GO

ALTER TABLE [dbo].[WorkflowAssignment]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowAssignment_Workflow] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([WorkflowID])
GO

ALTER TABLE [dbo].[WorkflowAssignment] CHECK CONSTRAINT [FK_WorkflowAssignment_Workflow]
GO

SET IDENTITY_INSERT [dbo].[WorkflowAssignment] ON
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (3, 21, NULL, NULL, 1, 2, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE011F3229 AS DateTime), NULL, CAST(0x0000A0BE011F3229 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (4, 20, NULL, NULL, 2, 2, 2, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE011F7168 AS DateTime), NULL, CAST(0x0000A0BE011F7168 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (5, 19, NULL, NULL, 2, 2, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE011FA276 AS DateTime), NULL, CAST(0x0000A0BE011FA276 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (18, 10, NULL, NULL, 1, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE012488D6 AS DateTime), NULL, CAST(0x0000A0BE012488D6 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (19, 9, NULL, NULL, 2, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0124DD0C AS DateTime), NULL, CAST(0x0000A0BE0124DD0C AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (20, 22, 1, NULL, 3, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0125872F AS DateTime), NULL, CAST(0x0000A0BE0125872F AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (21, 23, 7, 18, 3, 1, 1, N'LIBERTYPOWER\itamanini', CAST(0x0000A0D3010EF931 AS DateTime), NULL, CAST(0x0000A0D3010EF931 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (24, 25, 13, NULL, 2, 1, 1, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E1010634AC AS DateTime), NULL, CAST(0x0000A0E1010634AC AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (25, 12, 13, NULL, 1, 1, 1, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E101080058 AS DateTime), NULL, CAST(0x0000A0E101080058 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (28, 18, NULL, NULL, 2, 1, 2, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E101116503 AS DateTime), NULL, CAST(0x0000A0E101116503 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (30, 27, 10, 13, 2, 1, 1, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E700ECF70C AS DateTime), NULL, CAST(0x0000A0E700ECF70C AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (31, 15, 1, NULL, 2, 1, 1, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E80102CE52 AS DateTime), NULL, CAST(0x0000A0E80102CE52 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (32, 11, 1, NULL, 1, 1, 1, N'LIBERTYPOWER\sshapansky', CAST(0x0000A0E80108BE5A AS DateTime), NULL, CAST(0x0000A0E80108BE5A AS DateTime))
SET IDENTITY_INSERT [dbo].[WorkflowAssignment] OFF
GO

----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WIPTaskHeader](
	[WIPTaskHeaderId] [int] IDENTITY(1,1) NOT NULL,
	[ContractTypeId] [int] NOT NULL,
	[ContractId] [int] NOT NULL,
	[WorkflowId] [int] NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_WIPTaskHeader] PRIMARY KEY CLUSTERED 
(
	[WIPTaskHeaderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WIPTaskHeader]  WITH CHECK ADD  CONSTRAINT [FK_WIPTaskHeader_Contract] FOREIGN KEY([ContractId])
REFERENCES [dbo].[Contract] ([ContractID])
GO

ALTER TABLE [dbo].[WIPTaskHeader] CHECK CONSTRAINT [FK_WIPTaskHeader_Contract]
GO

ALTER TABLE [dbo].[WIPTaskHeader]  WITH CHECK ADD  CONSTRAINT [FK_WIPTaskHeader_ContractType] FOREIGN KEY([ContractTypeId])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO

ALTER TABLE [dbo].[WIPTaskHeader] CHECK CONSTRAINT [FK_WIPTaskHeader_ContractType]
GO

ALTER TABLE [dbo].[WIPTaskHeader]  WITH CHECK ADD  CONSTRAINT [FK_WIPTaskHeader_Workflow] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([WorkflowID])
GO

ALTER TABLE [dbo].[WIPTaskHeader] CHECK CONSTRAINT [FK_WIPTaskHeader_Workflow]
GO

----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WIPTask](
	[WIPTaskId] [int] IDENTITY(1,1) NOT NULL,
	[WIPTaskHeaderId] [int] NOT NULL,
	[WorkflowTaskId] [int] NOT NULL,
	[TaskStatusId] [int] NOT NULL,
	[IsAvailable] [int] NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL,
	[AssignedTo] [int] NULL,
	[TaskComment] [nvarchar](max) NULL,
 CONSTRAINT [PK_WIPTask] PRIMARY KEY CLUSTERED 
(
	[WIPTaskId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WIPTask]  WITH CHECK ADD  CONSTRAINT [FK_WIPTask_TaskStatus] FOREIGN KEY([TaskStatusId])
REFERENCES [dbo].[TaskStatus] ([TaskStatusID])
GO

ALTER TABLE [dbo].[WIPTask] CHECK CONSTRAINT [FK_WIPTask_TaskStatus]
GO

ALTER TABLE [dbo].[WIPTask]  WITH CHECK ADD  CONSTRAINT [FK_WIPTask_WIPTaskHeader] FOREIGN KEY([WIPTaskHeaderId])
REFERENCES [dbo].[WIPTaskHeader] ([WIPTaskHeaderId])
GO

ALTER TABLE [dbo].[WIPTask] CHECK CONSTRAINT [FK_WIPTask_WIPTaskHeader]
GO

ALTER TABLE [dbo].[WIPTask]  WITH CHECK ADD  CONSTRAINT [FK_WIPTask_WorkflowTask] FOREIGN KEY([WorkflowTaskId])
REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID])
GO

ALTER TABLE [dbo].[WIPTask] CHECK CONSTRAINT [FK_WIPTask_WorkflowTask]
GO

----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WorkflowEventTrigger](
	[WorkflowEventTriggerId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowId] [int] NULL,
	[RequiredTaskId] [int] NULL,
	[RequiredTaskStatusId] [int] NULL,
	[AccountEventTypeId] [int] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[DateUpdated] [datetime] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WorkflowEventTrigger]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowEventTrigger_TaskStatus] FOREIGN KEY([RequiredTaskStatusId])
REFERENCES [dbo].[TaskStatus] ([TaskStatusID])
GO

ALTER TABLE [dbo].[WorkflowEventTrigger] CHECK CONSTRAINT [FK_WorkflowEventTrigger_TaskStatus]
GO

ALTER TABLE [dbo].[WorkflowEventTrigger]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowEventTrigger_Workflow] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([WorkflowID])
GO

ALTER TABLE [dbo].[WorkflowEventTrigger] CHECK CONSTRAINT [FK_WorkflowEventTrigger_Workflow]
GO

ALTER TABLE [dbo].[WorkflowEventTrigger]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowEventTrigger_TaskType] FOREIGN KEY([RequiredTaskId])
REFERENCES [dbo].[TaskType] ([TaskTypeID])
GO

ALTER TABLE [dbo].[WorkflowEventTrigger] CHECK CONSTRAINT [FK_WorkflowEventTrigger_TaskType]
GO

INSERT INTO WorkflowEventTrigger 
SELECT W.WorkflowID,
	   TT.TaskTypeId,
	   TS.TaskStatusId,
	   AET.AccountEventTypeId,
	   'libertypower\itamanini',
	   getdate(),
	   'libertypower\itamanini',
	   getdate()
FROM LibertyPower..Workflow W (NOLOCK)
JOIN LibertyPower..WorkflowTask WT (NOLOCK) ON WT.WorkflowId = W.WorkflowId
JOIN LibertyPower..TaskType TT (NOLOCK) ON WT.TaskTypeId = TT.TaskTypeId
JOIN LibertyPower..TaskStatus TS (NOLOCK) ON (TS.StatusName = 'APPROVED' OR TS.StatusName = 'REJECTED')
JOIN AccountEventType AET (NOLOCK) on AET.Name = 'CommissionRequirementSatisfied'
WHERE TaskName = 'Letter'

GO

----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ApplicationFeatureSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FeatureName] [nvarchar](50) NULL,
	[FeatureValue] [bit] NULL,
	[ProcessName] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
) ON [PRIMARY]

GO

INSERT INTO [ApplicationFeatureSettings] VALUES ('IT043', 0, 'EnrollmentApp', 'Workflow management functionality', 49, getdate(), null, null)
----------------------------------------------------------------------------------------------------------

IF EXISTS (select * from sys.objects where type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND name = 'ufn_GetWorkflowAssignment')
BEGIN
	DROP FUNCTION ufn_GetWorkflowAssignment
END
IF EXISTS (select * from sys.objects where type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND name = 'ufn_GetTaskLogic')
BEGIN
	DROP FUNCTION ufn_GetTaskLogic
END
IF EXISTS (select * from sys.procedures where name = 'usp_TaskStatusSelect')
BEGIN
	DROP PROCEDURE usp_TaskStatusSelect
END
IF EXISTS (select * from sys.procedures where name = 'usp_TaskTypeDelete')
BEGIN
	DROP PROCEDURE usp_TaskTypeDelete
END
IF EXISTS (select * from sys.procedures where name = 'usp_TaskTypeInsertUpdate')
BEGIN
	DROP PROCEDURE usp_TaskTypeInsertUpdate
END
IF EXISTS (select * from sys.procedures where name = 'usp_TaskTypeSelect')
BEGIN
	DROP PROCEDURE usp_TaskTypeSelect
END
IF EXISTS (select * from sys.procedures where name = 'usp_WIPTaskHeaderInsertUpdate')
BEGIN
	DROP PROCEDURE usp_WIPTaskHeaderInsertUpdate
END
IF EXISTS (select * from sys.procedures where name = 'usp_WIPTaskInsertUpdate')
BEGIN
	DROP PROCEDURE usp_WIPTaskInsertUpdate
END
IF EXISTS (select * from sys.procedures where name = 'usp_WIPTaskSelect')
BEGIN
	DROP PROCEDURE usp_WIPTaskSelect
END
IF EXISTS (select * from sys.procedures where name = 'usp_WIPTaskUpdateStatus')
BEGIN
	DROP PROCEDURE usp_WIPTaskUpdateStatus
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowAssignmentDelete')
BEGIN
	DROP PROCEDURE usp_WorkflowAssignmentDelete
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowAssignmentInsertUpdate')
BEGIN
	DROP PROCEDURE usp_WorkflowAssignmentInsertUpdate
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowAssignmentSelect')
BEGIN
	DROP PROCEDURE usp_WorkflowAssignmentSelect
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowAssignmentsSelect')
BEGIN
	DROP PROCEDURE usp_WorkflowAssignmentsSelect
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowDelete')
BEGIN
	DROP PROCEDURE usp_WorkflowDelete
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowInsertUpdate')
BEGIN
	DROP PROCEDURE usp_WorkflowInsertUpdate
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowPathLogicDelete')
BEGIN
	DROP PROCEDURE usp_WorkflowPathLogicDelete
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowPathLogicInsertUpdate')
BEGIN
	DROP PROCEDURE usp_WorkflowPathLogicInsertUpdate
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowPathLogicSelect')
BEGIN
	DROP PROCEDURE usp_WorkflowPathLogicSelect
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowSelect')
BEGIN
	DROP PROCEDURE usp_WorkflowSelect
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowStartItem')
BEGIN
	DROP PROCEDURE usp_WorkflowStartItem
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowTaskDelete')
BEGIN
	DROP PROCEDURE usp_WorkflowTaskDelete
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowTaskHasLogicCheck')
BEGIN
	DROP PROCEDURE usp_WorkflowTaskHasLogicCheck
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowTaskInsertUpdate')
BEGIN
	DROP PROCEDURE usp_WorkflowTaskInsertUpdate
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowTaskLogicDelete')
BEGIN
	DROP PROCEDURE usp_WorkflowTaskLogicDelete
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowTaskLogicInsertUpdate')
BEGIN
	DROP PROCEDURE usp_WorkflowTaskLogicInsertUpdate
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowTaskLogicSelect')
BEGIN
	DROP PROCEDURE usp_WorkflowTaskLogicSelect
END
IF EXISTS (select * from sys.procedures where name = 'usp_WorkflowTaskSelect')
BEGIN
	DROP PROCEDURE usp_WorkflowTaskSelect
END
IF EXISTS (select * from sys.objects where type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND name = 'ufn_GetApplicationFeatureSetting')
BEGIN
	DROP FUNCTION ufn_GetApplicationFeatureSetting
END


GO
----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Al Tafur
-- Create date: 08/29/2012
-- Description:	Returns the logic condition value for the given logic parameter and workflowid
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetTaskLogic] 
(
	@pWorkflowTaskId int,
	@pParamName varchar(50)	
)
RETURNS int
AS
BEGIN

	DECLARE @pLogicContidion INT

	SELECT		@pLogicContidion = LogicCondition
	  FROM		WorkflowTaskLogic (NOLOCK)
	 WHERE		WorkflowTaskId = @pWorkflowTaskId
	   and      LogicParam	=	@pParamName
    

	RETURN @pLogicContidion

END

----------------------------------------------------------------------------------------------------------

GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetWorkflowAssignment]    Script Date: 09/20/2012 13:22:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 08/29/2012
-- Description:	Returns the workflow id for a given contract number
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetWorkflowAssignment] 
(
	@pContractId int
)
RETURNS int
AS
BEGIN

	DECLARE @pWorkflowId INT
	DECLARE @UtilityId INT
	DECLARE @MarketId INT
	DECLARE @ContractTypeId INT
	DECLARE @ContractDealTypeId INT
	DECLARE @ContractTemplateTypeId INT
 
	SELECT TOP 1 @UtilityId = A.UtilityId
		  ,@MarketId = A.RetailMktId
		  ,@ContractTypeId = C.ContractTypeId
		  ,@ContractDealTypeId = C.ContractDealTypeId
		  ,@ContractTemplateTypeId = C.ContractTemplateId
	FROM LibertyPower..Contract C (NOLOCK)
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.ContractId = C.ContractId
	JOIN LibertyPower..Account A (NOLOCK) ON A.AccountId = AC.AccountId
	WHERE C.ContractId = @pContractId
	
--set @UTILITYID = 14
--set @MarketId = 7
--Set @ContractTypeId = 2
--Set @ContractDealTypeid = 1
--Set @ContractTemplateTypeId = 1
 
    IF @ContractTemplateTypeId <> 0 AND
	   @ContractDealTypeId <> 0 AND
       @ContractTypeId <> 0 AND
       @MarketId <> 0 AND
       @UtilityId <> 0
    BEGIN
          SELECT @pWorkflowId = W.WorkflowId
            FROM Libertypower..WorkflowAssignment wa (NOLOCK)
            JOIN Libertypower..Workflow w (NOLOCK) ON wa.workflowid = w.workflowid
          WHERE wa.UtilityId = @UtilityId
             AND wa.MarketId = @MarketId
             AND wa.ContractTypeId = @ContractTypeId
             AND wa.ContractDealTypeId = @ContractDealTypeId
            AND wa.ContractTemplateTypeId = @ContractTemplateTypeId 
             AND w.IsActive = 1
             AND w.IsRevisionOfRecord = 1
             AND w.IsDeleted IS NULL    
    END
    
    IF @pWorkflowId IS NULL 
    BEGIN
          SELECT @pWorkflowId = W.WorkflowId
            FROM Libertypower..WorkflowAssignment wa (NOLOCK)
            JOIN Libertypower..Workflow w (NOLOCK) ON wa.workflowid = w.workflowid
          WHERE wa.MarketId = @MarketId
             AND wa.UtilityId IS NULL 
             AND wa.ContractTypeId = @ContractTypeId
             AND wa.ContractDealTypeId = @ContractDealTypeId
             AND wa.ContractTemplateTypeId = @ContractTemplateTypeId 
             AND w.IsActive = 1
             AND w.IsRevisionOfRecord = 1
             AND w.IsDeleted IS NULL                               
    END
    
    IF @pWorkflowId IS NULL
    BEGIN
          SELECT @pWorkflowId = W.WorkflowId
		    FROM Libertypower..WorkflowAssignment wa (NOLOCK)
		    JOIN Libertypower..Workflow w (NOLOCK) ON wa.workflowid = w.workflowid
		   WHERE wa.MarketId IS NULL
             AND wa.UtilityId IS NULL 
		     AND wa.ContractTypeId = @ContractTypeId
             AND wa.ContractDealTypeId = @ContractDealTypeId
             AND wa.ContractTemplateTypeId = @ContractTemplateTypeId 
		     AND w.IsActive = 1
		     AND w.IsRevisionOfRecord = 1
		     AND w.IsDeleted IS NULL                                
    END

	RETURN @pWorkflowId

END
GO
----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Returns the task statuses
-- =============================================

CREATE PROCEDURE usp_TaskStatusSelect 
(
	@IsActive int = 1
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [TaskStatusID]
		  ,[StatusName]
		  ,[IsActive]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	FROM [LibertyPower].[dbo].[TaskStatus]
	WHERE (IsDeleted is null OR IsDeleted = 0)
	  AND (@IsActive is null OR IsActive = @IsActive)
    
END
GO
----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Sets the flag IsDeleted for a task type
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaskTypeDelete] 
(
	@TaskTypeID         int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [LibertyPower].[dbo].[TaskType]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE TaskTypeID = @TaskTypeID
		
END
----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Inserts or updates task types
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaskTypeInsertUpdate] 
(
	@TaskTypeID         int = 0,
	@TaskName			nvarchar(25),
	@IsActive			bit,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@TaskTypeID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[TaskType]
			   ([TaskName]
			   ,[IsActive]
			   ,[IsDeleted]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@TaskName
			   ,@IsActive
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
			   
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[TaskType]
		   SET [TaskName] = @TaskName
			  ,[IsActive] = @IsActive
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		 WHERE TaskTypeID = @TaskTypeID
	END
		
    
END
----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-13
-- Description:	Returns the task types
-- =============================================

CREATE PROCEDURE usp_TaskTypeSelect 
(
	@IsActive int = 1
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [TaskTypeID]
		  ,[TaskName]
		  ,[IsActive]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	FROM [LibertyPower].[dbo].[TaskType] TT
	WHERE (@IsActive is null OR TT.IsActive = @IsActive)
	  AND (IsDeleted is null OR IsDeleted = 0)
    
END
GO

----------------------------------------------------------------------------------------------------------


GO

/****** Object:  StoredProcedure [dbo].[usp_WIPTaskHeaderInsertUpdate]    Script Date: 08/13/2012 19:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Inserts a record header for a given contract
-- =============================================

CREATE PROCEDURE [dbo].[usp_WIPTaskHeaderInsertUpdate] 
(
	@WIPTaskHeaderId	int = 0,
	@ContractId		        int,  -- ITEM NUMBER HAS TO MATCH THE ITEM TYPE FOR THE START TRANSACTION
	@ContractTypeId		    int,
	@WorkflowId		    int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50) = null,
    @DateUpdated		datetime = null
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WIPTaskHeaderId = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WIPTaskHeader]
				   ([ContractTypeId]
				   ,[ContractId]
				   ,[WorkflowId]
				   ,[CreatedBy]
				   ,[DateCreated]
				   ,[UpdatedBy]
				   ,[DateUpdated])
			 VALUES
				   (@ContractTypeId
				   ,@ContractId
				   ,@WorkflowId
				   ,@CreatedBy
				   ,ISNULL(@DateCreated,CURRENT_TIMESTAMP)
				   ,@UpdatedBy
				   ,@DateUpdated)
		   
		RETURN @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WIPTaskHeader]
		   SET [ContractTypeId] = @ContractTypeId
			  ,[ContractId] = @ContractId
			  ,[WorkflowId] = @WorkflowId
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] =  ISNULL(@DateUpdated,CURRENT_TIMESTAMP)
		 WHERE WIPTaskHeaderId = @WIPTaskHeaderId

	END
		    
END

GO

----------------------------------------------------------------------------------------------------------


GO

/****** Object:  StoredProcedure [dbo].[usp_WIPTaskInsertUpdate]    Script Date: 08/13/2012 19:08:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Inserts/updates the entire workflowtask record for a given WIP task header
-- =============================================

CREATE PROCEDURE [dbo].[usp_WIPTaskInsertUpdate] 
(
	@WIPTaskId			int= 0,
	@WIPTaskHeaderId    int,  
	@WorkflowTaskId	    int,
	@TaskStatusId	    int,
	@IsAvailable		int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50) = null,
    @DateUpdated		datetime = null
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WIPTaskId = 0)
	BEGIN
	INSERT INTO [LibertyPower].[dbo].[WIPTask]
			   ([WIPTaskHeaderId]
			   ,[WorkflowTaskId]
			   ,[TaskStatusId]
			   ,[IsAvailable]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@WIPTaskHeaderId
			   ,@WorkflowTaskId
			   ,@TaskStatusId
			   ,@IsAvailable
			   ,@CreatedBy
			   ,ISNULL(@DateCreated,CURRENT_TIMESTAMP)
			   ,@UpdatedBy
			   ,@DateUpdated)
		   
		RETURN @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WIPTask]
		   SET [WIPTaskHeaderId] = @WIPTaskHeaderId
			  ,[WorkflowTaskId] = @WorkflowTaskId
			  ,[TaskStatusId] = @TaskStatusId
			  ,[IsAvailable] = @IsAvailable
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = ISNULL(@DateUpdated,CURRENT_TIMESTAMP)
		 WHERE WIPTaskId = @WIPTaskId
		 AND   WorkflowTaskId = @WorkflowTaskId
	END
END

GO

----------------------------------------------------------------------------------------------------------


GO
/****** Object:  StoredProcedure [dbo].[usp_WIPTaskSelect]    Script Date: 08/17/2012 08:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Created: Isabelle Tamanini 07/23/2012
-- Selects the WIP tasks
-- =============================================
/*

exec libertypower..[usp_WIPTaskSelect] @p_username=N'LIBERTYPOWER\itamanini',@p_view=null,@p_rec_sel=N'50',@p_contract_nbr_filter=N'none',@p_check_type_filter=NULL,@p_check_request_id_filter=NULL

exec lp_enrollment..usp_check_account_sel_list @p_username=N'LIBERTYPOWER\dmarino',@p_view=N'ALL',@p_rec_sel=N'50',@p_contract_nbr_filter=N'none',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',@p_check_type_filter=N'ALL',@p_check_request_id_filter=N'NONE' 

exec lp_enrollment..usp_check_account_sel_list_eric @p_username=N'LIBERTYPOWER\dmarino',@p_view=N'ALL',@p_rec_sel=N'50',@p_contract_nbr_filter=N'02795488',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',@p_check_type_filter=N'ALL',@p_check_request_id_filter=N'NONE' 

*/ 
CREATE PROCEDURE [dbo].[usp_WIPTaskSelect]
(@p_username                                        nchar(100)=null,
 @p_check_type_filter                               varchar(50)= null,
 @p_contract_nbr_filter                             char(12)= null,
 @p_check_request_id_filter                         char(25)= null,
 @p_view                                            varchar(50)= null,
 @p_rec_sel                                         int = 50,
 @p_request_id                                      varchar(50)= null,
 @p_WIPTaskId										int = null)
as

IF (@p_check_type_filter IN ('NONE', 'ALL'))
BEGIN
	SET @p_check_type_filter = NULL
END
IF (@p_contract_nbr_filter IN ('NONE', 'ALL'))
BEGIN
	SET @p_contract_nbr_filter = NULL
END
IF (@p_check_request_id_filter IN ('NONE', 'ALL'))
BEGIN
	SET @p_check_request_id_filter = NULL
END
IF (@p_view IN ('NONE', 'ALL'))
BEGIN
	SET @p_view = null
END
IF (@p_request_id IN ('NONE', 'ALL'))
BEGIN
	SET @p_request_id = NULL
END
IF (@p_rec_sel = 0)
BEGIN
	SET @p_rec_sel = 5000
END


SELECT TOP (@p_rec_sel) 
	   C.Number [contract_nbr]
	 , '' as [account_number]
	 , '' as [account_id]
     , TT.TaskName AS [check_type]
     , [check_request_id] = case when cdt.DealType = 'New' then 'Enrollment'
							else cdt.DealType
							end
     , TS.StatusName  AS [approval_status]
     , WT.DateCreated AS [approval_status_date] 
     , ISNULL(WT.TaskComment, '')  AS [approval_comments]
     , ISNULL(WT.DateUpdated, '1900-01-01') AS [approval_eff_date]
     , '' AS [userfield_text_01]
     , '' AS [userfield_text_02]
     , '1900-01-01 00:00:00.000' AS [userfield_date_03]
     , '' AS [userfield_text_04]
     , '1900-01-01 00:00:00.000' AS [userfield_date_05]
     , '1900-01-01 00:00:00.000' AS [userfield_date_06]
     , '0' AS [userfield_amt_07]
     , ISNULL(wt.UpdatedBy, wt.CreatedBy) as [username]
     , WT.DateCreated AS [date_created]
	 , days_aging = case when wt.DateUpdated is null then  
					  DATEDIFF(day, wt.DateCreated, getdate())  
				    else  
					  DATEDIFF(day, wt.DateCreated, wt.DateUpdated)  
				    end
	 , wt.WIPTaskId
	 , 1 as credit_ind
	 , W.WorkflowName
  INTO #check_account
  FROM LibertyPower..WIPTaskHeader    WTH (NOLOCK)   
  JOIN LibertyPower..WIPTask	      WT  (NOLOCK) ON WTH.WIPTaskHeaderId = WT.WIPTaskHeaderId
  JOIN LibertyPower..WorkflowTask     WFT (NOLOCK) ON WT.workflowtaskid = WFT.workflowtaskid
  JOIN LibertyPower..TaskStatus       TS  (NOLOCK) ON WT.TaskStatusId = TS.TaskStatusId
  JOIN LibertyPower..TaskType         TT  (NOLOCK) ON WFT.tasktypeid = TT.tasktypeid
  JOIN LibertyPower..[Contract]       C   (NOLOCK) ON WTH.ContractId = C.contractid
  JOIN LibertyPower..ContractDealType CDT (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID
  JOIN LibertyPower..Workflow         W   (NOLOCK) ON WTH.WorkflowId = W.WorkflowId
 WHERE WT.IsAvailable = 1
   AND C.Number = ISNULL(@p_contract_nbr_filter, C.Number)
   AND TT.TaskName = ISNULL(@p_check_type_filter, TT.TaskName)
   AND TS.StatusName = ISNULL(@p_view, TS.StatusName)
   AND CDT.DealType = ISNULL(@p_check_request_id_filter, CDT.DealType)
   AND WT.WIPTaskId = ISNULL(@p_WIPTaskId, WT.WIPTaskId)


SELECT ContractID, Number  
INTO #Contract  
FROM LibertyPower..[Contract] C  
JOIN #check_account CA ON C.Number = CA.contract_nbr 

Create clustered index idx1 on #Contract (ContractID) with fillfactor=100


DELETE FROM #check_account WHERE contract_nbr NOT IN
(SELECT C.Number FROM LibertyPower..[Contract] C(NOLOCK)
 JOIN LibertyPower..AccountExpanded E(NOLOCK) ON C.ContractID = E.ContractID WHERE E.ContractID IS NOT NULL  )

-- We create this temp table in order to retrieve enrollment types at a contract level (which will be used below).  
CREATE TABLE #contract_enrollment_type (contract_nbr char(12), enrollment_type varchar(50), term_months int, origin varchar(50) )   


SELECT C.Number as contract_nbr, ET.[Type] as enrollment_type, AC.AccountContractID, A.Origin as origin
into #t2
FROM #Contract C (NOLOCK)
JOIN #check_account CA (NOLOCK) ON C.Number = CA.contract_nbr
JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.ContractID = C.ContractID   
JOIN LibertyPower..Account A (NOLOCK) ON A.AccountId = AC.AccountId
									 AND ((A.CurrentContractId = AC.ContractId and CA.check_request_id = 'ENROLLMENT')
									    OR (A.CurrentRenewalContractId = AC.ContractId and CA.check_request_id = 'RENEWAL'))
JOIN LibertyPower..AccountDetail AD (NOLOCK) ON A.AccountID = AD.AccountID  
JOIN LibertyPower..EnrollmentType ET (NOLOCK) ON AD.EnrollmentTypeID = ET.EnrollmentTypeID  
WHERE A.CurrentContractID IS NOT NULL  
AND  AD.EnrollmentTypeID IS NOT NULL  


/* New LUCA */
SELECT acr.AccountContractID, MAX(acr.AccountContractRateID) AcID   
into #t3_1
FROM Libertypower..AccountContractRate (NOLOCK) acr
join #t2 t (nolock) on t.AccountContractID = acr.AccountContractID
join #check_account ca (nolock) on ca.contract_nbr = t.contract_nbr
WHERE acr.IsContractedRate = 0
OR ca.check_request_id = 'RENEWAL'
GROUP BY acr.AccountContractID
                       

/* New LUCA */
INSERT #contract_enrollment_type  
SELECT t.contract_nbr,  MIN(T.[enrollment_type]) as enrollment_type,  
CASE WHEN MIN(ISNULL(AC_DefaultRate.AccountContractRateID,0)) = 0 THEN MAX(ACR2.Term)  
			ELSE MAX(AC_DefaultRate.Term)   
			END AS term_months,
	    t.Origin
FROM #t2 t (NOLOCK)  
JOIN #check_account ca (nolock) on ca.contract_nbr = t.contract_nbr
JOIN LibertyPower.dbo.AccountContractRate ACR2 WITH (NOLOCK) ON T.AccountContractID = ACR2.AccountContractID 
															AND (ACR2.IsContractedRate = 1 OR ca.check_request_id = 'RENEWAL')
LEFT JOIN (SELECT ACR_1.* 
			FROM LibertyPower.dbo.AccountContractRate ACR_1 (NOLOCK) 
			JOIN 	 ( SELECT AcID   
                       FROM #t3_1 (NOLOCK) 
                      ) Z  ON ACR_1.AccountContractRateID = Z.AcID   
			) AC_DefaultRate ON AC_DefaultRate.AccountContractID = T.AccountContractID  
GROUP BY T.contract_nbr, t.Origin    
  
SELECT a.*, 1 as [order], e.enrollment_type as EnrollmentType, e.term_months, e.origin
FROM #check_account a  
--JOIN(SELECT check_type, [order] = max([order])  
--     FROM lp_common..common_utility_check_type WITH (NOLOCK) 
--     GROUP by check_type) b ON a.check_type = b.check_type  
LEFT JOIN #contract_enrollment_type e ON a.contract_nbr = e.contract_nbr 
ORDER BY a.date_created, e.enrollment_type, a.approval_status_date  
  
  
DROP TABLE #contract_enrollment_type   
DROP TABLE #check_account

----------------------------------------------------------------------------------------------------------


GO
/****** Object:  StoredProcedure [dbo].[usp_WIPTaskUpdateStatus]    Script Date: 08/16/2012 09:12:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Created: Isabelle Tamanini 07/23/2012
-- Updates the status of a WIP task for a contract
-- =============================================
/*
begin tran
exec usp_WIPTaskUpdateStatus @p_username=N'LIBERTYPOWER\itamanini',@p_check_request_id=N'Enrollment',
@p_contract_nbr=N'test3',@p_check_type=N'tpv',@p_approval_status=N'APPROVED',@p_comment=N'test'

rollback
select * from wiptask
*/ 
CREATE PROCEDURE [dbo].[usp_WIPTaskUpdateStatus]
(@p_username         nchar(100)=null,
 @p_contract_nbr     char(12),
 @p_check_type       char(30),
 @p_approval_status	 char(15),
 @p_comment          varchar(max),
 @p_check_request_id char(15),
 @p_reason_code		 char(10) = 'NONE',
 @p_error            char(01) = ' ' output,
 @p_msg_id           char(08) = ' ' output,
 @p_descp            varchar(250) = ' ' output)
AS
BEGIN

	DECLARE @w_error     char(01)
	DECLARE @w_msg_id    char(08)
	DECLARE @w_descp     varchar(250)
	DECLARE @w_descp_add varchar(100)
	DECLARE @w_return    int
	DECLARE @w_application varchar(20)
	DECLARE @p_ContractID INT
	 
	SELECT @w_error = 'I', @w_msg_id = '00000001', @w_descp = ' ', @w_descp_add = ' ', @w_return = 0, @w_application = 'COMMON'

	-- This is a security check to see if the user has access to the Sales Channel.  If the username is "Usage Trigger" or "SYSTEM", then we bypass the security check.
	--DECLARE @w_role_name VARCHAR(50)
	--SELECT @w_order = [order], @w_role_name = role_name
	--FROM lp_common..common_utility_check_type WITH (NOLOCK) -- INDEX = common_utility_check_type_idx)
	--WHERE utility_id = @w_utility_id and contract_type = @w_contract_type and check_type = @p_check_type

	IF @p_username NOT IN ('SYSTEM','Usage Trigger','USAGE ACQUIRE SCRAPER') 
	--AND NOT EXISTS (SELECT sales_channel_role FROM lp_common..ufn_check_role(@p_username, @w_role_name))
	AND lp_common.dbo.ufn_is_liberty_employee(@p_username) = 0
	BEGIN
	   SELECT @w_error = 'E', @w_msg_id = '00000013', @w_application = 'SECURITY', @w_return = 1
	END

	-- Here we enforce that the comment cannot be blank.
	IF @p_comment is null or @p_comment = ' '
	BEGIN
	   SELECT @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00001011', @w_return = 1
	END

	IF @w_error = 'E'
	   GOTO GOTO_select

	-- Check if there is more than 1 account in contract.
	-- If so, then set to INCOMPLETE.
	IF @p_check_type = 'USAGE ACQUIRE' AND @p_approval_status = 'REJECTED' AND @p_username IN ('Usage Trigger','USAGE ACQUIRE SCRAPER')
	BEGIN
		IF (SELECT COUNT(A.AccountNumber) 
			FROM LibertyPower..Account    A (NOLOCK) 
			JOIN LibertyPower..[Contract] C (NOLOCK) ON A.CurrentContractID = C.ContractID 
													AND C.ContractID = @p_ContractID) > 1
			BEGIN
				SET	@p_approval_status = 'INCOMPLETE'
			END
	END

--new code
-------------------------------------
	
	SELECT @p_ContractID = ContractID
	  FROM LibertyPower..[Contract] (NOLOCK)
	 WHERE Number = @p_contract_nbr 
	
	DECLARE @p_TaskStatusID INT
	SELECT @p_TaskStatusID = TaskStatusID
	  FROM LibertyPower..TaskStatus (NOLOCK)
	 WHERE StatusName = @p_approval_status

	DECLARE @p_WIPTaskID INT
	DECLARE @p_WorkflowTaskID INT
	DECLARE @p_WorkflowTaskHeaderID INT
	DECLARE @p_WIPTaskStatus CHAR(15)
	DECLARE @p_WorkflowTaskTypeID INT
	DECLARE @p_WorkflowID INT
	
	SELECT @p_WorkflowTaskID = WIPT.WorkflowTaskID,
		   @p_WIPTaskID = WIPT.WIPTaskID,
		   @p_WIPTaskStatus = TS.StatusName,
		   @p_WorkflowTaskHeaderID = WTH.WIPTaskHeaderId,
		   @p_WorkflowTaskTypeID = TT.TaskTypeID,
		   @p_WorkflowID = WTH.WorkflowID
	  FROM LibertyPower..WIPTask       WIPT (NOLOCK)
	  JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
	  JOIN LibertyPower..WorkflowTask  WT   (NOLOCK) ON WT.WorkflowTaskID = WIPT.WorkflowTaskID
	  JOIN LibertyPower..TaskType      TT   (NOLOCK) ON TT.TaskTypeID = WT.TaskTypeID
	  JOIN LibertyPower..TaskStatus    TS   (NOLOCK) ON TS.TaskStatusID = WIPT.TaskStatusID
	 WHERE WTH.ContractId = @p_ContractID
	   AND TT.TaskName = @p_check_type
	
	-- Does not allow to reject an approved task
	IF (@p_WIPTaskStatus = 'APPROVED' AND @p_approval_status = 'REJECTED')
	BEGIN
		SELECT @w_error = 'E', @w_msg_id = '00000008', @w_application = 'ACCOUNT', @w_return = 1, @w_descp_add = '(check_account)'
		GOTO GOTO_select
	END
	
	--DECLARE @p_UserId INT
	--SELECT @p_UserId = UserId
	--  FROM LibertyPower..[User]
	-- WHERE Username = rtrim(ltrim(@p_username))
		
	--Update WIPTask record
	UPDATE LibertyPower..WIPTask
	   SET TaskStatusID = @p_TaskStatusID
	     , TaskComment = @p_comment
		 , DateUpdated = getdate()
		 , UpdatedBy = @p_username
	 WHERE WIPTaskID = @p_WIPTaskID
	
	--Record comments
	INSERT INTO lp_account..account_comments
	SELECT A.AccountIdLegacy AS account_id,
		   GETDATE(), 
		   @p_check_type, 
		   @p_comment, 
		   @p_username,
		   0
	FROM LibertyPower..Account A (NOLOCK) 
	WHERE CurrentContractID = @p_ContractID
	   OR CurrentRenewalContractId = @p_ContractID
	
	INSERT INTO lp_account..account_renewal_comments
	SELECT A.AccountIdLegacy AS account_id,
		   GETDATE(), 
		   @p_check_type, 
		   @p_comment, 
		   @p_username,
		   0
	FROM LibertyPower..Account A (NOLOCK) 
	WHERE CurrentRenewalContractId = @p_ContractID
	
	INSERT INTO lp_account..account_status_history 
	SELECT A.AccountIDLegacy, AST.[Status], AST.SubStatus, getdate(), @p_username, 
	@p_check_type, '','','','','','','','',getdate()
	FROM LibertyPower..Account A (NOLOCK) 
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID 
												  AND (A.CurrentContractID = AC.ContractID
												    OR A.CurrentRenewalContractId = AC.ContractId)
	JOIN LibertyPower..[Contract] C (NOLOCK)  ON AC.ContractID = C.ContractID
	JOIN LibertyPower..AccountStatus AST  (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE C.ContractID = @p_ContractID
	 
	IF (@p_WIPTaskStatus = 'REJECTED' AND @p_approval_status = 'APPROVED')
	BEGIN
		-- insert reason code for each account in contract
		INSERT INTO	lp_account..account_reason_code_hist
				(account_id, date_created, reason_code, process_id, username, chgstamp)
		SELECT A.AccountIdLegacy AS account_id,
			   GETDATE(), 
			   CASE WHEN @p_reason_code = 'NONE' THEN '1032' ELSE @p_reason_code END, 
			   'CHECK ACCOUNT', 
			   @p_username,
			   0
		FROM LibertyPower..Account A (NOLOCK) 
		WHERE CurrentContractID = @p_ContractID
		
		-- If not exists task rejected for the contract
		IF NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTask
						WHERE WIPTaskHeaderId = @p_WorkflowTaskHeaderID
						  AND TaskStatusId = 4)
		BEGIN
			UPDATE AcctS
			SET [Status] = '01000',
				SubStatus = '10'
			FROM LibertyPower..[Contract]       C  (NOLOCK)
			JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
			JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
			WHERE C.ContractId = @p_ContractID
			  AND Accts.Status <> '05000'
			  AND Accts.Status+Accts.SubStatus not in ('0700010', '0700020')
		END
	END

	--Update subsequent tasks to pending
	--gets list of task that depend on the task updated
	SELECT WPL.[WorkflowTaskID]
		  ,WPL.[WorkflowTaskIDRequired]
		  ,WPL.[ConditionTaskStatusID]
	INTO #DependentTasks
	FROM [LibertyPower].[dbo].[WorkflowPathLogic] WPL (NOLOCK)
	WHERE (WPL.IsDeleted is null OR WPL.IsDeleted = 0)
	  AND WPL.WorkflowTaskIDRequired = @p_WorkflowTaskID
	  AND WPL.ConditionTaskStatusID = @p_TaskStatusID


	--Check if dependent tasks don't have any other logic to keep them on hold
	DECLARE @p_DpWorkflowTaskID INT
	DECLARE cursorTasks CURSOR FOR

	SELECT DISTINCT WorkflowTaskID
	FROM #DependentTasks

	OPEN cursorTasks 

	FETCH NEXT FROM cursorTasks INTO @p_DpWorkflowTaskID
		
	WHILE (@@FETCH_STATUS <> -1) 
	BEGIN 
		--Select other tasks that the dependent task might depend on
		SELECT WPL.[WorkflowTaskID]
			  ,WPL.[WorkflowTaskIDRequired]
			  ,WPL.[ConditionTaskStatusID]
		INTO #OtherDependentTasks
		FROM [LibertyPower].[dbo].[WorkflowPathLogic] WPL (NOLOCK)
		WHERE (WPL.IsDeleted is null OR WPL.IsDeleted = 0)
		  AND WPL.WorkflowTaskID = @p_DpWorkflowTaskID
		  AND NOT (WPL.WorkflowTaskIDRequired = @p_WorkflowTaskID
					AND WPL.ConditionTaskStatusID = @p_TaskStatusID)
						   
		IF(@@rowcount > 0)
		BEGIN
			--Check if other conditions to have dependent task set to pending are already satisfied
			IF NOT EXISTS(SELECT 1
						  FROM LibertyPower..WIPTask       WIPT (NOLOCK)
						  JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
						  JOIN #OtherDependentTasks        TEMP (NOLOCK) ON TEMP.WorkflowTaskIDRequired = WIPT.WorkflowTaskID
						 WHERE WTH.ContractID = @p_ContractID
						   AND TEMP.ConditionTaskStatusID <> WIPT.TaskStatusID)
			BEGIN
				--Updates status of dependent task to pending
				UPDATE LibertyPower..WIPTask
				   SET TaskStatusID = 2 --Pending
				  FROM LibertyPower..WIPTask       WIPT (NOLOCK)
				  JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
				  JOIN LibertyPower..WorkflowTask  WT   (NOLOCK) ON WT.WorkflowTaskID = WIPT.WorkflowTaskID
				 WHERE WTH.ContractId = @p_ContractID
				   AND WT.WorkflowTaskID = @p_DpWorkflowTaskID
			END
		END
		ELSE
		BEGIN
		  --Updates status of dependent task to pending
		  UPDATE LibertyPower..WIPTask
			 SET TaskStatusID = 2 --Pending
			FROM LibertyPower..WIPTask       WIPT (NOLOCK)
			JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId
			JOIN LibertyPower..WorkflowTask  WT   (NOLOCK) ON WT.WorkflowTaskID = WIPT.WorkflowTaskID
		   WHERE WTH.ContractId = @p_ContractID
			 AND WT.WorkflowTaskID = @p_DpWorkflowTaskID
		END
		
		DROP TABLE #OtherDependentTasks
		
		FETCH NEXT FROM cursorTasks INTO @p_DpWorkflowTaskID
			
	END

	CLOSE cursorTasks 
	DEALLOCATE cursorTasks
	
	DROP TABLE #DependentTasks
-------------------------------------------
--end new code

	-- If approving a rate code approval step,
	-- set billing type to dual for those accounts without rate code, rate ready for accounts with rate code
	IF @p_check_type = 'RATE CODE APPROVAL' AND @p_approval_status = 'APPROVED'
		EXEC lp_account..usp_account_billing_type_upd @p_contract_nbr, @p_check_request_id
	
	DECLARE @p_WorkflowEventtriggerId INT
	DECLARE @p_RequiredTaskStatusId INT
	
	SELECT @p_WorkflowEventtriggerId = WorkflowEventtriggerId,
		   @p_RequiredTaskStatusId = RequiredTaskStatusId
    FROM WorkflowEventTrigger WTE (NOLOCK)
    JOIN AccountEventType AET (NOLOCK) on AET.AccountEventTypeId = WTE.AccountEventTypeId
    WHERE WTE.WorkflowId = @p_WorkflowID
      AND WTE.RequiredTaskId = @p_WorkflowTaskTypeID
      AND AET.Name = 'CommissionRequirementSatisfied'
      
	-- request commission transction
	IF (@p_WorkflowEventtriggerId IS NOT NULL)
	BEGIN
		DECLARE @pDealType VARCHAR(10)
		SELECT @pDealType = DT.DealType
		FROM LibertyPower..Contract C (NOLOCK)
		JOIN LibertyPower..ContractDealType DT (NOLOCK) ON DT.ContractDealTypeId = C.ContractDealTypeId
		WHERE C.ContractId = @p_ContractID
		
		IF (@p_RequiredTaskStatusId = (SELECT TaskStatusId
									   FROM TaskStatus
									   WHERE StatusName = 'APPROVED'))
		BEGIN
			IF (@pDealType = 'NEW')
			BEGIN
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, 'COMM', null, 'ENROLLMENT CHECK STEP',  @p_username
			END
			ELSE
			BEGIN
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, 'RENEWCOMM', null, 'RENEWAL CHECK STEP',  @p_username
			END
		END
		ELSE IF (@p_RequiredTaskStatusId = (SELECT TaskStatusId
									        FROM TaskStatus
									        WHERE StatusName = 'REJECTED'))
		BEGIN
			IF (@pDealType = 'NEW')
			BEGIN
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, null, null, 'ENROLLMENT REJECTION CHECK STEP',  @p_username
			END
			ELSE
			BEGIN
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, null, null, 'ENROLLMENT REJECTION CHECK STEP',  @p_username
			END
		END
	END
	
	--IF @w_commission_on_approval = 1 AND @p_approval_status = 'APPROVED'
	--	EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, 'COMM', null, 'ENROLLMENT CHECK STEP',  @p_username
	--ELSE IF @p_approval_status = 'REJECTED'
	--	EXECUTE lp_commissions..usp_transaction_request_enrollment_process 'NONE', @p_contract_nbr, null, null, 'ENROLLMENT REJECTION CHECK STEP',  @p_username
	
	IF(@p_approval_status = 'REJECTED')
	BEGIN
		--Set status to 999999-10 (07000-80 if contract is a renewal)
		UPDATE AcctS
		SET [Status] = case when DT.DealType = 'NEW' then '999999'
					   else '07000' end,
		    SubStatus = case when DT.DealType = 'NEW' then '10'
					    else '80' end
		FROM LibertyPower..[Contract]       C  (NOLOCK)
		JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
		JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
		JOIN LibertyPower..ContractDealType DT (NOLOCK) ON DT.ContractDealTypeId = C.ContractDealTypeId
		WHERE C.ContractId = @p_ContractID
		  AND Accts.Status not in ('05000', '07000')
		
		--IF contract is rejected in check account, set accounts status back to what they were before
		IF(@p_check_type = 'CHECK ACCOUNT')
		BEGIN
			UPDATE AccS
			SET [Status] = ZA.[Status],
				SubStatus = ZA.SubStatus
			FROM LibertyPower..Account A (NOLOCK)
			JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountId = AC.AccountId
														  AND AC.ContractId <> A.CurrentContractId
			JOIN LibertyPower..zAuditAccountStatus ZA (NOLOCK) ON AC.AccountContractId = ZA.AccountContractId
			JOIN LibertyPower..AccountContract ACNew (NOLOCK) ON A.AccountId = ACNew.AccountId
															 AND ACNew.ContractId = A.CurrentContractId
			JOIN LibertyPower..AccountStatus AccS (NOLOCK) ON AccS.AccountContractId = ACNew.AccountContractId
			WHERE A.CurrentContractId = @p_ContractID
			  AND ZA.zAuditAccountStatusId = (SELECT max(zAuditAccountStatusId)
											  FROM LibertyPower..zAuditAccountStatus ZA1 (NOLOCK)
											  WHERE ZA1.AccountContractId = AC.AccountContractId)
		END
	END
	ELSE IF(@p_approval_status = 'APPROVED')
	BEGIN
		DECLARE @p_SubmitEnrollmentFlag INT
		EXEC @p_SubmitEnrollmentFlag = LibertyPower..ufn_GetTaskLogic @p_WorkflowTaskID, 'Submitenrollment'
		
		
		IF --Not exists tasks for the contract that are not approved
	       NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTask
					   WHERE WIPTaskHeaderId = @p_WorkflowTaskHeaderID
					     AND TaskStatusId <> 3)
		   OR @p_SubmitEnrollmentFlag = 1 
		BEGIN	
			UPDATE A
			SET CurrentContractId = CurrentRenewalContractId,
			    CurrentRenewalContractId = NULL
			FROM LibertyPower..[Contract]       C  (NOLOCK)
			JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
			JOIN LibertyPower..Account			A  (NOLOCK) ON A.AccountId = AC.AccountId
														   AND A.CurrentRenewalContractId = AC.ContractId
			JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
			JOIN LibertyPower..AccountContract  ACOld (NOLOCK) ON ACOld.AccountId = A.AccountId
															  AND ACOld.ContractId = A.CurrentContractId
			JOIN LibertyPower..AccountStatus AcctSOld (NOLOCK) ON AcctSOld.AccountContractId = ACOld.AccountContractId
			WHERE C.ContractId = @p_ContractID
			  AND AcctSOld.Status in ('999999', '999998', '911000')
					
			UPDATE AcctS
			SET [Status] = '07000',
				SubStatus = '10'
			FROM LibertyPower..[Contract]       C  (NOLOCK)
			JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
			JOIN LibertyPower..Account			A  (NOLOCK) ON A.AccountId = AC.AccountId
														   AND A.CurrentRenewalContractId = AC.ContractId
			JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
			WHERE C.ContractId = @p_ContractID
			  AND Accts.Status = '01000'
		
			UPDATE AcctS
			SET [Status] = '05000',
				SubStatus = '10'
			FROM LibertyPower..[Contract]       C  (NOLOCK)
			JOIN LibertyPower..AccountContract  AC (NOLOCK) ON AC.ContractId = C.ContractId
			JOIN LibertyPower..Account			A  (NOLOCK) ON A.AccountId = AC.AccountId
														   AND A.CurrentContractId = AC.ContractId
			JOIN LibertyPower..AccountStatus AcctS (NOLOCK) ON AcctS.AccountContractId = AC.AccountContractId
			WHERE C.ContractId = @p_ContractID
			  AND Accts.Status in ('01000', '07000')
		END
	END
	
	GOTO_select:
	 
	IF @w_error <> 'N'
	BEGIN
	   EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp output, @w_application
	   SELECT @w_descp = ltrim(rtrim(@w_descp )) + ' ' + @w_descp_add
	END
	 
	--IF @p_result_ind = 'Y'
	--BEGIN
	   SELECT flag_error = @w_error, code_error = @w_msg_id, message_error = @w_descp
	   GOTO GOTO_return
	--END
	 
	SELECT @p_error = @w_error, @p_msg_id = @w_msg_id, @p_descp = @w_descp
	 
	GOTO_return:
	return @w_return

END

----------------------------------------------------------------------------------------------------------

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentDelete]    Script Date: 08/17/2012 16:14:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Ryan Russon
-- Create date: 2012-08-10
-- Description:	Deletes a workflow assignment
-- =============================================
CREATE PROCEDURE [dbo].[usp_WorkflowAssignmentDelete] 
(
	@WorkflowAssignmentId	int
)

AS

BEGIN
	
	SET NOCOUNT ON;
	DELETE FROM [LibertyPower]..[WorkflowAssignment]
	WHERE WorkflowAssignmentID = @WorkflowAssignmentID
	
END

GO

----------------------------------------------------------------------------------------------------------


GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentInsertUpdate]    Script Date: 08/29/2012 15:19:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Ryan Russon
-- Create date: 2012-08-10
-- Description:	Inserts or updates a workflow assignment, just like EF does effortlessly
-- =============================================
CREATE PROCEDURE [dbo].[usp_WorkflowAssignmentInsertUpdate] 
(
	@WorkflowAssignmentId	int	= NULL,		--INSERT if this value is NULL
	@WorkflowId				int,
	@MarketId				int = NULL,
	@UtilityId				int = NULL,
	@ContractTypeId			int,
	@ContractDealTypeId		int,
	@ContractTemplateTypeId	int,
	@CreatedBy				nvarchar(100) = NULL,
	@UpdatedBy				nvarchar(100) = NULL
)

AS

BEGIN
	
	SET NOCOUNT ON;

	--Check to see if a different workflow replicates the same criteria for assignment
	DECLARE @WorkflowName	VARCHAR(200)
	
	SELECT TOP 1
		@WorkflowName = W.WorkflowName
	FROM [LibertyPower]..[WorkflowAssignment]		wa WITH (NOLOCK)
	JOIN LibertyPower..Workflow						w WITH (NOLOCK)
		ON W.WorkflowID = WA.WorkflowID
	WHERE W.WorkflowId <> @WorkflowId
		AND (MarketId = @MarketId		or (MarketId IS NULL and @MarketId IS NULL))
		AND (UtilityId = @UtilityId		or (UtilityId IS NULL and @UtilityId IS NULL))
		AND ContractTypeId = @ContractTypeId
		AND ContractDealTypeId = @ContractDealTypeId
		AND ContractTemplateTypeId = @ContractTemplateTypeId

	IF @WorkflowName IS NOT NULL		and		@WorkflowName <> ''
	BEGIN
		SELECT 'These criteria are already assigned to Workflow "' + @WorkflowName + '."'		 AS 'WorkflowAssignmentId'	--Return error message for UI display
		RETURN
	END


	IF (@WorkflowAssignmentId IS NULL)
	BEGIN
		INSERT INTO [LibertyPower]..[WorkflowAssignment] (
			[WorkflowId],
			[MarketId],
			[UtilityId],
			[ContractTypeId],
			[ContractDealTypeId],
			[ContractTemplateTypeId],
			[DateCreated],
			[DateUpdated],
			[CreatedBy]
			--[UpdatedBy]
		 ) VALUES (
			@WorkflowId,
			@MarketId,
			@UtilityId,
			@ContractTypeId,
			@ContractDealTypeId,
			@ContractTemplateTypeId,
			GETDATE(),
			GETDATE(),
			@CreatedBy
)			   
		SELECT @@IDENTITY AS 'WorkflowAssignmentId'					--Return new ID
	END
	
	ELSE
	
	BEGIN
		UPDATE [LibertyPower]..[WorkflowAssignment]
		SET 
			[WorkflowId] = @WorkflowId,
			[MarketId] = @MarketId,
			[UtilityId] = @UtilityId,
			[ContractTypeId] = @ContractTypeId,
			[ContractDealTypeId] = @ContractDealTypeId,
			[ContractTemplateTypeId] = @ContractTemplateTypeId,
			[DateUpdated] = GETDATE(),
			[UpdatedBy] = @UpdatedBy
		WHERE WorkflowAssignmentID = @WorkflowAssignmentID
		
		SELECT @WorkflowAssignmentId AS 'WorkflowAssignmentId'		--Return original ID to be updated, to keep return of stored proc consistant
	END

END

GO

----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow assignments
-- by workflow id
-- =============================================

CREATE PROCEDURE usp_WorkflowAssignmentsSelect 
(
	@WorkflowID int
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT W.[WorkflowID]
		  ,W.[WorkflowName]
		  ,W.[WorkflowDescription]
		  ,W.[IsActive] AS IsActiveWorkflow
		  ,W.[Version]
		  ,W.[IsRevisionOfRecord]
		  ,WA.[WorkflowAssignmentID]
		  ,WA.[MarketId]
		  ,WA.[UtilityId]
		  ,WA.[ContractTypeId]
		  ,WA.[ContractDealTypeId]
		  ,WA.[ContractTemplateTypeId]	
	FROM [LibertyPower].[dbo].[Workflow] W (NOLOCK)
	JOIN [LibertyPower].[dbo].[WorkflowAssignment] WA (NOLOCK) ON W.WorkflowID = WA.WorkflowID
	WHERE W.WorkflowID = @WorkflowID
    
END
GO

----------------------------------------------------------------------------------------------------------


GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentsSelect]    Script Date: 08/23/2012 16:29:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow assignments by workflow id
-- Updated:		Ryan Russon [08-07-2012] - Add all columns from WorkflowAssignment for use in Workflow Assignment editor
-- Usage:		EXEC usp_WorkflowAssignmentsSelect @WorkflowID=2
-- =============================================
ALTER PROCEDURE [dbo].[usp_WorkflowAssignmentsSelect](
	@WorkflowId		int = NULL
)

AS

BEGIN

	SET NOCOUNT ON;

	SELECT
		WA.WorkflowAssignmentId,
		W.WorkflowId,
		W.WorkflowName,
		W.WorkflowDescription,
		--W.IsActive AS IsActiveWorkflow,
		W.IsActive,
		W.[Version],
		W.IsRevisionOfRecord,
		WA.MarketId,
		IsNull(M.RetailMktDescp, 'ALL')			AS MarketName,
		WA.UtilityId,
		IsNull(U.ShortName, 'ALL')				AS UtilityName,
		WA.ContractTypeId,
		WA.ContractDealTypeId,
		WA.ContractTemplateTypeId,
		WA.CreatedBy,
		WA.DateCreated,
		WA.UpdatedBy,
		WA.DateUpdated
	FROM
		LibertyPower..Workflow					W WITH (NOLOCK)
		JOIN LibertyPower..WorkflowAssignment	WA WITH (NOLOCK)
			ON W.WorkflowID = WA.WorkflowID
		LEFT JOIN LibertyPower..Market			M WITH (NOLOCK)
			ON M.ID = WA.MarketId
		LEFT JOIN LibertyPower..Utility			U WITH (NOLOCK)
			ON U.ID = WA.UtilityId
	WHERE (@WorkflowId IS NULL		OR		W.WorkflowId = @WorkflowId)

END

GO

----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-20
-- Description:	Sets the flag IsDeleted for a workflow
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowDelete] 
(
	@WorkflowID         int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[Workflow]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowID = @WorkflowID
		
    
END

----------------------------------------------------------------------------------------------------------


GO
/****** Object:  StoredProcedure [dbo].[usp_WorkflowInsertUpdate]    Script Date: 06/14/2012 15:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Inserts or updates workflows
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowInsertUpdate] 
(
	@WorkflowID         int = 0,
	@Name			    nvarchar(25),
	@Description		nvarchar(50),
    @IsActive			bit,
    @Version			nchar(5),
    @IsRevisionOfRecord bit,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkFlowID = 0)
	BEGIN
		DECLARE @p_Version NCHAR(5)
		
		SELECT @p_Version = ISNULL((CONVERT(DECIMAL(3,1), max([Version]))+0.1), 1.0)
        FROM [LibertyPower].[dbo].[Workflow]
        WHERE [WorkflowName] = @Name
		
		INSERT INTO [LibertyPower].[dbo].[Workflow]
			   ([WorkflowName]
			   ,[WorkflowDescription]
			   ,[IsActive]
			   ,[Version]
			   ,[IsRevisionOfRecord]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@Name
			   ,@Description
			   ,@IsActive
			   ,@p_Version
			   ,@IsRevisionOfRecord
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
			   
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		IF(@IsRevisionOfRecord = 1)
		BEGIN
		   UPDATE [LibertyPower].[dbo].[Workflow]
		      SET [IsRevisionOfRecord] = 0
			     ,[UpdatedBy] = @UpdatedBy
			     ,[DateUpdated] = @DateUpdated
		    WHERE WorkflowName = @Name
		      AND [Version] <> @Version
		END
		
		UPDATE [LibertyPower].[dbo].[Workflow]
		   SET [WorkflowName] = @Name
			  ,[WorkflowDescription] = @Description
			  ,[IsActive] = @IsActive
			  ,[Version] = @Version
			  ,[IsRevisionOfRecord] = @IsRevisionOfRecord
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		 WHERE WorkflowID = @WorkflowID
	END
		
    
END

----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Sets the flag IsDeleted for a workflow path logic
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowPathLogicDelete] 
(
	@WorkflowPathLogicID     int,
	@IsDeleted	   		     bit,
    @UpdatedBy			     nvarchar(50),
    @DateUpdated		     datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[WorkflowPathLogic]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowPathLogicID = @WorkflowPathLogicID
		
    
END

----------------------------------------------------------------------------------------------------------


GO
/****** Object:  StoredProcedure [dbo].[usp_WorkflowInsertUpdate]    Script Date: 06/14/2012 15:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Inserts or updates workflow path logics
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowPathLogicInsertUpdate] 
(
	@WorkflowPathLogicID    int = 0,
	@WorkflowTaskID         int,
	@WorkflowTaskIDRequired int,
	@ConditionTaskStatusID  int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkflowPathLogicID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowPathLogic]
				   ([WorkflowTaskID]
				   ,[WorkflowTaskIDRequired]
				   ,[ConditionTaskStatusID]
				   ,[CreatedBy]
				   ,[DateCreated]
				   ,[UpdatedBy]
				   ,[DateUpdated]
				   ,[IsDeleted])
			 VALUES
				   (@WorkflowTaskID
				   ,@WorkflowTaskIDRequired
				   ,@ConditionTaskStatusID
				   ,@CreatedBy
				   ,@DateCreated
				   ,@UpdatedBy
				   ,@DateUpdated
				   ,0)
			   
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowPathLogic]
		   SET [WorkflowTaskID] = @WorkflowTaskID
			  ,[WorkflowTaskIDRequired] = @WorkflowTaskIDRequired
			  ,[ConditionTaskStatusID] = @ConditionTaskStatusID
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		WHERE WorkflowPathLogicID = @WorkflowPathLogicID
	END
		
    
END

----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Returns the path logics for a task
-- =============================================

CREATE PROCEDURE usp_WorkflowPathLogicSelect 
(
	@WorkflowTaskID int
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT WPL.[WorkflowPathLogicID]
		  ,WPL.[WorkflowTaskID]
		  ,WPL.[WorkflowTaskIDRequired]
		  ,WPL.[ConditionTaskStatusID]
		  ,WPL.[CreatedBy]
		  ,WPL.[DateCreated]
		  ,WPL.[UpdatedBy]
		  ,WPL.[DateUpdated]
		  ,TS.[StatusName]
		  ,TS.[IsActive] AS IsActiveTaskStatus
	FROM [LibertyPower].[dbo].[WorkflowPathLogic] WPL (NOLOCK)
	JOIN [LibertyPower].[dbo].[TaskStatus] TS         (NOLOCK) ON WPL.ConditionTaskStatusID = TS.TaskStatusID
	WHERE (WPL.IsDeleted is null OR WPL.IsDeleted = 0)
	  AND WPL.WorkflowTaskID = @WorkflowTaskID
    
END
GO

----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow by id
-- =============================================

CREATE PROCEDURE usp_WorkflowSelect 
(
	@WorkflowID int = null
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT W.[WorkflowID]
		  ,W.[WorkflowName]
		  ,W.[WorkflowDescription]
		  ,W.[IsActive] AS IsActiveWorkflow
		  ,W.[Version]
		  ,W.[IsRevisionOfRecord]
	FROM [LibertyPower].[dbo].[Workflow] W (NOLOCK)
	WHERE (@WorkflowID is null OR W.WorkflowID = @WorkflowID)
	  AND (IsDeleted is null OR IsDeleted = 0)
    
END
GO

----------------------------------------------------------------------------------------------------------


GO
/****** Object:  StoredProcedure [dbo].[usp_WorkflowStartItem]    Script Date: 08/29/2012 14:24:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Master proc to perform the start transaction for a given item
-- Test:  exec [usp_WorkflowStartItem] '123456','libertypower\atafur'
-- =============================================

CREATE PROCEDURE  [dbo].[usp_WorkflowStartItem] 
(
	@pContractNumber	varchar(50),  -- ITEM NUMBER HAS TO MATCH THE ITEM TYPE FOR THE START TRANSACTION
    @pCreatedBy			nvarchar(50)	=	null,
    @pDateCreated		datetime		=	null,
    @pUpdatedBy			nvarchar(50)	=	null,
    @pDateUpdated		datetime		=	null
)
AS
BEGIN
--EXEC libertypower..[usp_WorkflowStartItem] @ContractId, @ContractTypeID, @CreatedBy
/*DECLARE VARIABLES TO BE USED FOR THIS PROCESS*/	

    DECLARE @WorkflowId INT
    DECLARE @pContractId INT
	DECLARE @pContractTypeId INT

	SET NOCOUNT ON;
	
	SELECT @pContractId = ContractID,
		   @pContractTypeId = ContractTypeId
	FROM LibertyPower..[Contract]
	WHERE Number = @pContractNumber
	
	IF NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTaskHeader
				   WHERE ContractId = @pContractId)
	BEGIN
	
		/*FIND THE WORKFLOWID ASSIGNED FOR THE GIVEN ITEM*/
		SELECT  @WorkflowId = dbo.ufn_GetWorkflowAssignment(@pContractId)
		
		/* INSERT THE WIP HEADER RECORD */
		DECLARE	@TransactionDate datetime
		SET		@TransactionDate = CURRENT_TIMESTAMP

		DECLARE	@vWIPTaskHeaderId int

		EXEC	@vWIPTaskHeaderId = [dbo].[usp_WIPTaskHeaderInsertUpdate]
				@WIPTaskHeaderId	=	0,  -- 0 SINCE WE ARE ONLY MAKING AN INSERT
				@ContractId			=	@pContractId,
				@ContractTypeId		=	@pContractTypeId,
				@WorkflowId			=	@WorkflowId,
				@CreatedBy			=	@pCreatedBy,
				@DateCreated		=	@TransactionDate
		
		/* DETERMINE THE WORKFLOWTASKS FOR THE FOUND WORKFLOW */
		
		SELECT	wt.workflowid, wt.workflowtaskid
		INTO	#tmpWorkflowTasks 
		FROM	libertypower..workflowtask wt (nolock)
		JOIN	libertypower..tasktype t (nolock)
		ON		wt.tasktypeid = t.tasktypeid
		WHERE	workflowid = @WorkflowId
		AND		wt.IsDeleted = 0
		
		/* INSERT THE WORKFLOWTASKS IN THE WORK IN PROCESS TASK TABLE */
		
		DECLARE @tmpWorkflowTaskId INT
		
		DECLARE cursorTaskId cursor for
			SELECT workflowtaskid from #tmpWorkflowTasks
			
		OPEN cursorTaskId
		
		FETCH NEXT FROM cursorTaskId INTO @tmpWorkflowTaskId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			DECLARE @wTaskStatusId INT
			-- START STEP ON HOLD STATUS
			SET @wTaskStatusId = 6
			IF NOT EXISTS (SELECT 1 
						   FROM LibertyPower..WorkflowPathLogic
						   WHERE WorkflowTaskId = @tmpWorkflowTaskId
							 AND ConditionTaskStatusId <> 2)
			BEGIN
				SET @wTaskStatusId = 2 --PENDING
			END
					       
			/* EXECUTE THE INSERT PROC WITH THE GIVEN PARAMS */
			EXEC	[dbo].[usp_WIPTaskInsertUpdate]
					@WIPTaskId = 0,
					@WIPTaskHeaderId = @vWIPTaskHeaderId,
					@WorkflowTaskId = @tmpWorkflowTaskId,
					@TaskStatusId = @wTaskStatusId,  
					@IsAvailable = 1,
					@CreatedBy = @pCreatedBy
		  
			FETCH NEXT FROM cursorTaskId INTO @tmpWorkflowTaskId
			
		END
		
		CLOSE cursorTaskId
		
		DEALLOCATE cursorTaskId
		
		--UPDATE WIPT
		--SET TaskStatusId = 2 --PENDING
		--FROM LibertyPower..WIPTask WIPT
		--WHERE WIPT.WIPTaskHeaderId = @vWIPTaskHeaderId
		--  AND NOT EXISTS (SELECT 1 
		--				   FROM LibertyPower..WorkflowPathLogic (NOLOCK)
		--				   WHERE WorkflowTaskId = @tmpWorkflowTaskId
		--					 AND ConditionTaskStatusId <> 2)
		
	END
END

----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Sets the flag IsDeleted for a workflow task
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskDelete] 
(
	@WorkflowTaskID     int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[WorkflowTask]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowTaskID = @WorkflowTaskID
		
    
END

----------------------------------------------------------------------------------------------------------


GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskHasLogicCheck]    Script Date: 08/13/2012 19:13:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==========================================================================================
-- Author:		Al Tafur
-- Create date: 2012-07-09
-- Description:	Checks if a specific workflowtask has logic assigned
-- test:  exec usp_workflowtaskhaslogiccheck 4
-- ==========================================================================================

CREATE PROCEDURE  [dbo].[usp_WorkflowTaskHasLogicCheck] 
(
	@WorkflowTaskID      int
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT count(*)
  FROM [LibertyPower].[dbo].[WorkflowPathLogic]
  WHERE WorkflowTaskID = @WorkflowTaskID
	
    
END


GO
----------------------------------------------------------------------------------------------------------


GO
/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskInsertUpdate]    Script Date: 06/14/2012 15:35:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Inserts or updates workflow tasks
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskInsertUpdate] 
(
	@WorkflowID         int,
	@WorkflowTaskID     int = 0,
	@TaskSequence		int,
    @TaskTypeId int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkflowTaskID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowTask]
			   ([WorkflowID]
			   ,[TaskTypeID]
			   ,[TaskSequence]
			   ,[IsDeleted]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@WorkflowID
			   ,@TaskTypeId
			   ,@TaskSequence
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
		
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowTask]
		SET [TaskSequence] = @TaskSequence,
			[TaskTypeId] = @TaskTypeId,
			[UpdatedBy] = @UpdatedBy,
			[DateUpdated] = @DateUpdated
		WHERE WorkflowTaskID = @WorkflowTaskID
		AND WorkflowID = @WorkflowID
	END
		
    
END

----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Sets the flag IsDeleted for a workflow
-- task logic
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicDelete] 
(
	@WorkflowTaskLogicID int,
	@IsDeleted			 bit,
    @UpdatedBy			 nvarchar(50),
    @DateUpdated		 datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [LibertyPower].[dbo].[WorkflowTaskLogic]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowTaskLogicID = @WorkflowTaskLogicID
		
END

----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Inserts or updates workflow task logics
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicInsertUpdate] 
(
	@WorkflowTaskLogicID int = 0,
	@WorkflowTaskID      int,
	@LogicParam			 nvarchar(50),
    @LogicCondition		 int,
    @IsAutomated		 bit,
    @CreatedBy			 nvarchar(50) = null,
    @DateCreated		 datetime = null,
    @UpdatedBy			 nvarchar(50),
    @DateUpdated		 datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkFlowTaskLogicID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowTaskLogic]
           ([WorkflowTaskID]
           ,[LogicParam]
           ,[LogicCondition]
           ,[IsAutomated]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[DateCreated]
           ,[UpdatedBy]
           ,[DateUpdated])
		 VALUES
			   (@WorkflowTaskID
			   ,@LogicParam
			   ,@LogicCondition
			   ,@IsAutomated
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
	           
		 SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowTaskLogic]
		   SET [LogicParam] = @LogicParam
			  ,[LogicCondition] = @LogicCondition
			  ,[IsAutomated] = @IsAutomated
			  ,[CreatedBy] = @CreatedBy
			  ,[DateCreated] = @DateCreated
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		WHERE WorkflowTaskLogicID = @WorkflowTaskLogicID
		  AND WorkflowTaskID = @WorkflowTaskID
	END
		
    
END
----------------------------------------------------------------------------------------------------------


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Returns workflow task logics of a 
-- workflow task
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicSelect] 
(
	@WorkflowTaskLogicID int = null,
	@WorkflowTaskID      int
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [WorkflowTaskLogicID]
		  ,[WorkflowTaskID]
		  ,[LogicParam]
		  ,[LogicCondition]
		  ,[IsAutomated]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	 FROM [LibertyPower].[dbo].[WorkflowTaskLogic]
	 WHERE WorkflowTaskID = @WorkflowTaskID
	   AND (@WorkflowTaskLogicID is null OR WorkflowTaskLogicID = @WorkflowTaskID) 
	   AND (IsDeleted is null OR IsDeleted = 0)
		
    
END
GO
----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow tasks by workflow id
-- =============================================

CREATE PROCEDURE usp_WorkflowTaskSelect 
(
	@WorkflowID		int = null,
	@WorkflowTaskID int = null
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT W.[WorkflowID]
		  ,W.[WorkflowName]
		  ,W.[WorkflowDescription]
		  ,W.[IsActive] AS IsActiveWorkflow
		  ,W.[Version]
		  ,W.[IsRevisionOfRecord] 
		  ,WT.[WorkflowTaskID]
		  ,WT.[TaskTypeID]
		  ,WT.[TaskSequence]
		  ,TT.[TaskName]
		  ,TT.[IsActive] AS IsActiveTaskType
	FROM [LibertyPower].[dbo].[Workflow]		 W   (NOLOCK)
	JOIN [LibertyPower].[dbo].[WorkflowTask]	 WT  (NOLOCK) ON W.WorkflowID = WT.WorkflowID
	JOIN [LibertyPower].[dbo].[TaskType]		 TT  (NOLOCK) ON WT.TaskTypeID = TT.TaskTypeID
	WHERE (@WorkflowID is null OR W.WorkflowID = @WorkflowID)
	  AND (@WorkflowTaskID is null OR WT.WorkflowTaskID = @WorkflowTaskID)
	  AND (WT.IsDeleted is null OR WT.IsDeleted = 0)
	ORDER BY WT.[TaskSequence]
    
END
GO

----------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
* AUTHOR: Al Tafur
*
* FUNCTION:	usp_GetApplicationFeatureSetting
*
* DEFINITION:  Determines a true/false value for the requested appication feature
*
* RETURN CODE: TRUE/FALSE
*
* REVISIONS:	9/21/2012
TEST:
EXEC ufn_GetApplicationFeatureSetting 'IT043','EnrollmentApp'
*/

CREATE FUNCTION [dbo].[ufn_GetApplicationFeatureSetting]
(
		 @Featurename VARCHAR(20)
		,@ProcessName VARCHAR(50) = NULL
)
RETURNS BIT
AS
BEGIN

	DECLARE @FeatureValue BIT
	SET @FeatureValue = 0
     
	SELECT @FeatureValue = CASE WHEN [FeatureValue] IS NULL THEN 0
						   ELSE [FeatureValue]
						   END
	FROM  [ApplicationFeatureSettings] with (nolock)
	where [FeatureName] = @FeatureName
	and   (@ProcessName IS NULL OR Processname = @ProcessName)
	

	RETURN @FeatureValue 
	
END
----------------------------------------------------------------------------------------------------------


--commit
--rollback