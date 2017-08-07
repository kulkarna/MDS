USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyRule_Property]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyRule]'))
	ALTER TABLE [dbo].[PropertyRule] DROP CONSTRAINT [FK_PropertyRule_Property]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PropertyR__Inact__78B58678]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[PropertyRule] DROP CONSTRAINT [DF__PropertyR__Inact__78B58678]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyRule_DateCreated]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[PropertyRule] DROP CONSTRAINT [DF_PropertyRule_DateCreated]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyRule]') AND type in (N'U'))
	DROP TABLE [dbo].[PropertyRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PropertyRule](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[RuleCode] [varchar](350) NULL,
	[RuleDescription] [varchar](max) NULL,
	[Inactive] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PropertyRule] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PropertyRule]  WITH CHECK ADD  CONSTRAINT [FK_PropertyRule_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[PropertyName] ([ID])
GO

ALTER TABLE [dbo].[PropertyRule] CHECK CONSTRAINT [FK_PropertyRule_Property]
GO

ALTER TABLE [dbo].[PropertyRule] ADD  DEFAULT ((0)) FOR [Inactive]
GO

ALTER TABLE [dbo].[PropertyRule] ADD  CONSTRAINT [DF_PropertyRule_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO





SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ExternalEntityPropertyRule](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExternalEntityID] [int] NULL,
	[PropertyRuleID] [int] NULL,
	[Inactive] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ExternalEntityPropertyRule] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ExternalEntityPropertyRule]  WITH NOCHECK ADD  CONSTRAINT [FK_ExternalEntityPropertyRule_ExternalEntity] FOREIGN KEY([ExternalEntityID])
REFERENCES [dbo].[ExternalEntity] ([ID])
GO

ALTER TABLE [dbo].[ExternalEntityPropertyRule] CHECK CONSTRAINT [FK_ExternalEntityPropertyRule_ExternalEntity]
GO

ALTER TABLE [dbo].[ExternalEntityPropertyRule]  WITH CHECK ADD  CONSTRAINT [FK_ExternalEntityPropertyRule_PropertyRule] FOREIGN KEY([PropertyRuleID])
REFERENCES [dbo].[PropertyRule] ([ID])
GO

ALTER TABLE [dbo].[ExternalEntityPropertyRule] CHECK CONSTRAINT [FK_ExternalEntityPropertyRule_PropertyRule]
GO

ALTER TABLE [dbo].[ExternalEntityPropertyRule] ADD  DEFAULT ((0)) FOR [Inactive]
GO

