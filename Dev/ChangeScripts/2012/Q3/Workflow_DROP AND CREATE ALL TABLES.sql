USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemType_ContractType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemType]'))
ALTER TABLE [dbo].[ItemType] DROP CONSTRAINT [FK_ItemType_ContractType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowAssignment_ContractType]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowAssignment]'))
ALTER TABLE [dbo].[WorkflowAssignment] DROP CONSTRAINT [FK_WorkflowAssignment_ContractType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowAssignment_Workflow]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowAssignment]'))
ALTER TABLE [dbo].[WorkflowAssignment] DROP CONSTRAINT [FK_WorkflowAssignment_Workflow]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowAutoComplete_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowAutoComplete]'))
ALTER TABLE [dbo].[WorkflowAutoComplete] DROP CONSTRAINT [FK_WorkflowAutoComplete_User]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowPathLogic_TaskStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowPathLogic]'))
ALTER TABLE [dbo].[WorkflowPathLogic] DROP CONSTRAINT [FK_WorkflowPathLogic_TaskStatus]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowPathLogic_WorkflowTask]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowPathLogic]'))
ALTER TABLE [dbo].[WorkflowPathLogic] DROP CONSTRAINT [FK_WorkflowPathLogic_WorkflowTask]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowPathLogic_WorkflowTask_Required]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowPathLogic]'))
ALTER TABLE [dbo].[WorkflowPathLogic] DROP CONSTRAINT [FK_WorkflowPathLogic_WorkflowTask_Required]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkFlowStepLogic_WorkFlowStep]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkFlowStepLogic]'))
ALTER TABLE [dbo].[WorkFlowStepLogic] DROP CONSTRAINT [FK_WorkFlowStepLogic_WorkFlowStep]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowTask_TaskType]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowTask]'))
ALTER TABLE [dbo].[WorkflowTask] DROP CONSTRAINT [FK_WorkflowTask_TaskType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowTask_Workflow]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowTask]'))
ALTER TABLE [dbo].[WorkflowTask] DROP CONSTRAINT [FK_WorkflowTask_Workflow]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowTaskLogic_WorkflowTask]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkflowTaskLogic]'))
ALTER TABLE [dbo].[WorkflowTaskLogic] DROP CONSTRAINT [FK_WorkflowTaskLogic_WorkflowTask]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ItemType]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemType]') AND type in (N'U'))
DROP TABLE [dbo].[ItemType]
GO

/****** Object:  Table [dbo].[TaskStatus]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaskStatus]') AND type in (N'U'))
DROP TABLE [dbo].[TaskStatus]
GO

/****** Object:  Table [dbo].[TaskType]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaskType]') AND type in (N'U'))
DROP TABLE [dbo].[TaskType]
GO

/****** Object:  Table [dbo].[Workflow]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Workflow]') AND type in (N'U'))
DROP TABLE [dbo].[Workflow]
GO

/****** Object:  Table [dbo].[WorkflowAssignment]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkflowAssignment]') AND type in (N'U'))
DROP TABLE [dbo].[WorkflowAssignment]
GO

/****** Object:  Table [dbo].[WorkflowAutoComplete]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkflowAutoComplete]') AND type in (N'U'))
DROP TABLE [dbo].[WorkflowAutoComplete]
GO

/****** Object:  Table [dbo].[WorkflowPathLogic]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkflowPathLogic]') AND type in (N'U'))
DROP TABLE [dbo].[WorkflowPathLogic]
GO

/****** Object:  Table [dbo].[WorkFlowStep]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkFlowStep]') AND type in (N'U'))
DROP TABLE [dbo].[WorkFlowStep]
GO

/****** Object:  Table [dbo].[WorkFlowStepLogic]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkFlowStepLogic]') AND type in (N'U'))
DROP TABLE [dbo].[WorkFlowStepLogic]
GO

/****** Object:  Table [dbo].[WorkflowTask]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkflowTask]') AND type in (N'U'))
DROP TABLE [dbo].[WorkflowTask]
GO

/****** Object:  Table [dbo].[WorkflowTaskLogic]    Script Date: 08/20/2012 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkflowTaskLogic]') AND type in (N'U'))
DROP TABLE [dbo].[WorkflowTaskLogic]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ItemType]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[TaskStatus]    Script Date: 08/20/2012 17:02:17 ******/
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

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[TaskType]    Script Date: 08/20/2012 17:02:17 ******/
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
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_TaskType] PRIMARY KEY CLUSTERED 
(
	[TaskTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[Workflow]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[WorkflowAssignment]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[WorkflowAutoComplete]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WorkflowAutoComplete](
	[WorkflowAutoAcceptID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserID] [int] NOT NULL,
	[AutoApproveDocument] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowAutoComplete] PRIMARY KEY CLUSTERED 
(
	[WorkflowAutoAcceptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Workflow' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkflowAutoComplete'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[WorkflowPathLogic]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[WorkFlowStep]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WorkFlowStep](
	[WorkFlowStepID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_WorkFlowStep] PRIMARY KEY CLUSTERED 
(
	[WorkFlowStepID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Workflow' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkFlowStep'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[WorkFlowStepLogic]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WorkFlowStepLogic](
	[WorkflowStepLogicID] [int] IDENTITY(1,1) NOT NULL,
	[WorkFlowStepID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Enabled] [bit] NULL,
	[DateCreated] [datetime] NULL,
 CONSTRAINT [PK_WorkFlowStepLogic_1] PRIMARY KEY CLUSTERED 
(
	[WorkflowStepLogicID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Workflow' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkFlowStepLogic'
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[WorkflowTask]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[WorkflowTaskLogic]    Script Date: 08/20/2012 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

ALTER TABLE [dbo].[ItemType]  WITH CHECK ADD  CONSTRAINT [FK_ItemType_ContractType] FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO

ALTER TABLE [dbo].[ItemType] CHECK CONSTRAINT [FK_ItemType_ContractType]
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

ALTER TABLE [dbo].[WorkflowAutoComplete]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowAutoComplete_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[WorkflowAutoComplete] CHECK CONSTRAINT [FK_WorkflowAutoComplete_User]
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

ALTER TABLE [dbo].[WorkFlowStepLogic]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkFlowStepLogic_WorkFlowStep] FOREIGN KEY([WorkFlowStepID])
REFERENCES [dbo].[WorkFlowStep] ([WorkFlowStepID])
GO

ALTER TABLE [dbo].[WorkFlowStepLogic] CHECK CONSTRAINT [FK_WorkFlowStepLogic_WorkFlowStep]
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

ALTER TABLE [dbo].[WorkflowTaskLogic]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTaskLogic_WorkflowTask] FOREIGN KEY([WorkflowTaskID])
REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID])
GO

ALTER TABLE [dbo].[WorkflowTaskLogic] CHECK CONSTRAINT [FK_WorkflowTaskLogic_WorkflowTask]
GO


