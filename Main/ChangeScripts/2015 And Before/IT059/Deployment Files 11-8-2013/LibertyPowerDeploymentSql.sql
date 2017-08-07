USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountPropertyHistory]    Script Date: 08/09/2013 21:04:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyHistory]') AND type in (N'U'))
DROP TABLE [dbo].[AccountPropertyHistory]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountPropertyHistory]    Script Date: 08/09/2013 21:04:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AccountPropertyHistory](
	[AccountPropertyHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[UtilityID] [varchar](80) NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[FieldName] [varchar](60) NOT NULL,
	[FieldValue] [varchar](200) NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[FieldSource] [varchar](60) NOT NULL,
	[CreatedBy] [varchar](256) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[LockStatus] [varchar](60) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_DeterminantHistory_2] PRIMARY KEY CLUSTERED 
(
	[AccountPropertyHistoryID] ASC
)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =PAGE ) ON [PRIMARY]
) ON [PRIMARY]

GO

--SET ANSI_PADDING OFF
GO


USE [Libertypower]
/****** Object:  Index [idx__temp1]    Script Date: 08/09/2013 21:04:54 ******/
CREATE NONCLUSTERED INDEX [idx__temp1] ON [dbo].[AccountPropertyHistory] 
(
	[UtilityID] ASC,
	[FieldName] ASC
)
INCLUDE ( [Active],
[AccountNumber],
[FieldValue]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 50, DATA_COMPRESSION =PAGE ) ON [PRIMARY]
GO


USE [Libertypower]
/****** Object:  Index [IDX_AccountPropertyHistoryTemp02]    Script Date: 08/09/2013 21:04:54 ******/
CREATE NONCLUSTERED INDEX [IDX_AccountPropertyHistoryTemp02] ON [dbo].[AccountPropertyHistory] 
(
	[UtilityID] ASC,
	[AccountNumber] ASC,
	[Active] ASC,
	[FieldName] ASC,
	[EffectiveDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =PAGE ) ON [PRIMARY]
GO

/*** overriding check in so we get this file again. Putting the phoenix related indexes in a separate file ************/

USE [Libertypower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccountPropertyLockHistory_AccountPropertyHistory]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccountPropertyLockHistory]'))
ALTER TABLE [dbo].[AccountPropertyLockHistory] DROP CONSTRAINT [FK_AccountPropertyLockHistory_AccountPropertyHistory]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountPropertyLockHistory]    Script Date: 08/09/2013 21:06:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyLockHistory]') AND type in (N'U'))
DROP TABLE [dbo].[AccountPropertyLockHistory]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[AccountPropertyLockHistory]    Script Date: 08/09/2013 21:06:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AccountPropertyLockHistory](
	[AccountPropertyLockHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountPropertyHistoryID] [bigint] NOT NULL,
	[LockStatus] [varchar](60) NOT NULL,
	[CreatedBy] [varchar](256) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_AccountPropertyLockHistory] PRIMARY KEY CLUSTERED 
(
	[AccountPropertyLockHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION =PAGE ) ON [PRIMARY]
) ON [PRIMARY]

GO

--SET ANSI_PADDING OFF
GO


USE [Libertypower]
/****** Object:  Index [idxLockStatus_AccountPropertyLockHistory]    Script Date: 08/09/2013 21:06:54 ******/
CREATE NONCLUSTERED INDEX [idxLockStatus_AccountPropertyLockHistory] ON [dbo].[AccountPropertyLockHistory] 
(
	[AccountPropertyHistoryID] ASC
)
INCLUDE ( [LockStatus],
[CreatedBy],
[DateCreated]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,  DATA_COMPRESSION =PAGE ) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AccountPropertyLockHistory]  WITH CHECK ADD  CONSTRAINT [FK_AccountPropertyLockHistory_AccountPropertyHistory] FOREIGN KEY([AccountPropertyHistoryID])
REFERENCES [dbo].[AccountPropertyHistory] ([AccountPropertyHistoryID])
GO

ALTER TABLE [dbo].[AccountPropertyLockHistory] CHECK CONSTRAINT [FK_AccountPropertyLockHistory_AccountPropertyHistory]
GO


/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[UtilityClassMapping]

     Make VM3LPCNOCSQL1.Libertypower Equal (local).LibertyPower

   AUTHOR:	[Insert Author Name]

   DATE:	11/27/2012 4:11:50 PM

   LEGAL:	2012[Insert Company Name]

   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
--SET ANSI_PADDING ON
GO
USE [Libertypower]
GO

BEGIN TRAN
GO

-- Add Column RuleType to [dbo].[UtilityClassMapping]
Print 'Add Column RuleType to [dbo].[UtilityClassMapping]'
GO
ALTER TABLE [dbo].[UtilityClassMapping]
	ADD [RuleType] [int] NULL
	CONSTRAINT [DF_UtilityClassMapping_MappingRuleType] DEFAULT ((0)) WITH VALUES

ALTER TABLE [dbo].[UtilityClassMapping]
	ADD [TCap] [decimal](20, 5) NULL

ALTER TABLE [dbo].[UtilityClassMapping]
	ADD [ICap] [decimal](20, 5) NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[UtilityZoneMapping]

     Make VM3LPCNOCSQL1.Libertypower Equal (local).LibertyPower

   AUTHOR:	[Insert Author Name]

   DATE:	11/27/2012 4:13:32 PM

   LEGAL:	2012[Insert Company Name]

   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
--SET ANSI_PADDING ON
GO
USE [Libertypower]
GO

BEGIN TRAN
GO

-- Add Column RuleType to [dbo].[UtilityZoneMapping]
Print 'Add Column RuleType to [dbo].[UtilityZoneMapping]'
GO
ALTER TABLE [dbo].[UtilityZoneMapping]
	ADD [RuleType] [int] NULL
	CONSTRAINT [DF_UtilityZoneMapping_MappingRuleType] DEFAULT ((0)) WITH VALUES
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

USE LibertyPower
GO
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
--SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

GO
IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE  CONSTRAINT_TYPE = 'PRIMARY KEY'
    AND TABLE_NAME = 'VRE_ServiceClassMapping' 
    AND TABLE_SCHEMA ='dbo' )
ALTER TABLE dbo.VRE_ServiceClassMapping
	DROP CONSTRAINT PK_VRE_ServiceClassMapping_1
GO
ALTER TABLE dbo.VRE_ServiceClassMapping ADD CONSTRAINT
	PK_VRE_ServiceClassMapping_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.VRE_ServiceClassMapping SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
USE [Libertypower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeterminantAlias_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeterminantAlias] DROP CONSTRAINT [DF_DeterminantAlias_DateCreated]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeterminantAlias_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeterminantAlias] DROP CONSTRAINT [DF_DeterminantAlias_Active]
END

GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantAlias]    Script Date: 10/15/2013 09:54:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeterminantAlias]') AND type in (N'U'))
DROP TABLE [dbo].[DeterminantAlias]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantAlias]    Script Date: 10/15/2013 09:54:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DeterminantAlias](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityCode] [varchar](50) NOT NULL,
	[FieldName] [varchar](60) NOT NULL,
	[OriginalValue] [varchar](60) NOT NULL,
	[AliasValue] [varchar](60) NOT NULL,
	[UserIdentity] [varchar](256) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO

--SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[DeterminantAlias] ADD  CONSTRAINT [DF_DeterminantAlias_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[DeterminantAlias] ADD  CONSTRAINT [DF_DeterminantAlias_Active]  DEFAULT ((1)) FOR [Active]
GO


USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantFieldMapResultants]    Script Date: 10/15/2013 10:14:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeterminantFieldMapResultants]') AND type in (N'U'))
DROP TABLE [dbo].[DeterminantFieldMapResultants]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantFieldMapResultants]    Script Date: 10/15/2013 10:14:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DeterminantFieldMapResultants](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FieldMapID] [int] NOT NULL,
	[ResultantFieldName] [varchar](60) NOT NULL,
	[ResultantFieldValue] [varchar](200) NOT NULL,
 CONSTRAINT [PK_DeterminantFieldMapResultants_1] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--SET ANSI_PADDING OFF
GO


USE [Libertypower]
/****** Object:  Index [CIdx_DeterminantFieldMapResultants]    Script Date: 10/15/2013 10:14:32 ******/
CREATE UNIQUE CLUSTERED INDEX [CIdx_DeterminantFieldMapResultants] ON [dbo].[DeterminantFieldMapResultants] 
(
	[FieldMapID] ASC,
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


USE [Libertypower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeterminantFieldMaps_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeterminantFieldMaps] DROP CONSTRAINT [DF_DeterminantFieldMaps_DateCreated]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeterminantFieldMaps_CreatedBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeterminantFieldMaps] DROP CONSTRAINT [DF_DeterminantFieldMaps_CreatedBy]
END

GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantFieldMaps]    Script Date: 10/15/2013 10:12:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeterminantFieldMaps]') AND type in (N'U'))
DROP TABLE [dbo].[DeterminantFieldMaps]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantFieldMaps]    Script Date: 10/15/2013 10:12:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DeterminantFieldMaps](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityCode] [varchar](80) NOT NULL,
	[DeterminantFieldName] [varchar](60) NOT NULL,
	[DeterminantValue] [varchar](200) NOT NULL,
	[MappingRuleType] [varchar](60) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[CreatedBy] [varchar](256) NOT NULL,
 CONSTRAINT [PK_DeterminantFieldMaps] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--SET ANSI_PADDING OFF
GO


USE [Libertypower]
/****** Object:  Index [idx__DateCreated_I]    Script Date: 10/15/2013 10:12:36 ******/
CREATE NONCLUSTERED INDEX [idx__DateCreated_I] ON [dbo].[DeterminantFieldMaps] 
(
	[DateCreated] ASC
)
INCLUDE ( [DeterminantFieldName],
[DeterminantValue],
[ID],
[UtilityCode]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DeterminantFieldMaps] ADD  CONSTRAINT [DF_DeterminantFieldMaps_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[DeterminantFieldMaps] ADD  CONSTRAINT [DF_DeterminantFieldMaps_CreatedBy]  DEFAULT ('unknown') FOR [CreatedBy]
GO


USE LibertyPower 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeterminantHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeterminantHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UtilityID] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccountNumber] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FieldName] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FieldValue] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[FieldSource] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserIdentity] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[LockStatus] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
GO
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [DF_DeterminantHistory_EffectiveDate]  DEFAULT (getdate()) FOR [EffectiveDate]
GO
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [DF_DeterminantHistory_UserIdentity]  DEFAULT ('Unknown') FOR [UserIdentity]
GO
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [DF_DeterminantHistory_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [DF_DeterminantHistory_Active]  DEFAULT ((1)) FOR [Active]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of field being recorded; see' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'FieldName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date a record value is used as cuurent value; by default this equals the DateCreated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'EffectiveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Source of the record; see enum FieldUpdateSources for possible values' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'FieldSource'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date a record was written' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'DateCreated'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Can be Locked, Unlocked, or NULL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'LockStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Set this bit to 1 to remove old records from consideration for performance issues' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'Active'
GO
Create clustered index CIdx_DeterminantHistory on DeterminantHistory ( UtilityID, AccountNumber, FieldName, EffectiveDate ) 


GO

/****** Object:  Index [PK_DeterminantHistory_1]    Script Date: 05/01/2013 10:48:18 ******/
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [PK_DeterminantHistory_1] PRIMARY KEY  
(
      [ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
USE [Libertypower]
GO

/****** Object:  Table [dbo].[TmpAccountPropertyHistory]    Script Date: 08/22/2013 16:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TmpAccountPropertyHistory]') AND type in (N'U'))
DROP TABLE [dbo].[TmpAccountPropertyHistory]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[TmpAccountPropertyHistory]    Script Date: 08/22/2013 16:21:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TmpAccountPropertyHistory](
	[Utility] [varchar](80) NULL,
	[AccountNumber] [varchar](50) NULL,
	[FieldName] [varchar](60) NULL,
	[FieldValue] [varchar](200) NULL,
	[EffectiveDate] [datetime] NULL
) ON [PRIMARY]

GO

--SET ANSI_PADDING OFF
GO


USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyRecord]    Script Date: 08/22/2013 13:22:20 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'AccountPropertyRecord' AND ss.name = N'dbo')
DROP TYPE [dbo].[AccountPropertyRecord]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyRecord]    Script Date: 08/22/2013 13:22:20 ******/
CREATE TYPE [dbo].[AccountPropertyRecord] AS TABLE(
	[Utility] [varchar](80) NULL,
	[AccountNumber] [varchar](50) NULL,
	[FieldName] [varchar](60) NULL,
	[FieldValue] [varchar](200) NULL,
	[EffectiveDate] [datetime] NULL
)
GO


USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[MappingRecord]    Script Date: 07/27/2013 20:18:10 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'MappingRecord' AND ss.name = N'dbo')
DROP TYPE [dbo].[MappingRecord]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[MappingRecord]    Script Date: 07/27/2013 20:18:10 ******/
CREATE TYPE [dbo].[MappingRecord] AS TABLE(
	[MappingStyle] [varchar](60) NULL,
	[Utility] [varchar](80) NULL,
	[DeterminantName] [varchar](60) NULL,
	[DeterminantValue] [varchar](200) NULL,
	[DeleteOrNot] [varchar](20) NULL
)
GO


USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[ResultantRecord]    Script Date: 07/27/2013 20:22:11 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'ResultantRecord' AND ss.name = N'dbo')
DROP TYPE [dbo].[ResultantRecord]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[ResultantRecord]    Script Date: 07/27/2013 20:22:11 ******/
CREATE TYPE [dbo].[ResultantRecord] AS TABLE(
	[MappingStyle] [varchar](60) NULL,
	[Utility] [varchar](80) NULL,
	[DeterminantName] [varchar](60) NULL,
	[DeterminantValue] [varchar](200) NULL,
	[ResultantName] [varchar](60) NULL,
	[ResultantValue] [varchar](200) NULL,
	[DeleteOrNot] [varchar](20) NULL
)
GO


USE [Libertypower]
GO

/****** Object:  UserDefinedFunction [dbo].[GetDeterminantValue]    Script Date: 08/08/2013 15:54:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDeterminantValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetDeterminantValue]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedFunction [dbo].[GetDeterminantValue]    Script Date: 08/08/2013 15:54:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[GetDeterminantValue]
(
	@UtilityID varchar(80),
	@AccountNumber varchar(30),
	@FieldName varchar(60),
     @ContextDate datetime = null
)

Returns varchar(60)

AS

BEGIN
			
    DECLARE @DeterminantValue varchar(200)
	DECLARE @EffectiveDate datetime	
	DECLARE @accountFieldHistory TABLE( ID bigint, UtilityID varchar(80), AccountNumber varchar(50), FieldName varchar(60), FieldValue varchar( 200 ), EffectiveDate datetime, FieldSource varchar(60), UserIdentity varchar(256), DateCreated datetime, LockStatus varchar(60), Active bit);

	IF @ContextDate IS NULL 
	BEGIN
		SET @EffectiveDate = getdate() 
	END
	ELSE 
	BEGIN
		SET @EffectiveDate = @ContextDate
	END

	INSERT INTO @accountFieldHistory
	SELECT AccountPropertyHistoryID, UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active
	FROM AccountPropertyHistory WITH (NOLOCK INDEX = IDX_AccountPropertyHistoryTemp02) 
	WHERE UtilityID = @UtilityID
	AND AccountNumber	= @AccountNumber
	AND Active			= 1 
	AND FieldName		= @FieldName
	AND EffectiveDate	<= @ContextDate
	ORDER BY AccountPropertyHistoryID;
	
	IF EXISTS (SELECT * FROM @accountFieldHistory WHERE LockStatus = 'Locked' AND Active = 1)
	BEGIN
		SELECT TOP 1 @DeterminantValue = FieldValue
		FROM @accountFieldHistory
		WHERE LockStatus = 'Locked'
		AND Active = 1
		AND RTRIM(LTRIM(FieldValue)) <> '-1'
		AND RTRIM(LTRIM(FieldValue)) <> ''
		ORDER BY ID DESC;
	END
	ELSE
	BEGIN
		SELECT TOP 1 @DeterminantValue = FieldValue
		FROM @accountFieldHistory
		WHERE Active = 1
		AND RTRIM(LTRIM(FieldValue)) <> '-1'
		AND RTRIM(LTRIM(FieldValue)) <> ''
		ORDER BY ID DESC;
	END
	
RETURN @DeterminantValue

END


GO


USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_ActivityGetAllByUserID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_ActivityGetAllByUserID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_ActivityGetAllByUserID
 * Retrieves all activities for a user
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

      
CREATE proc [dbo].[usp_ActivityGetAllByUserID] 
(
	@UserID int
)        
As        

SET NOCOUNT ON;

Select     
	a.ActivityKey, a.ActivityDesc, a.AppKey, a.DateCreated,    
	r.RoleName,     
	r.RoleID,    
	u.UserID,    
	u.UserName,    
	u.Firstname,    
	u.Lastname,    
	u.Email,    
	u.Password ,  
	u.DateCreated,  
	u.DateModified,  
	u.CreatedBy,  
	u.ModifiedBy,  
	u.LegacyID,  
	u.UserType,
	U.IsActive
From [User] u WITH (NOLOCK)   
join UserRole ur WITH (NOLOCK) on U.UserID = ur.UserID     
join Role r WITH (NOLOCK) on r.RoleID = ur.RoleID    
join ActivityRole ar WITH (NOLOCK) on  r.RoleID= ar.RoleiD    
left outer join Activity a WITH (NOLOCK) on ar.ActivityID = a.ActivityKey        
       
Where u.UserID = @UserID     

SET NOCOUNT OFF;     

GO
USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]    Script Date: 10/14/2013 17:02:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_AccountCurrentPropertiesSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]    Script Date: 10/14/2013 17:02:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]
	@UtilityCode varchar(80),
	@AccountNumber varchar(50),
	@PropertiesXml XML,
	@ContextDate DATETIME = NULL
AS

	DECLARE @Properties TABLE (
		FieldName VARCHAR(60)
	);
	
	IF @ContextDate IS NULL
		SET @ContextDate = GETDATE()
    
	INSERT INTO @Properties (FieldName)
	SELECT M.Item.query('.').value('.','VARCHAR(60)')
	FROM @PropertiesXml.nodes('/Properties/Name') AS M(Item);
		
	DECLARE @AccountPropertyHistory TABLE (
		ID BIGINT ,
		UtilityID VARCHAR(80) ,
		AccountNumber VARCHAR(50) ,
		FieldName VARCHAR(60) ,
		FieldValue VARCHAR(60) ,
		EffectiveDate DATETIME ,
		FieldSource VARCHAR(60) ,
		UserIdentity VARCHAR(256) ,
		DateCreated DATETIME ,
		LockStatus VARCHAR(60) ,
		Active BIT
	);
	
	INSERT INTO @AccountPropertyHistory
		SELECT  H.AccountPropertyHistoryID ,
				H.UtilityID ,
				H.AccountNumber ,
				H.FieldName ,
				H.FieldValue ,
				H.EffectiveDate ,
				H.FieldSource ,
				H.CreatedBy ,
				H.DateCreated ,
				H.LockStatus ,
				H.Active
		FROM    AccountPropertyHistory H ( NOLOCK ) INNER JOIN @Properties P ON H.FieldName = P.FieldName
		WHERE   UtilityID = @UtilityCode
				AND AccountNumber = @AccountNumber
				AND EffectiveDate <= @ContextDate
				AND Active = 1
				
	SELECT  
				HO.ID,
				@UtilityCode AS UtilityID,
				@AccountNumber AS AccountNumber,
				P.FieldName,
				HO.FieldValue,
				HO.EffectiveDate ,
				HO.FieldSource,
				HO.UserIdentity,
				HO.DateCreated,
				HO.LockStatus,
				HO.Active
	  FROM      @Properties P
				CROSS APPLY ( SELECT TOP 1
										Locked.*
							  FROM      @AccountPropertyHistory Locked
							  WHERE     Locked.FieldName = P.FieldName
										AND LockStatus IN ( 'Locked' )
							  ORDER BY  Locked.ID DESC
							  UNION
							  SELECT TOP 1
										Unknown.*
							  FROM      @AccountPropertyHistory Unknown
							  WHERE     Unknown.FieldName = P.FieldName
										AND Unknown.LockStatus NOT IN ( 'Locked' )
										AND NOT EXISTS (	SELECT 1 
															FROM  @AccountPropertyHistory LH 
															WHERE LH.FieldName = Unknown.FieldName AND LH.LockStatus IN ( 'Locked' ))
							  ORDER BY  Unknown.ID DESC
							) HO

GO


USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_AliasDeactivate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_AliasDeactivate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_AliasDeactivate
 * Gets alias values
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_AliasDeactivate]
@ID int
AS

BEGIN

SET NOCOUNT ON;

UPDATE DeterminantAlias SET Active = 0 WHERE ID =  @ID
    
SELECT ID, UtilityCode, FieldName , OriginalValue, AliasValue, UserIdentity, DateCreated, Active
    FROM DeterminantAlias WITH (NOLOCK)
    WHERE ID = @ID

SET NOCOUNT OFF;

END

GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_AliasInsert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_AliasInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_AliasInsert
 * Inserts alias values
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_AliasInsert]
	
    @UtilityCode varchar(50),
    @FieldName varchar(60),
    @OriginalValue varchar(60),
    @AliasValue varchar(60),
    @UserIdentity varchar(256)

AS

BEGIN

	SET NOCOUNT ON;

    INSERT INTO DeterminantAlias (    UtilityCode, FieldName , OriginalValue, AliasValue, UserIdentity)
    VALUES(@UtilityCode,  @FieldName,  @OriginalValue,  @AliasValue,  @UserIdentity )			

    IF SCOPE_IDENTITY() IS NOT NULL
    BEGIN
	   SELECT ID, UtilityCode, FieldName , OriginalValue, AliasValue, UserIdentity, DateCreated, Active
	   FROM DeterminantAlias WITH (NOLOCK)
	   WHERE ID = SCOPE_IDENTITY()
    END

	SET NOCOUNT OFF;

END

GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_AliasSelectAll]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_AliasSelectAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_AliasSelectAll
 * Selects all alias by context date
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_AliasSelectAll]
  @ContextDate datetime
AS

BEGIN
	SET NOCOUNT ON;
	
   SELECT ID, UtilityCode, FieldName , OriginalValue, AliasValue, UserIdentity, DateCreated, Active
    FROM DeterminantAlias WITH (NOLOCK)
    WHERE Active = 1 AND DateCreated <= @ContextDate

	SET NOCOUNT OFF;
END

GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_AliasSelectByID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_AliasSelectByID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_AliasSelectAll
 * Selects all alias by context date
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_Determinants_AliasSelectByID]
    @ID int
AS

BEGIN
	SET NOCOUNT ON;

   SELECT ID, UtilityCode, FieldName , OriginalValue, AliasValue, UserIdentity, DateCreated, Active
    FROM DeterminantAlias WITH (NOLOCK)
    WHERE ID = @ID

	SET NOCOUNT OFF;
END

GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_DeactivateFutureRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_DeactivateFutureRecords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_DeactivateFutureRecords
 * Deactivates future determinant records
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_Determinants_DeactivateFutureRecords]  @UtilityID varchar( 80 ) ,
                                                      @AccountNumber varchar( 50 ) ,
                                                      @FieldName varchar( 60 )
									
                                                      
AS
BEGIN
    SET NOCOUNT ON;

   UPDATE DeterminantHistory
   SET Active = 0
   WHERE UtilityID = @UtilityID
			 AND AccountNumber = @AccountNumber
			 AND FieldName = @FieldName
			 AND EffectiveDate > getdate()
   
   SET NOCOUNT OFF;
END;
GO
USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapAccounts]    Script Date: 08/06/2013 11:11:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldMapAccounts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapAccounts]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapAccounts]    Script Date: 08/06/2013 11:11:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldMapAccounts] 
    @UtilityCode varchar(80),   
    @DriverName varchar(80),
    @DriverValue  varchar(200)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT UtilityID, AccountNumber
		   FROM LibertyPower..AccountPropertyHistory WITH (NOLOCK)
		  WHERE AccountPropertyHistoryID IN(
		   SELECT MAX(AccountPropertyHistoryID) FROM  LibertyPower..AccountPropertyHistory WITH (NOLOCK) 
			  WHERE UtilityID = @UtilityCode
			  AND FieldName = @DriverName
			  AND FieldValue = @DriverValue
			  AND EffectiveDate <= GETDATE()
			  AND Active = 1 
			  GROUP BY UtilityID, AccountNumber, FieldName, FieldValue
			  )

	SET NOCOUNT OFF;
END



GO


USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapDeactivate]    Script Date: 07/13/2013 14:07:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldMapDeactivate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapDeactivate]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapDeactivate]    Script Date: 07/13/2013 14:07:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldMapDeactivate] 
	@ID INT
AS
BEGIN

SET NOCOUNT ON
BEGIN TRANSACTION
	UPDATE DeterminantFieldMaps
	SET ExpirationDate = GETDATE()
	WHERE ID= @ID and ExpirationDate IS NULL
IF @@ERROR != 0
    ROLLBACK
ELSE
    COMMIT
SET NOCOUNT OFF;
END;

GO




USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapsSelect]    Script Date: 05/01/2013 17:01:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldMapsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapsSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldMapsSelect]    Script Date: 05/01/2013 17:01:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_FieldMapsSelect
 * Gets mapping for a date
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_FieldMapsSelect] @ContextDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;

	CREATE TABLE #Max (ID INT PRIMARY KEY)
	
	INSERT INTO #max
		SELECT MAX( da.ID )  
		FROM DeterminantFieldMaps da WITH ( NOLOCK )  
		WHERE da.DateCreated <= @ContextDate  AND (da.ExpirationDate IS NULL OR da.ExpirationDate > @ContextDate)
		GROUP BY da.UtilityCode ,  
		da.DeterminantFieldName ,  
		da.DeterminantValue 
	
	
	SELECT d.ID ,  
	d.UtilityCode ,  
	d.DeterminantFieldName ,  
	d.DeterminantValue ,  
	d.MappingRuleType ,  
	d.CreatedBy ,  
	r.ResultantFieldName ,  
	r.ResultantFieldValue
	FROM #Max t
	JOIN DeterminantFieldMaps d (nolock) ON d.ID = t.ID
	LEFT JOIN  DeterminantFieldMapResultants r (nolock) ON d.ID = r.FieldMapID  
	ORDER BY d.ID , d.UtilityCode , d.DeterminantFieldName , d.DeterminantValue;  

	SET NOCOUNT OFF;

END;



GO


USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueHistorySelect]    Script Date: 07/13/2013 11:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueHistorySelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueHistorySelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueHistorySelect]    Script Date: 07/13/2013 11:49:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueHistorySelect] @UtilityID varchar( 80 ) ,
                                                             @AccountNumber varchar( 50 ) ,
                                                             @FieldName varchar( 60 ) = 'ALL' ,
                                                             @ContextDate datetime
AS
BEGIN
	SET NOCOUNT ON;

    IF @FieldName = 'ALL'
        BEGIN
            SELECT LH.AccountPropertyHistoryID AS ID,
                   UtilityID ,
                   AccountNumber ,
                   FieldName ,
                   FieldValue ,
                   EffectiveDate ,
                   FieldSource ,
                   LH.CreatedBy AS UserIdentity ,
                   LH.DateCreated ,
                   LH.LockStatus ,
                   Active
              FROM AccountPropertyHistory PH WITH (NOLOCK)
              INNER JOIN AccountPropertyLockHistory LH WITH (NOLOCK) ON PH.AccountPropertyHistoryID = LH.AccountPropertyHistoryID
              WHERE UtilityID = @UtilityID
                AND AccountNumber = @AccountNumber
                AND EffectiveDate <= @ContextDate
                AND Active = 1
              ORDER BY LH.DateCreated DESC , FieldName;
        END;
    ELSE
        BEGIN
            SELECT LH.AccountPropertyHistoryID AS ID,
                   UtilityID ,
                   AccountNumber ,
                   FieldName ,
                   FieldValue ,
                   EffectiveDate ,
                   FieldSource ,
                   LH.CreatedBy AS UserIdentity ,
                   LH.DateCreated ,
                   LH.LockStatus ,
                   Active
              FROM AccountPropertyHistory PH WITH (NOLOCK)
              INNER JOIN AccountPropertyLockHistory LH WITH (NOLOCK) ON PH.AccountPropertyHistoryID = LH.AccountPropertyHistoryID
              WHERE UtilityID = @UtilityID
                AND AccountNumber = @AccountNumber
                AND FieldName = @FieldName
                AND EffectiveDate <= @ContextDate
                AND Active = 1
                ORDER BY LH.DateCreated DESC;
        END;

		SET NOCOUNT OFF;
END;




GO


USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueInsert]    Script Date: 10/15/2013 09:42:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueInsert]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueInsert]    Script Date: 10/15/2013 09:42:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_FieldValueInsert
 * Inserts determinant history
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueInsert]
	
    @UtilityID varchar(80),
    @AccountNumber varchar(50),
    @FieldName varchar(60),
    @FieldValue varchar(200),
    @EffectiveDate datetime,
    @FieldSource varchar(60),
    @UserIdentity varchar(256),
    @LockStatus varchar(30),
    @DateCreated DATETIME = NULL,
    @IsActive BIT = 1,
    @UseInternalTran BIT = 1
AS
SET NOCOUNT ON;
DECLARE @AccountPropertyHistoryID BIGINT;

IF @DateCreated IS NULL
	SET	@DateCreated = GETDATE()

IF @LockStatus NOT IN ('Locked','Unknown','Unlocked')
	SET @LockStatus = 'Unknown'

SET @UtilityID = RTRIM(LTRIM(@UtilityID))
SET @AccountNumber = RTRIM(LTRIM(@AccountNumber))
SET @FieldName = RTRIM(LTRIM(@FieldName))
SET @FieldValue = RTRIM(LTRIM(@FieldValue))
SET @FieldSource = RTRIM(LTRIM(@FieldSource))
SET @UserIdentity = RTRIM(LTRIM(@UserIdentity))
SET @LockStatus = RTRIM(LTRIM(@LockStatus))

BEGIN TRY
--compare with the last entry for the property to avoid duplicates

                        
	IF @UseInternalTran = 1 BEGIN TRAN

    INSERT  INTO AccountPropertyHistory
            ( UtilityID ,
              AccountNumber ,
              FieldName ,
              FieldValue ,
              EffectiveDate ,
              FieldSource ,
              CreatedBy ,
              DateCreated ,
              LockStatus ,
              Active
            )
    VALUES  ( @UtilityID ,
              @AccountNumber ,
              @FieldName ,
              @FieldValue ,
              @EffectiveDate ,
              @FieldSource ,
              @UserIdentity ,
              @DateCreated ,
              @LockStatus ,
              @IsActive
            )
				
	IF(SCOPE_IDENTITY() IS NOT NULL)
		BEGIN
		   SET	@AccountPropertyHistoryID = SCOPE_IDENTITY()
		   INSERT   INTO AccountPropertyLockHistory
					( AccountPropertyHistoryID ,
					  LockStatus ,
					  CreatedBy ,
					  DateCreated
					)
		   VALUES   ( @AccountPropertyHistoryID ,
					  @LockStatus ,
					  @UserIdentity ,
					  @DateCreated
					)
			
		   SELECT   AccountPropertyHistoryID AS 'ID' ,
					UtilityID ,
					AccountNumber ,
					FieldName ,
					FieldValue ,
					EffectiveDate ,
					FieldSource ,
					CreatedBy AS UserIdentity ,
					DateCreated ,
					LockStatus ,
					Active
		   FROM     AccountPropertyHistory WITH ( NOLOCK )
		   WHERE    AccountPropertyHistoryID = @AccountPropertyHistoryID
		END
	ELSE
		BEGIN
			IF @UseInternalTran = 1 ROLLBACK
		END	

    IF @UseInternalTran = 1 COMMIT TRAN
END TRY
BEGIN CATCH
	IF @UseInternalTran = 1 ROLLBACK TRAN
	DECLARE 
		@ErrorMessage NVARCHAR(4000),
		@ErrorSeverity INT,
		@ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();
           
    RAISERROR (@ErrorMessage,
               @ErrorSeverity,
               @ErrorState );
END CATCH
SET NOCOUNT OFF;

GO


USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueLock]    Script Date: 07/13/2013 11:47:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueLock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueLock]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueLock]    Script Date: 07/13/2013 11:47:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueLock]  
	@UtilityID varchar( 80 ),
	@AccountNumber varchar( 50 ),
	@FieldName varchar( 60 ),
	@FieldSource varchar(60),
	@UserIdentity varchar(256),
	@lock bit                                                   
AS
BEGIN   
	SET NOCOUNT ON;

	DECLARE @AccountPropertyHistoryID	bigint,
			@LockStatus					varchar(60),
			@Now						datetime
	
	DECLARE @accountFieldHistory TABLE( ID bigint, UtilityID varchar(80), AccountNumber varchar(50), FieldName varchar(60), FieldValue varchar( 200 ), EffectiveDate datetime, FieldSource varchar(60), UserIdentity varchar(256), DateCreated datetime, LockStatus varchar(60), Active bit);
	
	INSERT INTO @accountFieldHistory
	SELECT AccountPropertyHistoryID, UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active
	FROM AccountPropertyHistory (NOLOCK) 
	WHERE UtilityID = @UtilityID
	AND AccountNumber = @AccountNumber
	AND FieldName = @FieldName
	ORDER BY AccountPropertyHistoryID;
	
	SET	@Now = GETDATE()
	SET	@LockStatus = CASE WHEN @lock = 0 THEN 'Unlocked' ELSE 'Locked' END

	IF (@lock = 0)
	BEGIN
		SELECT @AccountPropertyHistoryID = ID
		FROM @accountFieldHistory
		WHERE LockStatus = 'Locked'
	END
	ELSE 
	BEGIN
		IF NOT EXISTS (SELECT *
					   FROM @accountFieldHistory
					   WHERE LockStatus = 'Locked')
		BEGIN
			SELECT TOP 1 @AccountPropertyHistoryID = ID
			FROM @accountFieldHistory
			ORDER BY DateCreated DESC
		END		
    END
	
	IF(@AccountPropertyHistoryID IS NOT NULL)
	BEGIN		
		UPDATE AccountPropertyHistory
		SET LockStatus = @LockStatus
		WHERE AccountPropertyHistoryID = @AccountPropertyHistoryID
		
		INSERT INTO AccountPropertyLockHistory (AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated)
		VALUES		(@AccountPropertyHistoryID, @LockStatus, @UserIdentity, @Now)		
		
		SELECT	AccountPropertyHistoryID AS ID, UtilityID, AccountNumber, FieldName, FieldValue,
				EffectiveDate, FieldSource, CreatedBy AS UserIdentity, DateCreated, LockStatus, Active
		FROM	AccountPropertyHistory WITH (NOLOCK)
		WHERE	AccountPropertyHistoryID = @AccountPropertyHistoryID
	 END

	 SET NOCOUNT OFF;
END


GO


USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueSelect]    Script Date: 10/14/2013 17:00:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueSelect]    Script Date: 10/14/2013 17:00:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueSelect] 
	@UtilityID varchar( 80 ),
	@AccountNumber varchar( 50 ),
	@FieldName varchar( 60 ),
	@ContextDate datetime = null
AS
BEGIN
	DECLARE @Properties XML;
	SET @Properties = '<Properties><Name>'+ISNULL(@FieldName,'')+'</Name></Properties>'
	EXEC dbo.usp_Determinants_AccountCurrentPropertiesSelect
		@UtilityID,
		@AccountNumber,
		@Properties,
		@ContextDate
END;

GO


USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_Determinants_FutureFieldValueHistorySelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_Determinants_FutureFieldValueHistorySelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_FutureFieldValueHistorySelect
 * Gets history for a field
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_FutureFieldValueHistorySelect] @UtilityID varchar( 80 ) ,
                                                             @AccountNumber varchar( 50 ) ,
                                                             @FieldName varchar( 30 ) 
AS
BEGIN		
		SET NOCOUNT ON;

            SELECT ID ,
                   UtilityID ,
                   AccountNumber ,
                   FieldName ,
                   FieldValue ,
                   EffectiveDate ,
                   FieldSource ,
                   UserIdentity ,
                   DateCreated ,
                   LockStatus ,
                   Active
              FROM DeterminantHistory WITH (NOLOCK)
              WHERE UtilityID = @UtilityID
                AND AccountNumber = @AccountNumber
                AND FieldName = @FieldName
                AND EffectiveDate > GetDate()
                AND Active = 1
              ORDER BY ID DESC;

		SET NOCOUNT OFF;
END;


GO
USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FutureFieldValueSelect]    Script Date: 07/13/2013 11:50:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FutureFieldValueSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FutureFieldValueSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FutureFieldValueSelect]    Script Date: 07/13/2013 11:50:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_Determinants_FutureFieldValueSelect] 
	@UtilityID varchar( 80 ),
	@AccountNumber varchar( 50 ),
	@FieldName varchar( 30 )
AS
BEGIN
	SET NOCOUNT ON;

	SELECT AccountPropertyHistoryID AS ID ,
		   UtilityID ,
		   AccountNumber ,
		   FieldName ,
		   FieldValue ,
		   EffectiveDate ,
		   FieldSource ,
		   CreatedBy AS UserIdentity ,
		   DateCreated ,
		   LockStatus ,
		   Active
	  FROM AccountPropertyHistory WITH (NOLOCK)
	  WHERE UtilityID = @UtilityID
		AND AccountNumber = @AccountNumber
		AND FieldName = @FieldName
		AND EffectiveDate > GetDate()
		AND Active = 1
	  ORDER BY AccountPropertyHistoryID DESC;

	  SET NOCOUNT OFF;
END;

GO


USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetIT059MigrationData]    Script Date: 08/19/2013 10:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetIT059MigrationData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetIT059MigrationData]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetIT059MigrationData]    Script Date: 08/19/2013 10:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku John
-- Create date: 8/21/2013
-- Description:	Getting all IT059 migration data

/*

*/
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetIT059MigrationData]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      


-- to get mutliple meter utilities

	if OBJECT_ID('tempdb..#GridResult') is not null
	drop table #GridResult

	if OBJECT_ID('tempdb..#EnrolledAccounts') is not null
	drop table #EnrolledAccounts
	
	if OBJECT_ID('tempdb..#UnEnrolledAccounts') is not null
		drop table #UnEnrolledAccounts
	

	if OBJECT_ID('tempdb..#LatestIcapDates') is not null
		drop table #LatestIcapDates
	if OBJECT_ID('tempdb..#LatestTcapDates') is not null
		drop table #LatestTcapDates

	if OBJECT_ID('tempdb..#LatestIcaps') is not null
			drop table #LatestIcaps
	if OBJECT_ID('tempdb..#LatestTcaps') is not null
		drop table #LatestTcaps
		
	if OBJECT_ID('tempdb..#MultipleMeterAmeren') is not null
		drop table #MultipleMeterAmeren
	
	if OBJECT_ID('tempdb..#SingleMeterAmeren') is not null
		drop table #SingleMeterAmeren
	
	
	if OBJECT_ID('tempdb..#LatestEdiDates') is not null
		drop table #LatestEdiDates	
		
	if OBJECT_ID('tempdb..#LatestIcapDates1') is not null
			drop table #LatestIcapDates1
	if OBJECT_ID('tempdb..#LatestTcapDates1') is not null
		drop table #LatestTcapDates1	
	
	if OBJECT_ID('tempdb..#EdiEnrolledAmeren') is not null
		drop table #EdiEnrolledAmeren

	if OBJECT_ID('tempdb..#EnrolledMissingIcaps') is not null
		drop table #EnrolledMissingIcaps
	
	if OBJECT_ID('tempdb..#EnrolledMissingTcaps') is not null
		drop table #EnrolledMissingTcaps
	
	if OBJECT_ID('tempdb..#IstaIcapsTcaps') is not null
		drop table #IstaIcapsTcaps
	
	if OBJECT_ID('tempdb..#EnrolledAmerenMissingIcaps') is not null
		drop table #EnrolledAmerenMissingIcaps
		
	if OBJECT_ID('tempdb..#UnchangedAccountNumberOeAccounts') is not null
		drop table #UnchangedAccountNumberOeAccounts
		
	if OBJECT_ID('tempdb..#ChangedAccountNumberOeAccounts') is not null
		drop table #ChangedAccountNumberOeAccounts
	
	if OBJECT_ID('tempdb..#AccountNumberChanges') is not null
		drop table #AccountNumberChanges	
		
	--
	Create table #LatestIcapDates(Utilitycode varchar(80), AccountNumber varchar(50), LatestInsert datetime)
	Create table #LatestTcapDates(Utilitycode varchar(80), AccountNumber varchar(50), LatestInsert datetime)
	Create table #LatestIcaps(Utilitycode varchar(80), AccountNumber varchar(50), Icap decimal(12,6), EffectiveDate datetime)
	Create table #LatestTcaps(Utilitycode varchar(80), AccountNumber varchar(50),Tcap decimal(12,6), EffectiveDate datetime)
	Create table #EnrolledMissingIcaps(Utilitycode varchar(80), AccountNumber varchar(50))
	Create table #EnrolledMissingTcaps(Utilitycode varchar(80), AccountNumber varchar(50))
	Create table #EnrolledAmerenMissingIcaps(Utilitycode varchar(80), AccountNumber varchar(50))
	Create table #UnchangedAccountNumberOeAccounts(Utilitycode varchar(80), AccountNumber varchar(50))
	Create table #ChangedAccountNumberOeAccounts(Utilitycode varchar(80), OldAccountNumber varchar(50),NewAccountNumber varchar(50))
	Create table #AccountNumberChanges(Utilitycode varchar(80), OldAccountNumber varchar(50),NewAccountNumber varchar(50))
	Create table #UnEnrolledAccounts(Utilitycode varchar(80), OldAccountNumber varchar(50),NewAccountNumber varchar(50))
	Create table #EnrolledAccounts(Utilitycode varchar(80), OldAccountNumber varchar(50),NewAccountNumber varchar(50))
	
	insert into #AccountNumberChanges
	select u.UtilityCode,anh.old_account_number,anh.new_account_number 
	from lp_account..account_number_history anh (nolock)
	join libertypower..account a (nolock) on anh.account_id = a.AccountIdLegacy
	join libertypower..Utility u (nolock) on a.UtilityID=u.id
	
	insert into #EnrolledAccounts	
	SELECT distinct cast(u.UtilityCode as varchar(80)) ,cast(a.AccountNumber as varchar(50)),cast(a.AccountNumber as varchar(50))
	FROM OfferEngineDB..OE_ACCOUNT OE  (NOLOCK)
	INNER JOIN Libertypower..Utility U  (NOLOCK) ON OE.UTILITY = U.UtilityCode
	JOIN Libertypower..Account A  (NOLOCK) ON OE.ACCOUNT_NUMBER = A.AccountNumber AND A.UtilityID = U.ID
	JOIN Libertypower..AccountContract AC  (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN Libertypower..AccountStatus AST  (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE AST.[Status] = '905000' -- enrolled
	AND U.MarketID NOT IN (1,2) -- excluding ca and tx
	
	
	insert into #EnrolledAccounts	
	SELECT distinct  cast(u.UtilityCode as varchar(80)),oa.Account_number, cast(a.AccountNumber as varchar(50))
	FROM Libertypower..Account A WITH (NOLOCK)
	
	JOIN Libertypower..Utility u (nolock) on a.UtilityID=u.id
	JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID

	join lp_account..account_number_history anh (nolock) on anh.account_id=a.AccountIdLegacy

	join OfferEngineDB..OE_ACCOUNT oa WITH (NOLOCK) on oa.ACCOUNT_NUMBER=anh.old_account_number and oa.UTILITY=u.UtilityCode
	WHERE AST.[Status] = '905000' -- enrolled
	AND U.MarketID NOT IN (1,2) -- excluding ca and tx
	
	Create clustered index #EnrolledAccounts_cidx1 on #EnrolledAccounts (UtilityCode, OldAccountNumber, NewAccountNumber) with fillfactor =100
	
	--MISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' 
	from #EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='miso'
	and a.Icap is not null and len(a.Icap)> 0
	
	--NYISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'05/01/2013'
	from #EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='nyiso'
	and a.Icap is not null and len(a.Icap)> 0
	
	--PJM 
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' from
	#EnrolledAccounts ea (nolock) 
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='pjm'
	and a.Icap is not null and len(a.Icap)> 0
	
	insert into #LatestTcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Tcap as decimal(12,6)),'01/01/2013' from
	#EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.newAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='pjm'
	and a.Tcap is not null and len(a.Tcap)> 0
	
	--NEISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' from
	#EnrolledAccounts ea (nolock) 
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='neiso'
	and a.Icap is not null and len(a.Icap)> 0
	
	----------------------------Beginning of Handlement for PROSPECT accounts---------------------
	
	insert into #UnEnrolledAccounts
	select distinct oa.utility, oa.Account_Number,anc.NewAccountNumber
	
	from offerenginedb..oe_account oa (nolock)
	join #AccountNumberChanges anc (nolock) on oa.ACCOUNT_NUMBER=anc.OldAccountNumber and oa.UTILITY= anc.Utilitycode
	JOIN OfferEngineDB..OE_OFFER_ACCOUNTS ooa (NOLOCK) on ooa.OE_ACCOUNT_ID =oa.ID 
	JOIN OfferEngineDB..OE_OFFER oo (nolock) on oo.OFFER_ID= ooa.OFFER_ID
	join libertypower..Utility u (nolock) on oa.UTILITY =u.UtilityCode
	join libertypower..account a (nolock) on anc.NewAccountNumber=a.AccountNumber and u.ID = a.UtilityID
	JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE U.MarketID NOT IN (1,2) -- excluding ca and tx
	AND oo.DATE_CREATED >= '01/01/2013'
	and AST.[Status] <> '905000'
	
	--select * from #UnEnrolledAccounts
	
	insert into #UnEnrolledAccounts
	select distinct oa.utility, oa.ACCOUNT_NUMBER,oa.ACCOUNT_NUMBER
	from offerenginedb..oe_account oa (nolock)
	left join #AccountNumberChanges anc (nolock) on oa.ACCOUNT_NUMBER=anc.OldAccountNumber and oa.UTILITY= anc.Utilitycode
	
	JOIN OfferEngineDB..OE_OFFER_ACCOUNTS ooa (NOLOCK) on ooa.OE_ACCOUNT_ID =oa.ID 
	JOIN OfferEngineDB..OE_OFFER oo (nolock) on oo.OFFER_ID= ooa.OFFER_ID
	
	join libertypower..Utility u (nolock) on oa.UTILITY =u.UtilityCode
	
	left join libertypower..account a (nolock) on anc.NewAccountNumber=a.AccountNumber and u.ID = a.UtilityID
	LEFT JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	LEFT JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE U.MarketID NOT IN (1,2) -- excluding ca and tx
	AND oo.DATE_CREATED >= '01/01/2013'
	and anc.OldAccountNumber is null
	and (a.AccountID is null or AST.[Status] <> '905000')
	
	Create clustered index #UnEnrolledAccounts_cidx1 on #UnEnrolledAccounts (UtilityCode, OldAccountNumber, NewAccountNumber) with fillfactor =100
	
	insert into #LatestIcaps
	select distinct 'COMED',ca.AccountNumber, ca.CapacityPLC1Value,ca.CapacityPLC1StartDate
	from lp_transactions..comedaccount ca with (nolock)
	join 
	(
		select ca.AccountNumber, max(ca.Created) NewestCreated 
		from lp_transactions..comedaccount ca  with (nolock)
		join #UnEnrolledAccounts uea on ca.AccountNumber=uea.newAccountNumber
		where uea.UtilityCode='COMED'and ca.CapacityPLC1Value >=0
		group by ca.AccountNumber
	)ca1 on ca1.AccountNumber=ca.AccountNumber and ca1.NewestCreated=ca.Created
	
	--future icap entries in comed
	insert into #LatestIcaps
	select distinct 'COMED',ca.AccountNumber, ca.CapacityPLC2Value,ca.CapacityPLC2StartDate
	from lp_transactions..comedaccount ca  with (nolock)
	join 
	(
		select ca.AccountNumber, max(ca.Created) NewestCreated 
		from lp_transactions..comedaccount ca  with (nolock)
		join #UnEnrolledAccounts uea on ca.AccountNumber=uea.NewAccountNumber
		where uea.UtilityCode='COMED'and ca.CapacityPLC2Value >=0
		group by ca.AccountNumber
	)ca1 on ca1.AccountNumber=ca.AccountNumber and ca1.NewestCreated=ca.Created
	
	insert into #LatestTcaps
	select distinct 'COMED',ca.AccountNumber, ca.NetworkServicePLCValue,ca.NetworkServicePLCStartDate
	from lp_transactions..comedaccount ca  with (nolock)
	join 
	(
		select ca.AccountNumber, max(ca.Created) NewestCreated 
		from lp_transactions..comedaccount ca  with (nolock)
		join #UnEnrolledAccounts uea on ca.AccountNumber=uea.NewAccountNumber
		where uea.UtilityCode='COMED'and ca.NetworkServicePLCValue >=0
		group by ca.AccountNumber
	)ca1 on ca1.AccountNumber=ca.AccountNumber and ca1.NewestCreated=ca.Created
	
	insert into #LatestIcaps
	select 'CONED',cna.AccountNumber, cna.ICAP, cna.created
	from lp_transactions..ConedAccount cna  with (nolock)
	join 
	(
		select cna.AccountNumber, max(cna.created) LatestCreated 
		from lp_transactions..conedaccount cna  with (nolock)
		join #UnEnrolledAccounts uea on uea.NewAccountNumber=cna.AccountNumber 
		where uea.UtilityCode='CONED' and cna.ICAP >=0
		group by cna.AccountNumber
	) cna1 on cna1.AccountNumber = cna.AccountNumber and cna1.LatestCreated = cna.Created
	
	insert into #LatestIcaps
	select 'NYSEG',ny.AccountNumber, ny.Icap, ny.Created
	from lp_transactions..NysegAccount ny  with (nolock)
	join
	(
		select ny.AccountNumber, max(ny.Created) LatestCreated 
		from lp_transactions..NysegAccount ny  with (nolock)
		join #UnEnrolledAccounts uea on uea.NewAccountNumber = ny.AccountNumber
		where uea.UtilityCode='NYSEG' and ny.Icap >=0
		group by ny.AccountNumber
	) ny1 on ny1.LatestCreated=ny.Created and ny1.AccountNumber=ny.AccountNumber
	
	insert into #LatestIcaps
	select 'RGE',rge.AccountNumber, rge.Icap, rge.Created
	from lp_transactions..RgeAccount rge with (nolock)
	join
	(
		select rge.AccountNumber, max(rge.Created) LatestCreated 
		from lp_transactions..RgeAccount rge with (nolock) 
		join #UnEnrolledAccounts uea on uea.NewAccountNumber = rge.AccountNumber
		where uea.UtilityCode='RGE' and rge.Icap >=0
		group by rge.AccountNumber
	) rge1 on rge1.LatestCreated=rge.Created and rge1.AccountNumber=rge.AccountNumber
	
	insert into #LatestIcaps
	select 'BGE',bge.AccountNumber, bge.CapPLC, bge.Created
	from lp_transactions..BgeAccount bge with (nolock)
	join
	(
		select bge.AccountNumber, max(bge.Created) LatestCreated 
		from lp_transactions..BgeAccount bge with (nolock)
		join #UnEnrolledAccounts uea on uea.NewAccountNumber = bge.AccountNumber
		where uea.UtilityCode='BGE' and bge.CapPLC >=0
		group by bge.AccountNumber
	) bge1 on bge1.LatestCreated=bge.Created and bge1.AccountNumber=bge.AccountNumber
	
	insert into #LatestTcaps
	select 'BGE',bge.AccountNumber, bge.TransPLC, bge.Created
	from lp_transactions..BgeAccount bge with (nolock)
	join
	(
		select bge.AccountNumber, max(bge.Created) LatestCreated 
		from lp_transactions..BgeAccount bge with (nolock)
		join #UnEnrolledAccounts uea on uea.NewAccountNumber = bge.AccountNumber
		where uea.UtilityCode='BGE' and bge.TransPLC >=0
		group by bge.AccountNumber
	) bge1 on bge1.LatestCreated=bge.Created and bge1.AccountNumber=bge.AccountNumber
	
	insert into #latestIcaps
	select edi1.UtilityCode, edi1.AccountNumber, Case when edi1.UtilityCode='CMP' THEN edi.Icap *1000.0 else edi.Icap End, edi.TimeStampInsert 
	from lp_transactions..EdiAccount edi with (nolock)
	join 
	(
		select edi.UtilityCode,edi.AccountNumber,max(edi.TimeStampInsert) LastTimeStampInsert 
		from lp_transactions..ediaccount edi with (nolock)
		join #UnEnrolledAccounts uea on uea.UtilityCode=edi.UtilityCode and uea.NewAccountNumber=edi.AccountNumber
		where edi.Icap >=0 and edi.UtilityCode not in ('COMED','AMEREN','CONED','RGE','RGE','NYSEG','NIMO','CENHUD','BANGOR')
		group by edi.UtilityCode,edi.AccountNumber
	) edi1 on edi.AccountNumber = edi1.AccountNumber and edi.UtilityCode=edi1.UtilityCode and edi1.LastTimeStampInsert=edi.TimeStampInsert
	
	insert into #latestTcaps
	select edi1.UtilityCode, edi1.AccountNumber, edi.Tcap, edi.TimeStampInsert 
	from lp_transactions..EdiAccount edi with (nolock)
	join 
	(
		select edi.UtilityCode,edi.AccountNumber,max(edi.TimeStampInsert) LastTimeStampInsert 
		from lp_transactions..ediaccount edi with (nolock)
		join #UnEnrolledAccounts uea on uea.UtilityCode=edi.UtilityCode and uea.NewAccountNumber=edi.AccountNumber
		join libertypower..utility u (nolock) on uea.Utilitycode=u.UtilityCode
		where edi.Tcap >=0 and edi.UtilityCode not in ('COMED','AMEREN','CONED','RGE','RGE','NYSEG','NIMO','CENHUD','BANGOR')
		and u.WholeSaleMktID = 'pjm'
		group by edi.UtilityCode,edi.AccountNumber
	) edi1 on edi.AccountNumber = edi1.AccountNumber and edi.UtilityCode=edi1.UtilityCode and edi1.LastTimeStampInsert=edi.TimeStampInsert
	
	insert into #LatestIcaps
	select oa.UTILITY, oa.Account_number, oa.Icap, max(oo.DATE_CREATED)
	from OfferEngineDB..oe_account oa  with (nolock)
	join #UnEnrolledAccounts uea on  oa.UTILITY=uea.UtilityCode and oa.ACCOUNT_NUMBER=uea.NewAccountNumber
	join OfferEngineDB..OE_OFFER_ACCOUNTS ooa with (nolock) on ooa.OE_ACCOUNT_ID=oa.ID
	join offerenginedb..OE_OFFER oo with (nolock) on ooa.OFFER_ID=oo.offer_id
	where uea.UtilityCode in ('NIMO','CENHUD','BANGOR')  and oa.Icap > =0
	group by oa.UTILITY,oa.Account_number,oa.ICAP
	
	select * from #LatestIcaps
	select * from #LatestTcaps

	select aa.AccountNumber, aa.Servicepoint, aa.EffectivePLC, aa.EligibleSwitchDate,Created from lp_transactions..amerenaccount aa with (nolock)
	join #UnEnrolledAccounts uea on uea.NewAccountNumber = aa.AccountNumber
	where uea.UtilityCode = 'Ameren'
	
	SELECT ISNULL(oa.UTILITY, '') AS UTILITY,
	ISNULL(oa.ACCOUNT_NUMBER, '') AS ACCOUNT_NUMBER,
	ISNULL(oa.METER_TYPE, '') AS METER_TYPE ,
	ISNULL(oa.RATE_CLASS, '') AS RATE_CLASS ,
	ISNULL(oa.VOLTAGE, '') AS VOLTAGE,
	ISNULL(oa.ZONE, '') AS ZONE,
	ISNULL(oa.LOAD_SHAPE_ID, '') AS LOAD_SHAPE_ID,
	ISNULL(oa.LOAD_PROFILE, '')  AS LOAD_PROFILE,
	ISNULL(oa.TarrifCode, '')  AS TarrifCode,
	ISNULL(oa.Grid, '') AS Grid,
	ISNULL(oa.LbmpZone, '') AS LbmpZone,
	ISNULL(oa.ICAP, 0) AS ICAP,
	ISNULL(oa.TCAP, 0) AS TCAP,
	ISNULL(oa.LOSSES, 0) AS Losses
	FROM OfferEngineDB..OE_ACCOUNT oa WITH (NOLOCK)
	JOIN #UnEnrolledAccounts uea (nolock) on uea.OldAccountNumber=oa.Account_Number
	union
	SELECT ISNULL(oa.UTILITY, '') AS UTILITY,
	ISNULL(oa.ACCOUNT_NUMBER, '') AS ACCOUNT_NUMBER,
	ISNULL(oa.METER_TYPE, '') AS METER_TYPE ,
	ISNULL(oa.RATE_CLASS, '') AS RATE_CLASS ,
	ISNULL(oa.VOLTAGE, '') AS VOLTAGE,
	ISNULL(oa.ZONE, '') AS ZONE,
	ISNULL(oa.LOAD_SHAPE_ID, '') AS LOAD_SHAPE_ID,
	ISNULL(oa.LOAD_PROFILE, '')  AS LOAD_PROFILE,
	ISNULL(oa.TarrifCode, '')  AS TarrifCode,
	ISNULL(oa.Grid, '') AS Grid,
	ISNULL(oa.LbmpZone, '') AS LbmpZone,
	ISNULL(oa.ICAP, 0) AS ICAP,
	ISNULL(oa.TCAP, 0) AS TCAP,
	ISNULL(oa.LOSSES, 0) AS Losses
	FROM OfferEngineDB..OE_ACCOUNT oa WITH (NOLOCK)
	JOIN #EnrolledAccounts ea (nolock) on ea.OldAccountNumber=oa.Account_Number
	
	SET NOCOUNT OFF
END




GO
USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]    Script Date: 08/19/2013 10:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]    Script Date: 08/19/2013 10:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --Get the accounts with multiple meters for Ameren





	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      


-- to get mutliple meter utilities

	if OBJECT_ID('tempdb..#GridResult') is not null
	drop table #GridResult

	if OBJECT_ID('tempdb..#EnrolledAccounts') is not null
	drop table #EnrolledAccounts

	if OBJECT_ID('tempdb..#MultipleMeterAmeren') is not null
		drop table #MultipleMeterAmeren
	
	--- temp table exists
	Create table #EnrolledAccounts (Utility varchar(50), AccountNumber VARCHAR(50))
	insert into #EnrolledAccounts

	SELECT oe.Account_Number,oe.UTILITY
	FROM OfferEngineDB..OE_ACCOUNT OE WITH (NOLOCK)
	INNER JOIN Libertypower..Utility U WITH (NOLOCK) ON OE.UTILITY = U.UtilityCode
	LEFT JOIN Libertypower..Account A WITH (NOLOCK) ON OE.ACCOUNT_NUMBER = A.AccountNumber AND A.UtilityID = U.ID
	LEFT JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	LEFT JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE AST.[Status] = '905000'

	Create clustered index #EnrolledAccounts_cidx1 on #EnrolledAccounts (UTILITY, ACCOUNTNUMBER) with fillfactor =100

	select 
		  oe.account_number as AccountNumber
	,     oe.market 
	,     oe.Utility as UtilityCode

	into #GridResult
	from offerenginedb..OE_Account oe with(nolock)
	left join #EnrolledAccounts a on oe.account_number=a.accountnumber and a.Utility = oe.Utility
	where a.accountnumber is null 
	group by  
	oe.account_number
	,oe.market 
	,oe.Utility

	Create clustered index #GridResult_cidx1 on #GridResult (UtilityCode, AccountNumber) with fillfactor =100
 

	select tmp1.accountnumber
	into #MultipleMeterAmeren
	from
	(
		select tmp.accountnumber, count(*) ct from 
		(
			select AccountNumber, isnull(MeterNumber,'NULL') as mn, count(*) as cnt 
			from lp_transactions..AmerenAccount with (nolock)
			group by AccountNumber, isnull(meternumber,'NULL')
		) tmp
		group by tmp.accountnumber 
		having count(*) >1
		and 
		(
		select count(distinct MeterNumber) from lp_transactions..AmerenAccount with (nolock)
		where MeterNumber is not null and  meternumber <> '' and accountnumber =tmp.accountnumber

		) > 1
	) tmp1
	 
	Create clustered index #MultipleMeterAmeren_cidx1 on #MultipleMeterAmeren (ACCOUNTNUMBER) with fillfactor =100
 
	select am.Id, am.AccountNumber, am.MeterNumber,am.ServicePoint, am.EffectivePLC, am.Created
	from lp_transactions..AmerenAccount am with (nolock)
	join #MultipleMeterAmeren sme on am.AccountNumber =sme.AccountNumber
	join #GridResult gr on sme.Accountnumber =gr.AccountNumber and gr.UtilityCode='Ameren'
	order by am.AccountNumber,am.Created
 
	SET NOCOUNT OFF
END

GO


USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_InitialAccountPropertyValuesInsert]    Script Date: 08/22/2013 15:41:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_InitialAccountPropertyValuesInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_InitialAccountPropertyValuesInsert]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_InitialAccountPropertyValuesInsert]    Script Date: 08/22/2013 15:41:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Jikku joseph John  
-- Create date: 07/18/2013  
-- Description: Initial filling of account property values history  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_InitialAccountPropertyValuesInsert]  
 -- Add the parameters for the stored procedure here  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    -- Insert statements for procedure here  
 
 SET NOCOUNT ON;  
 
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
 if OBJECT_ID('tempdb..#PROPERTYOUTPUT') is not null  
  drop table #PROPERTYOUTPUT  
 
 CREATE TABLE #PROPERTYOUTPUT (AccountPropertyHistoryID BIGINT PRIMARY KEY NONCLUSTERED, LockStatus VARCHAR(60), CreatedBy VARCHAR(256), DateCreated DATETIME)   
   
 
 DECLARE @CurrDate DateTime  
 SELECT @CurrDate = GETDATE()  
 
 BEGIN TRANSACTION  
 
 INSERT INTO AccountPropertyHistory(UtilityID,AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,DateCreated,LockStatus,Active)  
 OUTPUT INSERTED.AccountPropertyHistoryID, INSERTED.LockStatus,INSERTED.CreatedBy, INSERTED.DateCreated INTO #PROPERTYOUTPUT  
 --SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingAllElseFillDefaultValue', 'System',@CurrDate,'Unknown',1  
 SELECT   
	 Utility,  
	 AccountNumber,  
	 FieldName,  
	 FieldValue,  
	 EffectiveDate,  
	 'SystemInitialValue',  
	 'System',  
	 @CurrDate,   
	 'Unknown',  
	 1  
 FROM   dbo.TmpAccountPropertyHistory with (nolock)
   
 INSERT INTO AccountPropertyLockHistory (AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated)  
 SELECT AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated  
 FROM #PROPERTYOUTPUT
 order by AccountPropertyHistoryID  
 
 IF @@ERROR != 0        
  ROLLBACK        
 ELSE        
  COMMIT     
    truncate table TmpAccountPropertyHistory
 SET NOCOUNT OFF;    
END  
GO


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertDeactivateAndApplyMappings]    Script Date: 05/23/2013 21:28:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_InsertDeactivateAndApplyMappings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_InsertDeactivateAndApplyMappings]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertDeactivateAndApplyMappings]    Script Date: 05/23/2013 21:28:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 5/14/2013
-- Description:	Takes a list of mappings/rules and does the appropriate insertion/deactivation and
-- application to target accounts
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertDeactivateAndApplyMappings] 
	-- Add the parameters for the stored procedure here
	@MappingList as dbo.MappingRecord READONLY,
	@ResultantList as dbo.ResultantRecord READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	BEGIN TRANSACTION
	SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @CurrDate Datetime
	SELECT @CurrDate = GETDATE()
	
	-- Insert statements for procedure here
	Create table #MappingsTable (seqid int identity (1,1), MappingStyle VARCHAR(60), Utility VARCHAR(80), DeterminantName VARCHAR(60), DeterminantValue VARCHAR(200), DeleteOrNot VARCHAR(20))

	Create table #ResultantsTable (seqid int identity (1,1) primary key, MappingStyle VARCHAR(60), Utility VARCHAR(80), DeterminantName VARCHAR(60), DeterminantValue VARCHAR(200), ResultantName VARCHAR(60), ResultantValue VARCHAR(200),DeleteOrNot VARCHAR(20))
	
	INSERT INTO #MappingsTable(MappingStyle, Utility, DeterminantName, DeterminantValue, DeleteOrNot)
	SELECT MappingStyle, Utility, DeterminantName, DeterminantValue, DeleteOrNot
	FROM
	@MappingList
	
	Create clustered index cidx1 on #MappingsTable (Utility, DeterminantName, DeterminantValue)

	INSERT INTO #ResultantsTable(MappingStyle, Utility, DeterminantName, DeterminantValue, ResultantName, ResultantValue, DeleteOrNot)
	SELECT 
	MappingStyle, Utility, DeterminantName, DeterminantValue, ResultantName, ResultantValue, DeleteOrNot
	FROM
	@ResultantList

	UPDATE  dfm
	SET dfm.ExpirationDate = @CurrDate
	FROM DeterminantFieldMaps dfm
	JOIN #MappingsTable mt ON mt.Utility = dfm.UtilityCode AND mt.DeterminantName= dfm.DeterminantFieldName AND mt.DeterminantValue=dfm.DeterminantValue
	WHERE dfm.ExpirationDate IS NULL 
	
	--Insert mapping and the resultants
	Create table #OUTPUT (ID int primary KEY NONCLUSTERED, UtilityCode VARCHAR(80), DeterminantFieldName VARCHAR(60), DeterminantValue VARCHAR(200)) 
	
	INSERT INTO DeterminantFieldMaps(UtilityCode,DeterminantFieldName,DeterminantValue,MappingRuleType,DateCreated,CreatedBy)
	OUTPUT INSERTED.ID, INSERTED.UtilityCode,INSERTED.DeterminantFieldName, INSERTED.DeterminantValue into #OUTPUT
	SELECT mt.Utility, mt.DeterminantName, ltrim(rtrim(mt.DeterminantValue)), mt.MappingStyle, @CurrDate, 'unknown'
	FROM		 #MappingsTable	  mt
	where mt.DeleteOrNot = 'N' OR mt.DeleteOrNot = 'No'

	CREATE CLUSTERED INDEX cidx1
    ON #OUTPUT ([UtilityCode],[DeterminantFieldName],[DeterminantValue])
    with fillfactor = 50

	INSERT INTO DeterminantFieldMapResultants(FieldMapID, ResultantFieldName, ResultantFieldValue)
	SELECT dfm.ID, rt.ResultantName, rt.ResultantValue
	FROM #ResultantsTable rt
	JOIN #OUTPUT dfm on rt.Utility = dfm.UtilityCode AND rt.DeterminantName= dfm.DeterminantFieldName AND rt.DeterminantValue=dfm.DeterminantValue
	
	---- Do the account specific inserts!!
	---- the second join is to filter only those which match on

	CREATE TABLE #TempAccountPropertyHistory (seqid int identity (1,1), UtilityID VARCHAR(80), AccountNumber VARCHAR(50), FieldName VARCHAR(60), FieldValue VARCHAR(200), EffectiveDate DATETIME, FieldSource VARCHAR(60), CreatedBy VARCHAR(256), DateCreated DATETIME, LockStatus VARCHAR(60), ACTIVE BIT)
     
     --If fieldname for the mapping is Utility and the mappingstyle is FillIfNoHistory and no items exist in Determinants history with the account, utility and the tracked field being same as in the account specific field value, insert account specific field value into DeterminantHistory setting FieldSource to MappingAllElseFillDefaultValue
     INSERT INTO #TempAccountPropertyHistory
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingAllElseFillDefaultValue', 'System',@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN		 dbo.AccountPropertyHistory aphDriver	 ON rt.Utility = aphDriver.UtilityID    AND rt.DeterminantName = aphDriver.FieldName   AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	LEFT JOIN	 dbo.AccountPropertyHistory aphResultant ON aphDriver.AccountNumber = aphResultant.AccountNumber AND rt.Utility = aphResultant.UtilityID AND rt.ResultantName = aphResultant.FieldName AND aphResultant.Active = 1	
	WHERE rt.DeterminantName = 'Utility' AND rt.MappingStyle = 'FillIfNoHistory' AND aphResultant.UtilityID IS NULL AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')

	--If fieldname for the mapping is Utility and the mappingstyle is ReplaceValueAlways, insert account specific field value into DeterminantHistory setting FieldSource to MappingAllElseOverwriteAlways
	INSERT INTO #TempAccountPropertyHistory
	        ( UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active)
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingAllElseOverwriteAlways', 'System',@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN dbo.AccountPropertyHistory aphDriver ON rt.Utility = aphDriver.UtilityID AND rt.DeterminantName = aphDriver.FieldName AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	WHERE rt.DeterminantName = 'Utility' AND rt.MappingStyle = 'ReplaceValueAlways' AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
	--If fieldname for the mapping is Utility and the mappingstyle is ReplaceIfValueExists and the resultantfield has an entry for the account, insert account specific field value into DeterminantHistory setting FieldSource to MappingAllElseOverwriteAlways
	INSERT INTO #TempAccountPropertyHistory
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingAllElseOverwriteExisting', 'System',@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN		 dbo.AccountPropertyHistory aphDriver	 ON rt.Utility = aphDriver.UtilityID    AND rt.DeterminantName = aphDriver.FieldName   AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	JOIN	 dbo.AccountPropertyHistory aphResultant ON aphDriver.AccountNumber = aphResultant.AccountNumber AND rt.Utility = aphResultant.UtilityID AND rt.ResultantName = aphResultant.FieldName AND aphResultant.Active = 1	
	WHERE rt.DeterminantName = 'Utility' AND rt.MappingStyle = 'ReplaceIfValueExists' AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
     --If fieldname for the mapping is not Utility and the mappingstyle is FillIfNoHistory and no items exist in Determinants history with the account, utility and the tracked field being same as in the account specific field value, insert account specific field value into DeterminantHistory setting FieldSource to MappingFillDefaultValue
     INSERT INTO #TempAccountPropertyHistory
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingFillDefaultValue', 'System',@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN		 dbo.AccountPropertyHistory aphDriver	 ON rt.Utility = aphDriver.UtilityID    AND rt.DeterminantName = aphDriver.FieldName   AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	LEFT JOIN	 dbo.AccountPropertyHistory aphResultant ON aphDriver.AccountNumber = aphResultant.AccountNumber AND rt.Utility = aphResultant.UtilityID AND rt.ResultantName = aphResultant.FieldName AND aphResultant.Active = 1	
	WHERE rt.DeterminantName <> 'Utility' AND rt.MappingStyle = 'FillIfNoHistory' AND aphResultant.UtilityID IS NULL AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
	--If fieldname for the mapping is not Utility and the mappingstyle is ReplaceValueAlways, insert account specific field value into DeterminantHistory setting FieldSource to MappingOverwriteAlways
	INSERT INTO #TempAccountPropertyHistory
	        ( UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active)
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingOverwriteAlways', 'System',@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN dbo.AccountPropertyHistory aphDriver ON rt.Utility = aphDriver.UtilityID AND rt.DeterminantName = aphDriver.FieldName AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	WHERE rt.DeterminantName <> 'Utility' AND rt.MappingStyle = 'ReplaceValueAlways' AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
	--If fieldname for the mapping is not Utility and the mappingstyle is ReplaceIfValueExists and the resultantfield has an entry for the account, insert account specific field value into DeterminantHistory setting FieldSource to MappingOverwriteExisting
	INSERT INTO #TempAccountPropertyHistory
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingOverwriteExisting', 'System',@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN		 dbo.AccountPropertyHistory aphDriver	 ON rt.Utility = aphDriver.UtilityID    AND rt.DeterminantName = aphDriver.FieldName   AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	JOIN	 dbo.AccountPropertyHistory aphResultant ON aphDriver.AccountNumber = aphResultant.AccountNumber AND rt.Utility = aphResultant.UtilityID AND rt.ResultantName = aphResultant.FieldName AND aphResultant.Active = 1	
	WHERE rt.DeterminantName <> 'Utility' AND rt.MappingStyle = 'ReplaceIfValueExists' AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
	CREATE TABLE #PROPERTYOUTPUT (AccountPropertyHistoryID BIGINT PRIMARY KEY NONCLUSTERED, LockStatus VARCHAR(60), CreatedBy VARCHAR(256), DateCreated DATETIME) 
	
	INSERT INTO dbo.AccountPropertyHistory
	( UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active)
	OUTPUT INSERTED.AccountPropertyHistoryID, INSERTED.LockStatus,INSERTED.CreatedBy, INSERTED.DateCreated INTO #PROPERTYOUTPUT
	SELECT UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active 
	FROM #TempAccountPropertyHistory
	
	INSERT INTO AccountPropertyLockHistory (AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated)
	SELECT AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated
	FROM #PROPERTYOUTPUT	
	
    IF @@ERROR != 0      
		ROLLBACK      
	ELSE      
		COMMIT   
		
	SET NOCOUNT OFF;  
END

GO


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_OfferEngineAccountDeterminants]    Script Date: 05/22/2013 10:07:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_OfferEngineAccountDeterminants]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_OfferEngineAccountDeterminants]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_OfferEngineAccountDeterminants]    Script Date: 05/22/2013 10:07:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_OfferEngineAccountDeterminants
 * Returns old account properties
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_OfferEngineAccountDeterminants] 
AS
BEGIN

SET NOCOUNT ON;

DECLARE @TwoYearsAgo DATETIME
SELECT @TwoYearsAgo=dateadd(year,-2,GETDATE())


SELECT ISNULL(a.UTILITY, '') AS UTILITY,
	ISNULL(a.ACCOUNT_NUMBER, '') AS ACCOUNT_NUMBER,
	ISNULL(a.METER_TYPE, '') AS METER_TYPE ,
	ISNULL(a.RATE_CLASS, '') AS RATE_CLASS ,
	ISNULL(a.VOLTAGE, '') AS VOLTAGE,
	ISNULL(a.ZONE, '') AS ZONE,
	ISNULL(a.LOAD_SHAPE_ID, '') AS LOAD_SHAPE_ID,
	ISNULL(a.LOAD_PROFILE, '')  AS LOAD_PROFILE,
	ISNULL(a.TarrifCode, '')  AS TarrifCode,
	ISNULL(a.Grid, '') AS Grid,
	ISNULL(a.LbmpZone, '') AS LbmpZone,
	ISNULL(a.ICAP, 0) AS ICAP,
	ISNULL(a.TCAP, 0) AS TCAP,
	ISNULL(a.LOSSES, 0) AS Losses,
	EffectiveDate = 
	CASE 
		WHEN a.USAGE_DATE > @TwoYearsAgo THEN a.USAGE_DATE
		ELSE a.DateCreated
	END
	FROM OfferEngineDB..OE_ACCOUNT a WITH (NOLOCK)
	WHERE (a.USAGE_DATE > @TwoYearsAgo OR a.DateCreated >@TwoYearsAgo)
END

SET NOCOUNT OFF;

GO


USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UsageGetMostRecentUsageDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UsageGetMostRecentUsageDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_UsageGetMostRecentUsageDate
 * Gets the most recent usage
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_UsageGetMostRecentUsageDate] 
	@UtilityCode				VARCHAR(50), 
	@AccountNumber			  	VARCHAR(50) 
AS
BEGIN
SET NOCOUNT ON;

DECLARE @EdiDate datetime;
DECLARE @ScraperDate datetime;
DECLARE @UsageFileDate datetime;
DECLARE  @Account VARCHAR(50)

SET @EdiDate = CAST('1/1/1900' AS DateTime)
SET @ScraperDate = CAST('1/1/1900' AS DateTime)
SET @UsageFileDate = CAST('1/1/1900' AS DateTime)

SET @Account = @AccountNumber

SET @UsageFileDate =(SELECT TOP 1  u.ToDate FROM lp_transactions..FileUsage u LEFT JOIN libertypower..Account a ON u.FileAccountID = a.AccountID  WHERE a.AccountNumber =  @Account ORDER BY u.ToDate DESC );

SET @EdiDate =(  SELECT TOP 1  EndDate
    FROM lp_transactions..EdiUsage (nolock) t1 inner join lp_transactions.dbo.EdiAccount (nolock) t2 on t1.ediaccountid = t2.id
    WHERE AccountNumber = @AccountNumber and UtilityCode = @UtilityCode
    ORDER BY EndDate DESC)

IF @UtilityCode = 'AMEREN'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  u.EndDate FROM lp_transactions..AmerenUsage u WITH (NOLOCK) LEFT JOIN libertypower..Account a ON u.AccountID = a.AccountID  WHERE a.AccountNumber =  @Account ORDER BY u.EndDate DESC );
END

IF @UtilityCode = 'BGE'
BEGIN
   SET @ScraperDate  = (SELECT TOP 1  u.EndDate FROM lp_transactions..BgeUsage u WITH (NOLOCK) WHERE AccountNumber =  @Account ORDER BY u.EndDate DESC );
END

IF @UtilityCode = 'CENHUD'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..CenhudUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'CMP'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..CmpUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'COMED'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..ComedUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'CONED'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  ToDate FROM lp_transactions..ConedUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'NIMO'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..NimoUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'NYSEG'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..NysegUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'PECO'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  ToDate FROM lp_transactions..PecoUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'RGE'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..RgeUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @ScraperDate IS NULL  SET @ScraperDate = CAST('1/1/1900' AS DateTime);
IF @EdiDate IS NULL  SET @EdiDate = CAST('1/1/1980' AS DateTime);
IF @UsageFileDate IS NULL  SET @UsageFileDate = CAST('1/1/1900' AS DateTime);

DECLARE @MOST_RECENT dateTime;
IF @ScraperDate > @EdiDate 
BEGIN
    SET @MOST_RECENT = @ScraperDate 
END
ELSE 
BEGIN
    SET @MOST_RECENT = @EdiDate
END

IF @MOST_RECENT < @UsageFileDate 
BEGIN
    SET @MOST_RECENT = @UsageFileDate
END

SELECT @MOST_RECENT as MostRecentUsage

SET NOCOUNT OFF;
END





            



















GO
USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_UtilityAndMarketsSelect]    Script Date: 07/13/2013 14:15:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UtilityAndMarketsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_UtilityAndMarketsSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_UtilityAndMarketsSelect]    Script Date: 07/13/2013 14:15:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_UtilityAndMarketsSelect
 * Gets active utilities
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityAndMarketsSelect]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.ID AS UtilityID ,
           u.UtilityCode ,
           m.ID AS RetailMarketID ,
           m.MarketCode ,
           w.WholesaleMktId
      FROM
           libertypower..Utility u WITH ( NOLOCK ) JOIN libertypower..Market m WITH ( NOLOCK )
           ON u.MarketID = m.ID
                                                   JOIN libertypower..WholesaleMarket w WITH ( NOLOCK )
           ON w.ID = m.WholesaleMktId
      WHERE m.InactiveInd = 0
      ORDER BY u.UtilityCode;
    SET NOCOUNT OFF;
END;

GO


USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityClassMappingDeterminantsSelectAll]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityClassMappingDeterminantsSelectAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_UtilityClassMappingDeterminantsSelectAll
 * Gets utility class mapping determinants 
 *
 * History
 *******************************************************************************/

CREATE PROCEDURE [dbo].[usp_UtilityClassMappingDeterminantsSelectAll]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, UtilityID, Driver
    FROM	UtilityClassMappingDeterminants WITH (NOLOCK)


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityClassMappingInsert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityClassMappingInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityClassMappingInsert
 * Inserts utility class mapping record
 *
 * History
 *******************************************************************************
 * 12/3/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingInsert]
	@UtilityID			int,
	@AccountTypeID		int,	
	@MeterTypeID		int,
	@VoltageID			int,	
	@RateClassCode		varchar(50),
	@ServiceClassCode	varchar(50),
	@LoadProfileCode	varchar(50),
	@LoadShapeCode		varchar(50),
	@TariffCode			varchar(50),
	@Losses				decimal(20,16) = NULL,
	@Zone				varchar(50),
	@IsActive			tinyint,
     @RuleType int = 0,
     @Icap decimal(20,5) = NULL,
	@Tcap decimal(20,5) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE	@RateClassID	int,
			@ServiceClassID	int,
			@LoadProfileID	int,
			@LoadShapeID	int,
			@TariffID		int,
			@ZoneID 		int
			
	SELECT @RateClassID = ID FROM RateClass WITH (NOLOCK) WHERE RateClassCode = @RateClassCode			
	IF @RateClassID IS NULL
		BEGIN
			INSERT INTO RateClass (RateClassCode) VALUES (@RateClassCode)
			SET @RateClassID = SCOPE_IDENTITY()
		END
    
    SELECT @ServiceClassID = ID FROM ServiceClass WITH (NOLOCK) WHERE ServiceClassCode = @ServiceClassCode
	IF @ServiceClassID IS NULL
		BEGIN
			INSERT INTO ServiceClass (ServiceClassCode) VALUES (@ServiceClassCode)
			SET @ServiceClassID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadProfileID = ID FROM LoadProfile WITH (NOLOCK) WHERE LoadProfileCode = @LoadProfileCode
	IF @LoadProfileID IS NULL
		BEGIN
			INSERT INTO LoadProfile (LoadProfileCode) VALUES (@LoadProfileCode)
			SET @LoadProfileID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadShapeID = ID FROM LoadShape WITH (NOLOCK) WHERE LoadShapeCode = @LoadShapeCode
	IF @LoadShapeID IS NULL
		BEGIN
			INSERT INTO LoadShape (LoadShapeCode) VALUES (@LoadShapeCode)
			SET @LoadShapeID = SCOPE_IDENTITY()
		END
    
    SELECT @TariffID = ID FROM TariffCode WITH (NOLOCK) WHERE Code = @TariffCode
	IF @TariffID IS NULL
		BEGIN
			INSERT INTO TariffCode (Code) VALUES (@TariffCode)
			SET @TariffID = SCOPE_IDENTITY()
		END
			
	SELECT 
		@ZoneID = Z.ID 
	FROM 
		Zone Z WITH (NOLOCK) 
		Inner Join UtilityZone UZ WITH (NOLOCK) 
		On Z.ID = UZ.ZoneID
	WHERE 
		Z.ZoneCode = @Zone And
		UZ.UtilityID = @UtilityID
	
	IF @ZoneID IS NULL
		BEGIN
			INSERT INTO Zone (ZoneCode) VALUES (@Zone)
			SET @ZoneID = SCOPE_IDENTITY()
		END
     
    INSERT INTO	UtilityClassMapping (UtilityID, AccountTypeID, MeterTypeID, VoltageID, 
				RateClassID, ServiceClassID, LoadProfileID, LoadShapeID, TariffCodeID, 
				LossFactor, ZoneID, IsActive, RuleType, Icap, Tcap)
	VALUES		(@UtilityID, @AccountTypeID, @MeterTypeID, @VoltageID, 
				@RateClassID, @ServiceClassID, @LoadProfileID, @LoadShapeID, @TariffID, 
				@Losses, @ZoneID, @IsActive, @RuleType, @Icap, @Tcap)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityClassMappingSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityClassMappingSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_UtilityClassMappingSelect
 * Gets all utility class mappings
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,m.ZoneID,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, u.UtilityCode,
			z.ZoneCode, m.RuleType
    FROM	UtilityClassMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..RateClass r WITH (NOLOCK) ON m.RateClassID = r.ID
			LEFT JOIN LibertyPower..ServiceClass s WITH (NOLOCK) ON m.ServiceClassID = s.ID
			LEFT JOIN LibertyPower..LoadProfile p on m.LoadProfileID = p.ID
			LEFT JOIN LibertyPower..LoadShape l WITH (NOLOCK) ON m.LoadShapeID = l.ID	
			LEFT JOIN LibertyPower..TariffCode t WITH (NOLOCK) ON m.TariffCodeID = t.ID		
			LEFT JOIN LibertyPower..Voltage v WITH (NOLOCK) ON m.VoltageID = v.ID
			LEFT JOIN LibertyPower..MeterType mt WITH (NOLOCK) ON m.MeterTypeID = mt.ID
			LEFT JOIN LibertyPower..AccountType at WITH (NOLOCK) ON m.AccountTypeID = at.ID	
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON m.ZoneID = z.ID
    ORDER BY u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityClassMappingUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityClassMappingUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityClassMappingUpdate
 * Updates utility class mapping for specified record identity,
 * inserting new values into corresponding tables, if any.
 *
 * History
 *******************************************************************************
 * 12/3/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingUpdate]
	@ID					int,
	@UtilityID			int,
	@AccountTypeID		int,	
	@MeterTypeID		int,
	@VoltageID			int,	
	@RateClassCode		varchar(50),
	@ServiceClassCode	varchar(50),
	@LoadProfileCode	varchar(50),
	@LoadShapeCode		varchar(50),
	@TariffCode			varchar(50),
	@Losses				decimal(20,16) = NULL,
	@Zone				varchar(50),
	@IsActive			tinyint,
     @RuleType int = 0,
     @Icap decimal(20, 5) = NULL,
	@Tcap decimal(20, 5) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE	@RateClassID	int,
			@ServiceClassID	int,
			@LoadProfileID	int,
			@LoadShapeID	int,
			@TariffID		int,
			@ZoneID		    int 
			
	SELECT @RateClassID = ID FROM RateClass WITH (NOLOCK) WHERE RateClassCode = @RateClassCode			
	IF @RateClassID IS NULL
		BEGIN
			INSERT INTO RateClass (RateClassCode) VALUES (@RateClassCode)
			SET @RateClassID = SCOPE_IDENTITY()
		END
    
    SELECT @ServiceClassID = ID FROM ServiceClass WITH (NOLOCK) WHERE ServiceClassCode = @ServiceClassCode
	IF @ServiceClassID IS NULL
		BEGIN
			INSERT INTO ServiceClass (ServiceClassCode) VALUES (@ServiceClassCode)
			SET @ServiceClassID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadProfileID = ID FROM LoadProfile WITH (NOLOCK) WHERE LoadProfileCode = @LoadProfileCode
	IF @LoadProfileID IS NULL
		BEGIN
			INSERT INTO LoadProfile (LoadProfileCode) VALUES (@LoadProfileCode)
			SET @LoadProfileID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadShapeID = ID FROM LoadShape WITH (NOLOCK) WHERE LoadShapeCode = @LoadShapeCode
	IF @LoadShapeID IS NULL
		BEGIN
			INSERT INTO LoadShape (LoadShapeCode) VALUES (@LoadShapeCode)
			SET @LoadShapeID = SCOPE_IDENTITY()
		END
    
    SELECT @TariffID = ID FROM TariffCode WITH (NOLOCK) WHERE Code = @TariffCode
	IF @TariffID IS NULL
		BEGIN
			INSERT INTO TariffCode (Code) VALUES (@TariffCode)
			SET @TariffID = SCOPE_IDENTITY()
		END
    
    SELECT 
		@ZoneID = Z.ID 
	FROM 
		Zone Z WITH (NOLOCK) 
		Inner Join UtilityZone UZ WITH (NOLOCK) 
		On Z.ID = UZ.ZoneID
	WHERE 
		Z.ZoneCode = @Zone And
		UZ.UtilityID = @UtilityID
		
	IF @ZoneID IS NULL
		BEGIN
			INSERT INTO Zone (ZoneCode) VALUES (@Zone)
			SET @ZoneID = SCOPE_IDENTITY()
		END
		
    UPDATE	UtilityClassMapping
	SET		AccountTypeID	= @AccountTypeID,
			MeterTypeID		= @MeterTypeID,
			VoltageID		= @VoltageID,
			RateClassID		= @RateClassID,
			ServiceClassID	= @ServiceClassID,
			LoadProfileID	= @LoadProfileID,
			LoadShapeID		= @LoadShapeID,
			TariffCodeID	= @TariffID,
			LossFactor		= @Losses,
			ZoneID			= @ZoneID,
			IsActive		= @IsActive,
			RuleType = @RuleType,
			ICap = @Icap,
			 TCap = @Tcap
    WHERE	ID				= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityMappingByUtilityIDSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityMappingByUtilityIDSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_UtilityMappingByUtilityIDSelect
 * Gets the utility mappings for specified utility
 *
 * History
 *******************************************************************************
 * 11/19/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityMappingByUtilityIDSelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, 
			u.UtilityCode, u.FullName AS UtilityFullName, u.MarketID, mkt.MarketCode, m.IsActive,m.ZoneID,z.ZoneCode, m.RuleType, m.Icap, m.Tcap
    FROM	UtilityClassMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..RateClass r WITH (NOLOCK) ON m.RateClassID = r.ID
			LEFT JOIN LibertyPower..ServiceClass s WITH (NOLOCK) ON m.ServiceClassID = s.ID
			LEFT JOIN LibertyPower..LoadProfile p on m.LoadProfileID = p.ID
			LEFT JOIN LibertyPower..LoadShape l WITH (NOLOCK) ON m.LoadShapeID = l.ID	
			LEFT JOIN LibertyPower..TariffCode t WITH (NOLOCK) ON m.TariffCodeID = t.ID		
			LEFT JOIN LibertyPower..Voltage v WITH (NOLOCK) ON m.VoltageID = v.ID
			LEFT JOIN LibertyPower..MeterType mt WITH (NOLOCK) ON m.MeterTypeID = mt.ID
			LEFT JOIN LibertyPower..AccountType at WITH (NOLOCK) ON m.AccountTypeID = at.ID	
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON z.ID = m.ZoneID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
    WHERE	m.UtilityID = @UtilityID
    ORDER BY mkt.MarketCode, u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityMappingSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityMappingSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_UtilityMappingSelect
 * Gets all utility mappings
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityMappingSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, 
			u.UtilityCode, u.FullName AS UtilityFullName, u.MarketID, mkt.MarketCode, m.IsActive,m.ZoneID,z.ZoneCode, m.RuleType, m.Icap, m.Tcap
	FROM	LibertyPower..UtilityClassMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..RateClass r WITH (NOLOCK) ON m.RateClassID = r.ID
			LEFT JOIN LibertyPower..ServiceClass s WITH (NOLOCK) ON m.ServiceClassID = s.ID
			LEFT JOIN LibertyPower..LoadProfile p on m.LoadProfileID = p.ID
			LEFT JOIN LibertyPower..LoadShape l WITH (NOLOCK) ON m.LoadShapeID = l.ID	
			LEFT JOIN LibertyPower..TariffCode t WITH (NOLOCK) ON m.TariffCodeID = t.ID		
			LEFT JOIN LibertyPower..Voltage v WITH (NOLOCK) ON m.VoltageID = v.ID
			LEFT JOIN LibertyPower..MeterType mt WITH (NOLOCK) ON m.MeterTypeID = mt.ID
			LEFT JOIN LibertyPower..AccountType at WITH (NOLOCK) ON m.AccountTypeID = at.ID	
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON m.ZoneID = z.ID
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID		
	ORDER BY mkt.MarketCode, u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityZoneMappingByUtilityIDSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_UtilityZoneMappingByUtilityIDSelect
 * Gets the utility zone mappings for specified utility
 *
 * History
 *******************************************************************************
 * 11/19/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, uz.ZoneID, z.ZoneCode, u.UtilityCode, Grid, LBMPZone, 
			LossFactor, u.MarketID, mkt.MarketCode, m.IsActive, m.RuleType
    FROM	UtilityZoneMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..UtilityZone uz WITH (NOLOCK) ON m.UtilityZoneID = uz.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON uz.ZoneID = z.ID
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
    WHERE	m.UtilityID = @UtilityID
    ORDER BY mkt.MarketCode, u.UtilityCode, z.ZoneCode, LossFactor

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityZoneMappingInsert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityZoneMappingInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityZoneMappingInsert
 * Inserts utility zone mapping record
 *
 * History
 *******************************************************************************
 * 12/6/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingInsert]
	@UtilityID	int,	
	@ZoneID		int,
	@Grid		varchar(50),
	@LbmpZone	varchar(50),
	@Losses		decimal(20,16) = NULL,	
	@IsActive	tinyint,
     @RuleType int = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@UtilityZoneID	int
    
    SELECT	@UtilityZoneID	= ID
    FROM	UtilityZone WITH (NOLOCK)
    WHERE	UtilityID		= @UtilityID
    AND		ZoneID			= @ZoneID
    
    IF @UtilityZoneID IS NULL
		BEGIN
			INSERT INTO UtilityZone (UtilityID, ZoneID)
			VALUES		(@UtilityID, @ZoneID)
			
			SET	@UtilityZoneID = SCOPE_IDENTITY()
		END
     
    INSERT INTO	UtilityZoneMapping (UtilityID, Grid, LBMPZone, LossFactor, IsActive, UtilityZoneID, RuleType)
	VALUES		(@UtilityID, @Grid, @LbmpZone, @Losses, @IsActive, @UtilityZoneID, @RuleType)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityZoneMappingSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityZoneMappingSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityZoneMappingSelect
 * Gets all utility zone mappings
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, uz.ZoneID, z.ZoneCode, u.UtilityCode, Grid, LBMPZone, 
			LossFactor, u.MarketID, mkt.MarketCode, m.IsActive, m.RuleType
    FROM	UtilityZoneMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..UtilityZone uz WITH (NOLOCK) ON m.UtilityZoneID = uz.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON uz.ZoneID = z.ID
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
    ORDER BY mkt.MarketCode, u.UtilityCode, z.ZoneCode, LossFactor

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO
USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityZoneMappingUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityZoneMappingUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityZoneMappingUpdate
 * Updates utility zone mapping record
 *
 * History
 *******************************************************************************
 * 12/6/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingUpdate]
	@ID			int,
	@UtilityID	varchar(50),	
	@ZoneID		int,
	@Grid		varchar(50),
	@LbmpZone	varchar(50),
	@Losses		decimal(20,16) = NULL,
	@IsActive	tinyint,
     @RuleType int = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@UtilityZoneID	int
    
    SELECT	@UtilityZoneID	= ID
    FROM	UtilityZone WITH (NOLOCK)
    WHERE	UtilityID		= @UtilityID
    AND		ZoneID			= @ZoneID
    
    IF @UtilityZoneID IS NULL
		BEGIN
			INSERT INTO UtilityZone (UtilityID, ZoneID)
			VALUES		(@UtilityID, @ZoneID)
			
			SET	@UtilityZoneID = SCOPE_IDENTITY()
		END    
     
    UPDATE	UtilityZoneMapping
    SET		Grid			= @Grid, 
			LBMPZone		= @LbmpZone, 
			LossFactor		= @Losses,
			IsActive		= @IsActive,
			UtilityZoneID	 = @UtilityZoneID,
			RuleType = @RuleType
	WHERE	ID				= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_VRE_GetCurveFiles]    Script Date: 04/01/2013 10:42:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_VRE_GetCurveFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_VRE_GetCurveFiles]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_VRE_GetCurveFiles]    Script Date: 04/01/2013 10:42:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Jaime Forero
-- Create date: 7/29/2010
-- Description:	gets all the file contexts for all the curve files of INF82
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_GetCurveFiles]
	@CurveFileType VARCHAR(50) = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	IF @StartDate IS NULL
		SET @StartDate = CAST('2000-01-01' AS DATETIME);
	
	IF @EndDate IS NULL
		SET @EndDate =  DATEADD(YEAR,10,GETDATE());
		
	DECLARE @tempCurveFiles TABLE 
	(
		FileContextGUID UNIQUEIDENTIFIER,
		OriginalFileName VARCHAR(256),
		CurveFileType VARCHAR(50),
		DateCreated DATETIME,
		CreatedBy INT,
		FirstName VARCHAR(50),
		LastName VARCHAR(50),
		NumRecords INT
	);

	IF @CurveFileType IS NULL OR @CurveFileType = 'ARCreditReservePercent'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
				SELECT C.FileContextGUID,'ARCreditReservePercent', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
				FROM VREARCreditReservePercent C WITH (NOLOCK)
				JOIN [User] U ON C.CreatedBy = U.UserID
				GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'CaisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'CaisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRECaisoDayAhead C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'CapacityTransmissionFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'CapacityTransmissionFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRECapacityTransmissionFactor C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'HourlyProfiles'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'HourlyProfiles', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREHourlyProfile C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'Markup'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'Markup', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREMarkupCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'MisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'MisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREMisoDayAhead C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'NeisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'NeisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRENeisoDayAhead C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'NyisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'NyisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRENyisoDayAhead C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'PjmPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'PjmPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPjmDayAhead C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;

	IF @CurveFileType IS NULL OR @CurveFileType = 'AncillaryServices'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'AncillaryServices', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREAncillaryServicesCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
    IF @CurveFileType IS NULL OR @CurveFileType = 'AuctionRevenueRightPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'AuctionRevenueRightPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREAuctionRevenueRightPriceCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	 -------------------------------------------------------------------------
	IF @CurveFileType IS NULL OR @CurveFileType = 'BillingTransactionCost'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'BillingTransactionCost', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREBillingTransactionCostCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'FinanceFee'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'FinanceFee', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREFinanceFeeCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'LossFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'LossFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRELossFactorItemDataCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'POR'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'POR', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPorDataCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'RenewablePortfolioStandardPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'RenewablePortfolioStandardPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRERenewablePortfolioStandardPriceCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'TCapFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'TCapFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRETCapFactorCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'TCapPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'TCapPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRETCapPriceCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'UCapFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'UCapFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREUCapFactorCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'UCapPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'UCapPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREUCapPriceCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	-------------------------------------------------------------------------------
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'DailyProfile'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'DailyProfile', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREDailyProfileCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'PromptEnergyPriceCurve'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'PromptEnergyPriceCurve', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPromptEnergyPriceCurveHeader C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'RUCSettlementCurve'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'RUCSettlementCurve', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRERUCSettlementCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'ShapingFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'ShapingFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREShapingFactorCurve C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'SupplierPremiumFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'SupplierPremiumFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRESupplierPremiumCurveHeader C WITH (NOLOCK)
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	
	SELECT * FROM @tempCurveFiles
	WHERE  DateCreated BETWEEN @StartDate AND @EndDate;	
	
	
END




GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'VRE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'usp_VRE_GetCurveFiles'
GO


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_VRE_ServiceClassMapInsert]    Script Date: 03/22/2013 11:34:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_VRE_ServiceClassMapInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_VRE_ServiceClassMapInsert]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_VRE_ServiceClassMapInsert]    Script Date: 03/22/2013 11:34:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_VRE_ServiceClassMapInsert]
(
 @UtilityCode varchar(50) ,
 @ServiceClass varchar(50),
 @RawServiceClass varchar(50) ) 
AS
SET NOCOUNT ON


UPDATE VRE_ServiceClassMapping 
SET IsActive = 0 
WHERE UtilityCode = @UtilityCode AND RawServiceClass = @RawServiceClass

INSERT INTO VRE_ServiceClassMapping (UtilityCode, ServiceClass,  RawServiceClass)
VALUES(@UtilityCode, @ServiceClass,  @RawServiceClass)

SELECT
    ID , UtilityCode, ServiceClass , RawServiceClass, DateCreated , CreatedBy , DateModified , ModifiedBy
FROM
    VRE_ServiceClassMapping  WITH (NOLOCK)
WHERE
    IsActive = 1
    
SET NOCOUNT OFF

GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'VRE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'usp_VRE_ServiceClassMapInsert'
GO


