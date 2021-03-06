USE [LibertyPower]
GO
/****** Object:  Table [dbo].[Property]    Script Date: 05/06/2013 16:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertyName](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Inactive] [bit] NOT NULL DEFAULT 0,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PropertyName] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ExternalEntityType]    Script Date: 05/06/2013 16:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExternalEntityType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[Inactive] [bit] NOT NULL DEFAULT 0,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ExternalEntityType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ThirdPartyApplications]    Script Date: 05/06/2013 16:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ThirdPartyApplications](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ThirdPartyApplications] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PropertyType]    Script Date: 05/06/2013 16:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertyType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Inactive] [bit] NOT NULL DEFAULT 0,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PropertyType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PropertyInternalRef]    Script Date: 05/06/2013 16:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertyInternalRef](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](100) NOT NULL,
	[Inactive] [bit] NOT NULL DEFAULT 0,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[PropertyId] [int] NULL,
	[PropertyTypeId] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PropertyInternalRef] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY],
 CONSTRAINT [UQ_PropertyInternalRef_Value] UNIQUE NONCLUSTERED 
(
	[PropertyId] ASC,
	[Value] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ExternalEntity]    Script Date: 05/06/2013 16:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExternalEntity](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Inactive] [bit] NOT NULL DEFAULT 0,
	[ShowAs] [int] NULL,
	[EntityKey] [int] NOT NULL,
	[EntityTypeID] [int] NOT NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ExternalEntity] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY],
 CONSTRAINT [UQ_ExternalEntity] UNIQUE NONCLUSTERED 
(
	[EntityKey] ASC,
	[EntityTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropertyValue]    Script Date: 05/06/2013 16:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertyValue](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[InternalRefID] [int] NULL,
	[Value] [varchar](100) NOT NULL,
	[Inactive] [bit] NOT NULL DEFAULT 0,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[PropertyId] [int] NULL,
	[PropertyTypeId] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PropertyValue] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[ExternalEntityValue]    Script Date: 05/06/2013 16:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExternalEntityValue](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExternalEntityID] [int] NOT NULL,
	[Inactive] [bit] NOT NULL DEFAULT 0,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[PropertyValueID] [int] NOT NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ExternalEntityValue] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY],
 CONSTRAINT [UQ_ExternalEntityValue] UNIQUE NONCLUSTERED 
(
	[ExternalEntityID] ASC,
	[PropertyValueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PropertyTypeEntityTypeMap](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NOT NULL,
    [ExternalEntityTypeID] [int] NOT NULL,
	[Inactive] [bit] NOT NULL DEFAULT 0,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PropertyTypeEntityTypeMap] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO


/****** Object:  Default [DF_ExternalEntity_DateCreated]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntity] ADD  CONSTRAINT [DF_ExternalEntity_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
/****** Object:  Default [DF__ExternalE__Entit__3751D76F]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntity] ADD  DEFAULT ((0)) FOR [EntityKey]
GO
/****** Object:  Default [DF__ExternalE__Entit__3845FBA8]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntity] ADD  DEFAULT ((0)) FOR [EntityTypeID]
GO
/****** Object:  Default [DF_ExternalEntityType_DateCreated]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntityType] ADD  CONSTRAINT [DF_ExternalEntityType_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
/****** Object:  Default [DF_ExternalEntityValue_DateCreated]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntityValue] ADD  CONSTRAINT [DF_ExternalEntityValue_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
/****** Object:  Default [DF__ExternalE__Prope__40DB41A9]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntityValue] ADD  DEFAULT ((0)) FOR [PropertyValueID]
GO
/****** Object:  Default [DF_Property_DateCreated]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyName] ADD  CONSTRAINT [DF_PropertyName_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
/****** Object:  Default [DF_PropertyInternalRef_DateCreated]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyInternalRef] ADD  CONSTRAINT [DF_PropertyInternalRef_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
/****** Object:  Default [DF_PropertyType_DateCreated]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyType] ADD  CONSTRAINT [DF_PropertyType_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
/****** Object:  Default [DF_PropertyValue_DateCreated]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyValue] ADD  CONSTRAINT [DF_PropertyValue_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
/****** Object:  Default [DF_ThirdPartyApplications_DateCreated]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ThirdPartyApplications] ADD  CONSTRAINT [DF_ThirdPartyApplications_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
/****** Object:  ForeignKey [FK_ExternalEntity_ExternalEntityType]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntity]  WITH CHECK ADD  CONSTRAINT [FK_ExternalEntity_ExternalEntityType] FOREIGN KEY([EntityTypeID])
REFERENCES [dbo].[ExternalEntityType] ([ID])
GO
ALTER TABLE [dbo].[ExternalEntity] CHECK CONSTRAINT [FK_ExternalEntity_ExternalEntityType]
GO
/****** Object:  ForeignKey [FK_ExternalEntity_ThirdPartyApplications]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntity]  WITH NOCHECK ADD  CONSTRAINT [FK_ExternalEntity_ThirdPartyApplications] FOREIGN KEY([EntityKey])
REFERENCES [dbo].[ThirdPartyApplications] ([ID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[ExternalEntity] NOCHECK CONSTRAINT [FK_ExternalEntity_ThirdPartyApplications]
GO
/****** Object:  ForeignKey [FK_ExternalEntity_Utility]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntity]  WITH NOCHECK ADD  CONSTRAINT [FK_ExternalEntity_Utility] FOREIGN KEY([EntityKey])
REFERENCES [dbo].[Utility] ([ID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[ExternalEntity] NOCHECK CONSTRAINT [FK_ExternalEntity_Utility]
GO
/****** Object:  ForeignKey [FK_ExternalEntity_WholesaleMarket]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntity]  WITH NOCHECK ADD  CONSTRAINT [FK_ExternalEntity_WholesaleMarket] FOREIGN KEY([EntityKey])
REFERENCES [dbo].[WholesaleMarket] ([ID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[ExternalEntity] NOCHECK CONSTRAINT [FK_ExternalEntity_WholesaleMarket]
GO
/****** Object:  ForeignKey [FK_ExternalEntityValue_ExternalEntity]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntityValue]  WITH NOCHECK ADD  CONSTRAINT [FK_ExternalEntityValue_ExternalEntity] FOREIGN KEY([ExternalEntityID])
REFERENCES [dbo].[ExternalEntity] ([ID])
GO
ALTER TABLE [dbo].[ExternalEntityValue] CHECK CONSTRAINT [FK_ExternalEntityValue_ExternalEntity]
GO
/****** Object:  ForeignKey [FK_ExternalEntityValue_PropertyValue]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[ExternalEntityValue]  WITH NOCHECK ADD  CONSTRAINT [FK_ExternalEntityValue_PropertyValue] FOREIGN KEY([PropertyValueID])
REFERENCES [dbo].[PropertyValue] ([ID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[ExternalEntityValue] CHECK CONSTRAINT [FK_ExternalEntityValue_PropertyValue]
GO
/****** Object:  ForeignKey [FK_PropertyInternalRef_Property]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyInternalRef]  WITH NOCHECK ADD  CONSTRAINT [FK_PropertyInternalRef_Property] FOREIGN KEY([PropertyId])
REFERENCES [dbo].[PropertyName] ([ID])
GO
ALTER TABLE [dbo].[PropertyInternalRef] CHECK CONSTRAINT [FK_PropertyInternalRef_Property]
GO
/****** Object:  ForeignKey [FK_PropertyInternalRef_PropertyType]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyInternalRef]  WITH NOCHECK ADD  CONSTRAINT [FK_PropertyInternalRef_PropertyType] FOREIGN KEY([PropertyTypeId])
REFERENCES [dbo].[PropertyType] ([ID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[PropertyInternalRef] NOCHECK CONSTRAINT [FK_PropertyInternalRef_PropertyType]
GO
/****** Object:  ForeignKey [FK_PropertyType_Property]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyType]  WITH CHECK ADD  CONSTRAINT [FK_PropertyType_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[PropertyName] ([ID])
GO
ALTER TABLE [dbo].[PropertyType] CHECK CONSTRAINT [FK_PropertyType_Property]
GO
/****** Object:  ForeignKey [FK_PropertyValue_Property]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyValue]  WITH CHECK ADD  CONSTRAINT [FK_PropertyValue_Property] FOREIGN KEY([PropertyId])
REFERENCES [dbo].[PropertyName] ([ID])
GO
ALTER TABLE [dbo].[PropertyValue] CHECK CONSTRAINT [FK_PropertyValue_Property]
GO
/****** Object:  ForeignKey [FK_PropertyValue_PropertyInternalRef]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyValue]  WITH NOCHECK ADD  CONSTRAINT [FK_PropertyValue_PropertyInternalRef] FOREIGN KEY([InternalRefID])
REFERENCES [dbo].[PropertyInternalRef] ([ID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[PropertyValue] NOCHECK CONSTRAINT [FK_PropertyValue_PropertyInternalRef]
GO
/****** Object:  ForeignKey [FK_PropertyValue_PropertyType]    Script Date: 05/06/2013 16:24:58 ******/
ALTER TABLE [dbo].[PropertyValue]  WITH NOCHECK ADD  CONSTRAINT [FK_PropertyValue_PropertyType] FOREIGN KEY([PropertyTypeId])
REFERENCES [dbo].[PropertyType] ([ID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[PropertyValue] NOCHECK CONSTRAINT [FK_PropertyValue_PropertyType]
GO

ALTER TABLE [dbo].[PropertyTypeEntityTypeMap]  WITH CHECK ADD  CONSTRAINT [FK_PropertyTypeEntityTypeMap_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[PropertyName] ([ID])
GO

ALTER TABLE [dbo].[PropertyTypeEntityTypeMap] CHECK CONSTRAINT [FK_PropertyTypeEntityTypeMap_Property]
GO

ALTER TABLE [dbo].[PropertyTypeEntityTypeMap]  WITH CHECK ADD  CONSTRAINT [FK_PropertyTypeEntityTypeMap_ExtEntityType] FOREIGN KEY([ExternalEntityTypeID])
REFERENCES [dbo].[ExternalEntityType] ([ID])
GO

ALTER TABLE [dbo].[PropertyTypeEntityTypeMap] CHECK CONSTRAINT [FK_PropertyTypeEntityTypeMap_ExtEntityType]
GO

ALTER TABLE [dbo].[PropertyTypeEntityTypeMap] ADD  CONSTRAINT [DF_PropertyTypeEntityTypeMap_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO


