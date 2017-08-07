USE [LibertyPower]
GO

----------------------------------------------------------------------------------------------------------

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
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (1, N'Voice Contracts', N'Voice Workflow', 1, N'1.0  ', 1, 1, N'LIBERTYPOWER\itamanini', CAST(0x0000A0B501085409 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0CC00D603AE AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (2, N'Paper Contracts', N'Paper Contracts', 1, N'1.0  ', 0, 1, N'LIBERTYPOWER\rstein', CAST(0x0000A0B600FCDEF1 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0CC00D605C6 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (3, N'NY Paper resi', N'NY Paper resi', 1, N'1.0  ', 1, 1, N'LIBERTYPOWER\rstein', CAST(0x0000A0BA01094202 AS DateTime), N'libertypower\rstein', CAST(0x0000A0CC010D1DB0 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (4, N'NJ Paper PSEG', N'NJ Paper PSEG', 1, N'1.0  ', 0, 1, N'LIBERTYPOWER\rstein', CAST(0x0000A0BC00F18DF6 AS DateTime), N'libertypower\rstein', CAST(0x0000A0CC010D22B7 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (5, N'test for created by', N'test for created by', 1, N'1.0  ', 0, 1, N'LIBERTYPOWER\rstein', CAST(0x0000A0BC0102A717 AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0CC00D608AA AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (6, N'Voice Contracts', N'Voice Workflow', 1, N'1.1  ', 0, 1, N'LIBERTYPOWER\itamanini', CAST(0x0000A0BC015B0E0B AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0CC00D60AEA AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (7, N'Voice Contracts', N'Voice Workflow', 1, N'1.2  ', 0, 1, N'LIBERTYPOWER\itamanini', CAST(0x0000A0BD00B5A91B AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0CC00D60CF1 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (8, N'Workflow Documentation', N'Test workflow created for documentation purposes', 1, N'1.0  ', 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00A4806E AS DateTime), N'libertypower\sshapansky', CAST(0x0000A0CC00D60FAE AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (9, N'Paper New Contract', N'Generic workflow for New Paper Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00E9F6FD AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00EEF900 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (10, N'Voice New Contract', N'Voice New Contract Generic', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F0AA05 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F0AA05 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (11, N'Voice New TX', N'Voice New Texas', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F5E2C6 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE010BB133 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (12, N'Voice New IL', N'Voice New IL Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F8F9B3 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00F8F9B3 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (13, N'Voice New Credit last', N'Voice New Credit last', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00FFAAAD AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE00FFAAAD AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (14, N'Paper New Usage first', N'Paper New Usage first', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01048766 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01048766 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (15, N'Paper New TX', N'Paper New TX Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0108DE14 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0108DE14 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (16, N'Paper New Ameren', N'Paper New IL-Ameren Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE010BD1FC AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE010E674E AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (17, N'Paper New COMED', N'Paper New COMED contract', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE010EE30E AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE010EE30E AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (18, N'Corporate New', N'Corporate New Contract', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01125B25 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01125B25 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (19, N'Paper Renewal', N'Paper Renewal Contract', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01135D1A AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01135D1A AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (20, N'Coporate Renewal', N'Corporate Renewal Contract', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE011589A9 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE011589A9 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (21, N'Voice Renewal', N'Voice Renewal', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01170063 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01170063 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (22, N'POLR', N'POLR Texas Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0119CC80 AS DateTime), N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0119CC80 AS DateTime))
INSERT [dbo].[Workflow] ([WorkflowID], [WorkflowName], [WorkflowDescription], [IsActive], [Version], [IsRevisionOfRecord], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (23, N'Power Move', N'Power Move Contracts', 1, N'1.0  ', 1, NULL, N'LIBERTYPOWER\itamanini', CAST(0x0000A0D300FC5138 AS DateTime), N'LIBERTYPOWER\itamanini', CAST(0x0000A0D300FC5138 AS DateTime))
SET IDENTITY_INSERT [dbo].[Workflow] OFF

GO

-- Workflow to contain all steps.
SET IDENTITY_INSERT Workflow ON
INSERT INTO LibertyPower.dbo.Workflow
        (WorkflowID, WorkflowName, WorkflowDescription, IsActive, Version, IsRevisionOfRecord, CreatedBy                 , DateCreated, UpdatedBy                 , DateUpdated)
SELECT 0         , 'AllSteps'  , 'All Steps'        , 0       , 1      , 0                 , 'libertypower\e3hernandez', getdate()  , 'libertypower\e3hernandez', getdate()
SET IDENTITY_INSERT Workflow OFF
 
INSERT INTO LibertyPower.dbo.WorkflowTask
        (WorkflowID, TaskTypeID, TaskSequence, IsDeleted, CreatedBy                 , DateCreated, UpdatedBy                 , DateUpdated)
SELECT 0         , TaskTypeID, 1           , 0        , 'libertypower\e3hernandez', getdate()  , 'libertypower\e3hernandez', getdate()
FROM LibertyPower.dbo.TaskType

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
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (54, 12, 5, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FC301A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FC301A AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (55, 13, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FFBE60 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FFBE60 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (56, 13, 6, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FFD550 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FFD550 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (57, 13, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE00FFF87B AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FFF87B AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (58, 13, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0100A1E6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0100A1E6 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (59, 13, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01013920 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01013920 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (60, 13, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0101B8E4 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0101B8E4 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (61, 14, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0104A575 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0104A575 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (62, 14, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0104B6A4 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0104B6A4 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (63, 14, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0104E81A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0104E81A AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (64, 14, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01051820 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01051820 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (65, 14, 3, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010557DB AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010557DB AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (66, 14, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01059EE9 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01059EE9 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (67, 15, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01092498 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01092498 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (68, 15, 3, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE01093BD6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01093BD6 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (69, 15, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE0109A072 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0109A072 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (70, 15, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010A1327 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010A1327 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (71, 15, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010A60D6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010A60D6 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (72, 15, 5, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010AD162 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010AD162 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (73, 15, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010B1976 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010B1976 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (74, 16, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010C130E AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010C130E AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (75, 16, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010C2F3B AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010C2F3B AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (76, 16, 3, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010C7D6A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010C7D6A AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (77, 16, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010CAD0D AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010CAD0D AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (78, 16, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010CEB88 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010CEB88 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (79, 16, 15, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010D85C9 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010D85C9 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (80, 16, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010DBDE7 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010DBDE7 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (81, 17, 8, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010EF76A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010EF76A AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (82, 17, 1, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010F08C9 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010F08C9 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (83, 17, 15, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010F23B0 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010F23B0 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (84, 17, 2, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010F4069 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010F4069 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (85, 17, 14, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010F5560 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010F5560 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (86, 17, 3, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010F67EC AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010F67EC AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (87, 17, 7, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010F7C05 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010F7C05 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (88, 17, 5, 0, 0, N'libertypower\atafur', CAST(0x0000A0BE010F92D3 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010F92D3 AS DateTime))
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
GO
print 'Processed 100 total records'
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
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (130, 23, 7, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FCC4B5 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FCC4B5 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (131, 11, 5, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FDAE67 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FDAE67 AS DateTime))
INSERT [dbo].[WorkflowTask] ([WorkflowTaskID], [WorkflowID], [TaskTypeID], [TaskSequence], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (132, 11, 7, 0, 0, N'libertypower\itamanini', CAST(0x0000A0D300FDD756 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FDD756 AS DateTime))
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
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (37, 45, 44, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F6A600 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F6A600 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (38, 46, 45, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00F6E65C AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00F6E65C AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (39, 48, 47, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FAA80A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FAA80A AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (40, 49, 48, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FAE105 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FAE105 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (41, 50, 49, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FB4AF1 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FB4AF1 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (42, 51, 50, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FB65A3 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FB65A3 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (43, 52, 51, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FB9525 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FB9525 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (44, 53, 52, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FBC538 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FBC538 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (45, 54, 53, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE00FC48D6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE00FC48D6 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (46, 56, 55, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01004D86 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01004D86 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (47, 57, 56, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01006F8D AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01006F8D AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (48, 58, 57, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0100C0B7 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0100C0B7 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (49, 59, 58, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010152FD AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010152FD AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (50, 60, 59, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0101D66D AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0101D66D AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (51, 62, 61, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0104C9C0 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0104C9C0 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (52, 63, 62, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01050065 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01050065 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (53, 64, 63, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01053C46 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01053C46 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (54, 65, 64, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010580D1 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010580D1 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (55, 66, 65, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0105B733 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0105B733 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (56, 68, 67, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0109807A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0109807A AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (57, 69, 68, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0109C09A AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0109C09A AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (58, 70, 69, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010A32E6 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010A32E6 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (59, 71, 70, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010A7DFB AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010A7DFB AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (60, 72, 71, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010AE8C1 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010AE8C1 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (61, 73, 72, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010B4425 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010B4425 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (62, 75, 74, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010C5820 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010C5820 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (63, 76, 75, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010C94E1 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010C94E1 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (64, 77, 76, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010CCD78 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010CCD78 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (65, 78, 77, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010D0741 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010D0741 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (66, 79, 78, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010D9C18 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010D9C18 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (67, 80, 79, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010DFE10 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010DFE10 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (68, 88, 87, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010FB69F AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010FB69F AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (69, 87, 86, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010FDA78 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010FDA78 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (70, 86, 85, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE010FFDDB AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE010FFDDB AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (71, 85, 84, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01102F20 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01102F20 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (72, 84, 83, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01104D56 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01104D56 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (73, 83, 82, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE01106B90 AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE01106B90 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (74, 82, 81, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0110A4BE AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0110A4BE AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (75, 91, 90, 3, 0, N'libertypower\atafur', CAST(0x0000A0BE0112BF1D AS DateTime), N'libertypower\atafur', CAST(0x0000A0BE0112BF1D AS DateTime))
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
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (92, 131, 46, 3, 0, N'libertypower\itamanini', CAST(0x0000A0D300FDC4A2 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FDC4A2 AS DateTime))
INSERT [dbo].[WorkflowPathLogic] ([WorkflowPathLogicID], [WorkflowTaskID], [WorkflowTaskIDRequired], [ConditionTaskStatusID], [IsDeleted], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (93, 132, 131, 3, 0, N'libertypower\itamanini', CAST(0x0000A0D300FDF773 AS DateTime), N'libertypower\itamanini', CAST(0x0000A0D300FDF773 AS DateTime))
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
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (6, 12, 13, NULL, 1, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE011FED9D AS DateTime), NULL, CAST(0x0000A0BE011FED9D AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (7, 18, NULL, NULL, 2, 1, 2, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE012038C1 AS DateTime), NULL, CAST(0x0000A0BE012038C1 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (8, 17, 13, 17, 2, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0120F3C2 AS DateTime), NULL, CAST(0x0000A0BE0120F3C2 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (9, 16, 13, 11, 2, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01213799 AS DateTime), NULL, CAST(0x0000A0BE01213799 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (10, 15, 1, NULL, 2, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE012189DF AS DateTime), NULL, CAST(0x0000A0BE012189DF AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (11, 14, 5, 16, 2, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01226C70 AS DateTime), NULL, CAST(0x0000A0BE01226C70 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (12, 14, 7, 26, 2, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE012294D2 AS DateTime), NULL, CAST(0x0000A0BE012294D2 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (13, 14, 2, NULL, 2, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0122C01A AS DateTime), NULL, CAST(0x0000A0BE0122C01A AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (14, 13, 5, 16, 1, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE01230AD8 AS DateTime), NULL, CAST(0x0000A0BE01230AD8 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (15, 13, 7, 26, 1, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE012357B3 AS DateTime), NULL, CAST(0x0000A0BE012357B3 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (16, 13, 2, NULL, 1, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0123731A AS DateTime), NULL, CAST(0x0000A0BE0123731A AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (17, 11, 1, NULL, 1, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0123CB61 AS DateTime), NULL, CAST(0x0000A0BE0123CB61 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (18, 10, NULL, NULL, 1, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE012488D6 AS DateTime), NULL, CAST(0x0000A0BE012488D6 AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (19, 9, NULL, NULL, 2, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0124DD0C AS DateTime), NULL, CAST(0x0000A0BE0124DD0C AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (20, 22, 1, NULL, 3, 1, 1, N'LIBERTYPOWER\atafur', CAST(0x0000A0BE0125872F AS DateTime), NULL, CAST(0x0000A0BE0125872F AS DateTime))
INSERT [dbo].[WorkflowAssignment] ([WorkflowAssignmentId], [WorkflowId], [MarketId], [UtilityId], [ContractTypeId], [ContractDealTypeId], [ContractTemplateTypeId], [CreatedBy], [DateCreated], [UpdatedBy], [DateUpdated]) VALUES (21, 23, 7, 18, 3, 1, 1, N'LIBERTYPOWER\itamanini', CAST(0x0000A0D3010EF931 AS DateTime), NULL, CAST(0x0000A0D3010EF931 AS DateTime))
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

----------------------------------------------------------------------------------------------------------