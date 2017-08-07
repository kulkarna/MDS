USE [LibertyPower]
GO

/****** Object:  Table [dbo].[AccountIcap]    Script Date: 02/21/2013 09:21:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

---------------------------------------------------------------------------------------------
-- Create DataSource table
---------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[DataSource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Source] [varchar](50) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[DataSource] ADD  CONSTRAINT [DF_DataSource_Created]  DEFAULT (getdate()) FOR [Created]
GO

---------------------------------------------------------------------------------------------
-- Insert data into the DataSource table
---------------------------------------------------------------------------------------------
insert into DataSource ([Source], Created, CreatedBy) Values ('Initial Upload', getdate(), 1)
insert into DataSource ([Source], Created, CreatedBy) Values ('Scraper', getdate(), 1)
insert into DataSource ([Source], Created, CreatedBy) Values ('EDI', getdate(), 1)
insert into DataSource ([Source], Created, CreatedBy) Values ('Manual', getdate(), 1) 
insert into DataSource ([Source], Created, CreatedBy) Values ('Offer Engine', getdate(), 1) 

---------------------------------------------------------------------------------------------
-- Create AccountIcap table
---------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[AccountIcap](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[DataSourceID] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ICapValue] [decimal](18, 4) NULL,
	[Created] [datetime] NOT NULL,	
	[UserID] int NOT NULL,
	[Modified] [datetime] NULL,
 CONSTRAINT [PK_AccountIcap] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AccountIcap]  WITH CHECK ADD  CONSTRAINT [FK_AccountIcap_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([AccountID])
GO

ALTER TABLE [dbo].[AccountIcap] CHECK CONSTRAINT [FK_AccountIcap_Account]
GO

ALTER TABLE [dbo].[AccountIcap]  WITH CHECK ADD  CONSTRAINT [FK_AccountIcap_DataSource] FOREIGN KEY([DataSourceID])
REFERENCES [dbo].[DataSource] ([ID])
GO

ALTER TABLE [dbo].[AccountIcap] CHECK CONSTRAINT [FK_AccountIcap_DataSource]
GO

ALTER TABLE [dbo].[AccountIcap] ADD  CONSTRAINT [DF_AccountIcap_Created]  DEFAULT (getdate()) FOR [Created]
GO

---------------------------------------------------------------------------------------------
-- Create AccountTcap table
---------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[AccountTcap](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[DataSourceID] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[TcapValue] [decimal](18, 4) NULL,
	[Created] [datetime] NOT NULL,	
	[UserID] int NOT NULL,
	[Modified] [datetime] NULL,
 CONSTRAINT [PK_AccountTcap] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AccountTcap]  WITH CHECK ADD  CONSTRAINT [FK_AccountTcap_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([AccountID])
GO

ALTER TABLE [dbo].[AccountTcap] CHECK CONSTRAINT [FK_AccountTcap_Account]
GO

ALTER TABLE [dbo].[AccountTcap]  WITH CHECK ADD  CONSTRAINT [FK_AccountTcap_DataSource] FOREIGN KEY([DataSourceID])
REFERENCES [dbo].[DataSource] ([ID])
GO

ALTER TABLE [dbo].[AccountTcap] CHECK CONSTRAINT [FK_AccountTcap_DataSource]
GO

ALTER TABLE [dbo].[AccountTcap] ADD  CONSTRAINT [DF_AccountTcap_Created]  DEFAULT (getdate()) FOR [Created]
GO


-----------------------------------------------------------------------------------------------------------------------------------------------
---- DeliveryPointType table
-----------------------------------------------------------------------------------------------------------------------------------------------
--USE [LibertyPower]
--GO

--/****** Object:  Table [dbo].[DeliveryPointType]    Script Date: 03/13/2013 15:03:10 ******/
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryPointType]') AND type in (N'U'))
--DROP TABLE [dbo].[DeliveryPointType]
--GO

--CREATE TABLE [dbo].[DeliveryPointType](
--	[ID] [int] IDENTITY(1,1) NOT NULL,
--	[Description] [varchar](100) NOT NULL,
--	[DateCreated] [datetime] NOT NULL,
--	[CreatedBy] [int] NOT NULL,
--	[DateModified] [datetime] NULL,
--	[ModifiedBy] [int] NULL,
-- CONSTRAINT [PK_DeliveryPointType] PRIMARY KEY CLUSTERED 
--(
--	[ID] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--/****** Object:  Table [dbo].[DeliveryPointInternalReference]    Script Date: 03/13/2013 15:03:48 ******/
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryPointInternalReference]') AND type in (N'U'))
--	DROP TABLE [dbo].[DeliveryPointInternalReference]
--GO

--CREATE TABLE [dbo].[DeliveryPointInternalReference](
--	[ID] [int] IDENTITY(1,1) NOT NULL,
--	[DeliveryPointTypeID] [int] NOT NULL,
--	[IsoID] int not null,
--	[DeliveryPointInternalRef] [varchar](20) NOT NULL,
--	[DateCreated] [datetime] NOT NULL,
--	[CreatedBy] [int] NOT NULL,
--	[DateModified] [datetime] NULL,
--	[ModifiedBy] [int] NULL,
-- CONSTRAINT [PK_DeliveryPointInternalReference] PRIMARY KEY CLUSTERED 
--(
--	[ID] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--SET ANSI_PADDING OFF
--GO

--ALTER TABLE [dbo].[DeliveryPointInternalReference]  WITH CHECK ADD  CONSTRAINT [FK_DeliveryPointInternalReference_DeliveryPointType] FOREIGN KEY([DeliveryPointTypeID])
--REFERENCES [dbo].[DeliveryPointType] ([ID])
--GO

--ALTER TABLE [dbo].[DeliveryPointInternalReference] CHECK CONSTRAINT [FK_DeliveryPointInternalReference_DeliveryPointType]
--GO

--ALTER TABLE [dbo].[DeliveryPointInternalReference]  WITH CHECK ADD  CONSTRAINT [FK_DeliveryPointInternalReference_WholesaleMarket] FOREIGN KEY([IsoID])
--REFERENCES [dbo].[WholesaleMarket] ([ID])
--GO

--ALTER TABLE [dbo].[DeliveryPointInternalReference] CHECK CONSTRAINT [FK_DeliveryPointInternalReference_WholesaleMarket]
--GO


--/****** Object:  Table [dbo].[IsoDeliveryPointMapping]    Script Date: 03/13/2013 15:07:55 ******/
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsoDeliveryPointMapping]') AND type in (N'U'))
--	DROP TABLE [dbo].[IsoDeliveryPointMapping]
--GO

--CREATE TABLE [dbo].[IsoDeliveryPointMapping](
--	[ID] [int] IDENTITY(1,1) NOT NULL,
--	[IsoID] [int] NULL,
--	[DeliveryPointIntRefID] [int] NULL,
--	[IsoValue] [varchar](50) NULL,
--	[DateCreated] [datetime] NOT NULL,
--	[CreatedBy] [int] NOT NULL,
--	[DateModified] [datetime] NULL,
--	[ModifiedBy] [int] NULL,
-- CONSTRAINT [PK_IsoDeliveryPointMapping] PRIMARY KEY CLUSTERED 
--(
--	[ID] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--SET ANSI_PADDING OFF
--GO

--ALTER TABLE [dbo].[IsoDeliveryPointMapping]  WITH CHECK ADD  CONSTRAINT [FK_IsoDeliveryPointMapping_DeliveryPointInternalReference] FOREIGN KEY([DeliveryPointIntRefID])
--REFERENCES [dbo].[DeliveryPointInternalReference] ([ID])
--GO

--ALTER TABLE [dbo].[IsoDeliveryPointMapping] CHECK CONSTRAINT [FK_IsoDeliveryPointMapping_DeliveryPointInternalReference]
--GO

--ALTER TABLE [dbo].[IsoDeliveryPointMapping]  WITH CHECK ADD  CONSTRAINT [FK_IsoDeliveryPointMapping_WholesaleMarket] FOREIGN KEY([IsoID])
--REFERENCES [dbo].[WholesaleMarket] ([ID])
--GO

--ALTER TABLE [dbo].[IsoDeliveryPointMapping] CHECK CONSTRAINT [FK_IsoDeliveryPointMapping_WholesaleMarket]
--GO


--ALTER TABLE dbo.AccountContract ADD DeliveryPointIntRefID int null

--ALTER TABLE [dbo].[AccountContract]  WITH CHECK ADD  CONSTRAINT [FK_AccountContract_DeliveryPointInternalReference] FOREIGN KEY([DeliveryPointIntRefID])
--REFERENCES [dbo].[DeliveryPointInternalReference] ([ID])
--GO

--ALTER TABLE [dbo].[AccountContract] CHECK CONSTRAINT [FK_AccountContract_DeliveryPointInternalReference]
--GO

--SET ANSI_PADDING OFF
--GO
--/************************************************************************************************************************************************************/
---- END OF LIBERTYPOWER DATABASE OBJECTS
--/************************************************************************************************************************************************************/

USE [Lp_Mtm]
GO

-----------------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  Table [dbo].[TimeSeries]    Script Date: 03/05/2013 15:56:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimeSeries]') AND type in (N'U'))
DROP TABLE [dbo].[TimeSeries]
GO

/****** Object:  Table [dbo].[TimeSeries]    Script Date: 03/05/2013 15:56:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TimeSeries](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TimeSeriesDescription] [varchar](200) NULL,
 CONSTRAINT [PK_TimeSeries] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-----------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[SourceType]    Script Date: 03/05/2013 15:59:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SourceType]') AND type in (N'U'))
DROP TABLE [dbo].[SourceType]
GO

CREATE TABLE [dbo].[SourceType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceTypeDesc] [varchar](200) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_SourceType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-----------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[ValueType]    Script Date: 03/05/2013 16:00:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ValueType]') AND type in (N'U'))
DROP TABLE [dbo].[ValueType]
GO

CREATE TABLE [dbo].[ValueType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ValueDescription] [varchar](200) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ValueType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-----------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[InputType]    Script Date: 03/05/2013 16:01:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InputType]') AND type in (N'U'))
DROP TABLE [dbo].[InputType]
GO

CREATE TABLE [dbo].[InputType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TypeDescription] [varchar](200) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_InputType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-----------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[ForecastFunction]    Script Date: 03/05/2013 16:02:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ForecastFunction]') AND type in (N'U'))
DROP TABLE [dbo].[ForecastFunction]
GO

CREATE TABLE [dbo].[ForecastFunction](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FunctionDescription] [varchar](200) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ForecastFunction] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-----------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[ComponentCategory]    Script Date: 03/05/2013 16:03:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ComponentCategory]') AND type in (N'U'))
DROP TABLE [dbo].[ComponentCategory]
GO

CREATE TABLE [dbo].[ComponentCategory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompCatCode] [varchar](20) NOT NULL,
	[CompCatDescription] [varchar](200) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_ComponentCategory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-----------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[Volume]    Script Date: 03/05/2013 16:04:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Volume]') AND type in (N'U'))
DROP TABLE [dbo].[Volume]
GO

CREATE TABLE [dbo].[Volume](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VolumeCode] [varchar](20) NOT NULL,
	[VolumeDescription] [varchar](200) NOT NULL,
	[Formula] [varchar](300) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Volume] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-----------------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PricingComponent_ComponentCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[PricingComponent]'))
ALTER TABLE [dbo].[PricingComponent] DROP CONSTRAINT [FK_PricingComponent_ComponentCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PricingComponent_CurveDefinition]') AND parent_object_id = OBJECT_ID(N'[dbo].[PricingComponent]'))
ALTER TABLE [dbo].[PricingComponent] DROP CONSTRAINT [FK_PricingComponent_CurveDefinition]
GO

/****** Object:  Table [dbo].[PricingComponent]    Script Date: 03/05/2013 16:10:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PricingComponent]') AND type in (N'U'))
DROP TABLE [dbo].[PricingComponent]
GO

CREATE TABLE [dbo].[PricingComponent](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompCode] [varchar](20) NOT NULL,
	[CompDescription] [varchar](200) NOT NULL,
	[CompCategoryID] [int] NOT NULL,
	[PricingCurveID] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PricingComponent] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PricingComponent]  WITH CHECK ADD  CONSTRAINT [FK_PricingComponent_ComponentCategory] FOREIGN KEY([CompCategoryID])
REFERENCES [dbo].[ComponentCategory] ([ID])
GO

ALTER TABLE [dbo].[PricingComponent] CHECK CONSTRAINT [FK_PricingComponent_ComponentCategory]
GO

ALTER TABLE [dbo].[PricingComponent]  WITH CHECK ADD  CONSTRAINT [FK_PricingComponent_CurveDefinition] FOREIGN KEY([PricingCurveID])
REFERENCES [dbo].[CurveDefinition] ([ID])
GO

ALTER TABLE [dbo].[PricingComponent] CHECK CONSTRAINT [FK_PricingComponent_CurveDefinition]
GO
-----------------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_IsoMarketComponent_PricingComponent]') AND parent_object_id = OBJECT_ID(N'[dbo].[IsoMarketComponent]'))
ALTER TABLE [dbo].[IsoMarketComponent] DROP CONSTRAINT [FK_IsoMarketComponent_PricingComponent]
GO

/****** Object:  Table [dbo].[IsoMarketComponent]    Script Date: 03/05/2013 16:12:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsoMarketComponent]') AND type in (N'U'))
DROP TABLE [dbo].[IsoMarketComponent]
GO

CREATE TABLE [dbo].[IsoMarketComponent](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PricingCompID] [int] NOT NULL,
	[IsoID] [int] NULL,
	[MarketID] [int] NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_IsoMarketComponent] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[IsoMarketComponent]  WITH CHECK ADD  CONSTRAINT [FK_IsoMarketComponent_PricingComponent] FOREIGN KEY([PricingCompID])
REFERENCES [dbo].[PricingComponent] ([ID])
GO

ALTER TABLE [dbo].[IsoMarketComponent] CHECK CONSTRAINT [FK_IsoMarketComponent_PricingComponent]
GO
-----------------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ComponentVolume_PricingComponent]') AND parent_object_id = OBJECT_ID(N'[dbo].[ComponentVolume]'))
ALTER TABLE [dbo].[ComponentVolume] DROP CONSTRAINT [FK_ComponentVolume_PricingComponent]
GO

/****** Object:  Table [dbo].[ComponentVolume]    Script Date: 03/05/2013 16:13:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ComponentVolume]') AND type in (N'U'))
DROP TABLE [dbo].[ComponentVolume]
GO

CREATE TABLE [dbo].[ComponentVolume](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PricingCompID] [int] NOT NULL,
	[IsoID] [int] NULL,
	[MarketID] [int] NULL,
	[DeliveryPointID] [int] NULL,
	[VolumeID] [int] NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ComponentVolume] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ComponentVolume]  WITH CHECK ADD  CONSTRAINT [FK_ComponentVolume_PricingComponent] FOREIGN KEY([PricingCompID])
REFERENCES [dbo].[PricingComponent] ([ID])
GO

ALTER TABLE [dbo].[ComponentVolume] CHECK CONSTRAINT [FK_ComponentVolume_PricingComponent]
GO
-----------------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inputs_CurveDefinition]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inputs]'))
ALTER TABLE [dbo].[Inputs] DROP CONSTRAINT [FK_Inputs_CurveDefinition]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inputs_InputType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inputs]'))
ALTER TABLE [dbo].[Inputs] DROP CONSTRAINT [FK_Inputs_InputType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inputs_ValueType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inputs]'))
ALTER TABLE [dbo].[Inputs] DROP CONSTRAINT [FK_Inputs_ValueType]
GO

/****** Object:  Table [dbo].[Inputs]    Script Date: 03/05/2013 16:14:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Inputs]') AND type in (N'U'))
DROP TABLE [dbo].[Inputs]
GO

CREATE TABLE [dbo].[Inputs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[InputCode] [varchar](50) NOT NULL,
	[InputDescription] [varchar](200) NOT NULL,
	[InputTypeID] [int] NOT NULL,
	[ValueTypeID] [int] NOT NULL,
	[CurveID] [int] NULL,
	[Guid] [uniqueidentifier] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Inputs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Inputs]  WITH CHECK ADD  CONSTRAINT [FK_Inputs_CurveDefinition] FOREIGN KEY([CurveID])
REFERENCES [dbo].[CurveDefinition] ([ID])
GO

ALTER TABLE [dbo].[Inputs] CHECK CONSTRAINT [FK_Inputs_CurveDefinition]
GO

ALTER TABLE [dbo].[Inputs]  WITH CHECK ADD  CONSTRAINT [FK_Inputs_InputType] FOREIGN KEY([InputTypeID])
REFERENCES [dbo].[InputType] ([ID])
GO

ALTER TABLE [dbo].[Inputs] CHECK CONSTRAINT [FK_Inputs_InputType]
GO

ALTER TABLE [dbo].[Inputs]  WITH CHECK ADD  CONSTRAINT [FK_Inputs_ValueType] FOREIGN KEY([ValueTypeID])
REFERENCES [dbo].[ValueType] ([ID])
GO

ALTER TABLE [dbo].[Inputs] CHECK CONSTRAINT [FK_Inputs_ValueType]
GO
-----------------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_FactorInputs_Inputs]') AND parent_object_id = OBJECT_ID(N'[dbo].[FactorInputs]'))
ALTER TABLE [dbo].[FactorInputs] DROP CONSTRAINT [FK_FactorInputs_Inputs]
GO

/****** Object:  Table [dbo].[FactorInputs]    Script Date: 03/05/2013 16:16:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FactorInputs]') AND type in (N'U'))
DROP TABLE [dbo].[FactorInputs]
GO

CREATE TABLE [dbo].[FactorInputs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[InputID] [int] NOT NULL,
	[IsoID] [int] NULL,
	[MarketID] [int] NULL,
	[UtilityID] [int] NULL,
	[DeliveryPointID] [int] NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Value] [decimal](10, 2) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_FactorInputs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[FactorInputs]  WITH CHECK ADD  CONSTRAINT [FK_FactorInputs_Inputs] FOREIGN KEY([InputID])
REFERENCES [dbo].[Inputs] ([ID])
GO

ALTER TABLE [dbo].[FactorInputs] CHECK CONSTRAINT [FK_FactorInputs_Inputs]
GO
-----------------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CurveDefinition_ForecastFunction]') AND parent_object_id = OBJECT_ID(N'[dbo].[CurveDefinition]'))
ALTER TABLE [dbo].[CurveDefinition] DROP CONSTRAINT [FK_CurveDefinition_ForecastFunction]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CurveDefinition_SourceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CurveDefinition]'))
ALTER TABLE [dbo].[CurveDefinition] DROP CONSTRAINT [FK_CurveDefinition_SourceType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CurveDefinition_TimeSeries]') AND parent_object_id = OBJECT_ID(N'[dbo].[CurveDefinition]'))
ALTER TABLE [dbo].[CurveDefinition] DROP CONSTRAINT [FK_CurveDefinition_TimeSeries]
GO

/****** Object:  Table [dbo].[CurveDefinition]    Script Date: 03/05/2013 16:17:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CurveDefinition]') AND type in (N'U'))
DROP TABLE [dbo].[CurveDefinition]
GO

CREATE TABLE [dbo].[CurveDefinition](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CurveName] [varchar](200) NOT NULL,
	[SourceTypeID] [int] NOT NULL,
	[SourceLocation] [varchar](200) NOT NULL,
	[TimeSeriesID] [int] NOT NULL,
	[TSConvertToID] [int] NULL,
	[ForecastRequired] [bit] NOT NULL,
	[ForecastFunctionID] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_CurveDefinition] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CurveDefinition]  WITH CHECK ADD  CONSTRAINT [FK_CurveDefinition_ForecastFunction] FOREIGN KEY([ForecastFunctionID])
REFERENCES [dbo].[ForecastFunction] ([ID])
GO

ALTER TABLE [dbo].[CurveDefinition] CHECK CONSTRAINT [FK_CurveDefinition_ForecastFunction]
GO

ALTER TABLE [dbo].[CurveDefinition]  WITH CHECK ADD  CONSTRAINT [FK_CurveDefinition_SourceType] FOREIGN KEY([SourceTypeID])
REFERENCES [dbo].[SourceType] ([ID])
GO

ALTER TABLE [dbo].[CurveDefinition] CHECK CONSTRAINT [FK_CurveDefinition_SourceType]
GO

ALTER TABLE [dbo].[CurveDefinition]  WITH CHECK ADD  CONSTRAINT [FK_CurveDefinition_TimeSeries] FOREIGN KEY([TimeSeriesID])
REFERENCES [dbo].[TimeSeries] ([ID])
GO

ALTER TABLE [dbo].[CurveDefinition] CHECK CONSTRAINT [FK_CurveDefinition_TimeSeries]
GO

-----------------------------------------------------------------------------------------------------------------------------------------------
SET ANSI_PADDING OFF
GO
-----------------------------------------------------------------------------------------------------------------------------------------------



