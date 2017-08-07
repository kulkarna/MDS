
USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExternalEntityValue_ExternalEntity]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExternalEntityValue]'))
ALTER TABLE [dbo].[ExternalEntityValue] DROP CONSTRAINT [FK_ExternalEntityValue_ExternalEntity]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExternalEntityValue_PropertyValue]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExternalEntityValue]'))
ALTER TABLE [dbo].[ExternalEntityValue] DROP CONSTRAINT [FK_ExternalEntityValue_PropertyValue]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExternalEntityValue_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExternalEntityValue] DROP CONSTRAINT [DF_ExternalEntityValue_DateCreated]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__ExternalE__Prope__71496EDA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExternalEntityValue] DROP CONSTRAINT [DF__ExternalE__Prope__71496EDA]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ExternalEntityValue]    Script Date: 10/02/2013 12:37:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExternalEntityValue]') AND type in (N'U'))
DROP TABLE [dbo].[ExternalEntityValue]
GO




USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyValue_Property]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyValue]'))
ALTER TABLE [dbo].[PropertyValue] DROP CONSTRAINT [FK_PropertyValue_Property]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyValue_PropertyInternalRef]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyValue]'))
ALTER TABLE [dbo].[PropertyValue] DROP CONSTRAINT [FK_PropertyValue_PropertyInternalRef]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyValue_PropertyType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyValue]'))
ALTER TABLE [dbo].[PropertyValue] DROP CONSTRAINT [FK_PropertyValue_PropertyType]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyValue_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PropertyValue] DROP CONSTRAINT [DF_PropertyValue_DateCreated]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PropertyValue]    Script Date: 10/02/2013 12:37:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyValue]') AND type in (N'U'))
DROP TABLE [dbo].[PropertyValue]
GO




USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyTypeEntityTypeMap_ExtEntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyTypeEntityTypeMap]'))
ALTER TABLE [dbo].[PropertyTypeEntityTypeMap] DROP CONSTRAINT [FK_PropertyTypeEntityTypeMap_ExtEntityType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyTypeEntityTypeMap_Property]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyTypeEntityTypeMap]'))
ALTER TABLE [dbo].[PropertyTypeEntityTypeMap] DROP CONSTRAINT [FK_PropertyTypeEntityTypeMap_Property]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyTypeEntityTypeMap_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PropertyTypeEntityTypeMap] DROP CONSTRAINT [DF_PropertyTypeEntityTypeMap_DateCreated]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PropertyTypeEntityTypeMap]    Script Date: 10/02/2013 12:36:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyTypeEntityTypeMap]') AND type in (N'U'))
DROP TABLE [dbo].[PropertyTypeEntityTypeMap]
GO







USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExternalEntityType_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExternalEntityType] DROP CONSTRAINT [DF_ExternalEntityType_DateCreated]
END

GO


USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ThirdPartyApplications_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ThirdPartyApplications] DROP CONSTRAINT [DF_ThirdPartyApplications_DateCreated]
END

GO


USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyInternalRef_Property]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyInternalRef]'))
ALTER TABLE [dbo].[PropertyInternalRef] DROP CONSTRAINT [FK_PropertyInternalRef_Property]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyInternalRef_PropertyType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyInternalRef]'))
ALTER TABLE [dbo].[PropertyInternalRef] DROP CONSTRAINT [FK_PropertyInternalRef_PropertyType]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyInternalRef_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PropertyInternalRef] DROP CONSTRAINT [DF_PropertyInternalRef_DateCreated]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PropertyInternalRef]    Script Date: 10/02/2013 12:38:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyInternalRef]') AND type in (N'U'))
DROP TABLE [dbo].[PropertyInternalRef]
GO




USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExternalEntityPropertyRule_ExternalEntity]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExternalEntityPropertyRule]'))
ALTER TABLE [dbo].[ExternalEntityPropertyRule] DROP CONSTRAINT [FK_ExternalEntityPropertyRule_ExternalEntity]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExternalEntityPropertyRule_PropertyRule]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExternalEntityPropertyRule]'))
ALTER TABLE [dbo].[ExternalEntityPropertyRule] DROP CONSTRAINT [FK_ExternalEntityPropertyRule_PropertyRule]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__ExternalE__Inact__7E6E5FCE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExternalEntityPropertyRule] DROP CONSTRAINT [DF__ExternalE__Inact__7E6E5FCE]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ExternalEntityPropertyRule]    Script Date: 10/09/2013 10:32:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExternalEntityPropertyRule]') AND type in (N'U'))
DROP TABLE [dbo].[ExternalEntityPropertyRule]
GO



USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExternalEntity_ExternalEntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExternalEntity]'))
ALTER TABLE [dbo].[ExternalEntity] DROP CONSTRAINT [FK_ExternalEntity_ExternalEntityType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExternalEntity_ThirdPartyApplications]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExternalEntity]'))
ALTER TABLE [dbo].[ExternalEntity] DROP CONSTRAINT [FK_ExternalEntity_ThirdPartyApplications]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExternalEntity_Utility]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExternalEntity]'))
ALTER TABLE [dbo].[ExternalEntity] DROP CONSTRAINT [FK_ExternalEntity_Utility]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExternalEntity_WholesaleMarket]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExternalEntity]'))
ALTER TABLE [dbo].[ExternalEntity] DROP CONSTRAINT [FK_ExternalEntity_WholesaleMarket]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExternalEntity_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExternalEntity] DROP CONSTRAINT [DF_ExternalEntity_DateCreated]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__ExternalE__Entit__6D78DDF6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExternalEntity] DROP CONSTRAINT [DF__ExternalE__Entit__6D78DDF6]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__ExternalE__Entit__6E6D022F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExternalEntity] DROP CONSTRAINT [DF__ExternalE__Entit__6E6D022F]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ExternalEntity]    Script Date: 10/02/2013 12:37:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExternalEntity]') AND type in (N'U'))
DROP TABLE [dbo].[ExternalEntity]
GO



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

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PropertyRule]    Script Date: 10/09/2013 10:32:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyRule]') AND type in (N'U'))
DROP TABLE [dbo].[PropertyRule]
GO



USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PropertyType_Property]') AND parent_object_id = OBJECT_ID(N'[dbo].[PropertyType]'))
ALTER TABLE [dbo].[PropertyType] DROP CONSTRAINT [FK_PropertyType_Property]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyType_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PropertyType] DROP CONSTRAINT [DF_PropertyType_DateCreated]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[PropertyType]    Script Date: 10/02/2013 12:38:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyType]') AND type in (N'U'))
DROP TABLE [dbo].[PropertyType]
GO



USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Property_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PropertyName] DROP CONSTRAINT [DF_Property_DateCreated]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[Property]    Script Date: 10/02/2013 12:35:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyName]') AND type in (N'U'))
DROP TABLE [dbo].[PropertyName]
GO


USE [LibertyPower]
GO

/****** Object:  Table [dbo].[UtilityStratumRange]    Script Date: 10/16/2013 13:31:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UtilityStratumRange]') AND type in (N'U'))
DROP TABLE [dbo].[UtilityStratumRange]
GO




USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ExternalEntityType]    Script Date: 10/02/2013 12:39:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExternalEntityType]') AND type in (N'U'))
DROP TABLE [dbo].[ExternalEntityType]
GO


USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ThirdPartyApplications]    Script Date: 10/02/2013 12:39:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ThirdPartyApplications]') AND type in (N'U'))
DROP TABLE [dbo].[ThirdPartyApplications]
GO







