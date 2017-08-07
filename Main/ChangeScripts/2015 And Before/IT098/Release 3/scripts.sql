/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[IdrFileLogHeader], [dbo].[IdrUtilityRawParser]

     Make VM3LPCNOCSQL1.lp_transactions Equal (local)\MSSQL2008R2.Lp_transactions

   AUTHOR:	[Insert Author Name]

   DATE:	1/7/2013 2:58:29 PM

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
SET ANSI_PADDING ON
GO
USE [lp_transactions]
GO

BEGIN TRAN
GO

-- Drop Default Constraint DF_IdrUtilityRawParser_IsDefault from [dbo].[IdrUtilityRawParser]
Print 'Drop Default Constraint DF_IdrUtilityRawParser_IsDefault from [dbo].[IdrUtilityRawParser]'
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_IdrUtilityRawParser_IsDefault]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[IdrUtilityRawParser] DROP CONSTRAINT [DF_IdrUtilityRawParser_IsDefault]
END

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Column FormatType from [dbo].[IdrUtilityRawParser]
Print 'Drop Column FormatType from [dbo].[IdrUtilityRawParser]'
GO
ALTER TABLE [dbo].[IdrUtilityRawParser] DROP COLUMN [FormatType]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Column IsDefault from [dbo].[IdrUtilityRawParser]
Print 'Drop Column IsDefault from [dbo].[IdrUtilityRawParser]'
GO
ALTER TABLE [dbo].[IdrUtilityRawParser] DROP COLUMN [IsDefault]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Column IsARawFile to [dbo].[IdrFileLogHeader]
Print 'Add Column IsARawFile to [dbo].[IdrFileLogHeader]'
GO
ALTER TABLE [dbo].[IdrFileLogHeader]
	ADD [IsARawFile] [bit] NULL
	CONSTRAINT [DF_IdrFileLogHeader_IsARawFile] DEFAULT ((0)) WITH VALUES
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Column IsAccountNumberInFile to [dbo].[IdrUtilityRawParser]
Print 'Add Column IsAccountNumberInFile to [dbo].[IdrUtilityRawParser]'
GO
ALTER TABLE [dbo].[IdrUtilityRawParser]
	ADD [IsAccountNumberInFile] [bit] NOT NULL
	CONSTRAINT [DF_IdrUtilityRawParser_IsAccountInfile] DEFAULT ((0))
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Column FileStartstWith to [dbo].[IdrUtilityRawParser]
Print 'Add Column FileStartstWith to [dbo].[IdrUtilityRawParser]'
GO
ALTER TABLE [dbo].[IdrUtilityRawParser]
	ADD [FileStartstWith] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF


--
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_IdrNonEdiDetail_IdrNonEdiDetailIntervals]') AND parent_object_id = OBJECT_ID(N'[dbo].[IdrNonEdiDetail]'))
	ALTER TABLE [dbo].[IdrNonEdiDetail] DROP CONSTRAINT [FK_IdrNonEdiDetail_IdrNonEdiDetailIntervals]
GO
ALTER TABLE dbo.IdrNonEdiDetail ADD
	Intervals varchar(MAX) NULL
GO
COMMIT

update	IdrNonEdiDetail
set		Intervals = it.Intervals
-- select *
from	IdrNonEdiDetail (nolock) dt
		inner join	IdrNonEdiDetailIntervals (nolock) it on dt.IntervalsId = it.Id

BEGIN TRANSACTION
ALTER TABLE dbo.IdrNonEdiDetail
	DROP COLUMN IntervalsId
GO
COMMIT

update IdrFileLogHeader set IsARawFile = 1

--
-- select * from IdrUtilityRawParser order by 4
truncate table IdrUtilityRawParser
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (1,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.AepceSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (2,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.AepnoSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (11,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.AmerenSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (12,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolBangorSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (27,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolNstarBosSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (28,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolNstarCambSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (14,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NyCenhudSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (15,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolClAndPSingleParser',0,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (16,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolCmpSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (17,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmComedSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (29,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolNstarCommSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (18,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.ConedSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (3,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.CtpenSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (21,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.DuqSingleParser',0,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (23,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolMecoSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (24,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolNantSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (25,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolNecoSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (26,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NyNimoSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (30,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NySegSingleParser',0,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (30,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NySegMultipleParser',1,'Date')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (31,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NyOAndRMultipleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (5,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.OncorSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (33,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.OrnjMultipleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (38,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PSegMultiple15Parser',0,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (38,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PSegMultiple30Parser',0,'Sip/Channel')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (36,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.CaisoPgeSingleParser',1,'Request ID')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (34,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PepcoDcSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (35,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PepcoMdSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (39,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NyRgeSingleParser',0,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (41,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.SceSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (42,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.SdgeSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (4,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.TxnmpSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (46,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolUiSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (47,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolUnitilSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (22,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.JcplHorizontalSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (50,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PenelecHorizontalSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (51,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PennprHorizontalSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (10,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.AllegmdHorizontalSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (56,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.WppHorizontalSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (64,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.OhedHorizontalSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (39,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.RgeMultipleParser',1,'Date')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (49,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.MetedHorizontalSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (13,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.BgeSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (9,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmAceSingle15Parser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (9,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmAceSingle60Parser',1,'Account,Date,Channel,Units,1:00')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (19,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmDeldeSingle15Parser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (19,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmDeldeSingle60Parser',1,'Account,Date,Channel,Units,1:00')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (20,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmDelmdSingle15Parser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (20,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmDelmdSingle60Parser',1,'Account,Date,Channel,Units,1:00')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (37,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PplSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (22,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.JcplVerticalSingleParser',0,'Date')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (45,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.UgiSingleParser',1,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (50,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PenelecVerticalSingleParser',0,'Date')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (48,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.NepoolWmecoSingleParser',0,NULL)
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (61,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.DaytonParser',1,'ACCOUNT NAME:')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (36,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.CaisoPgeSingleParser1',1,'"Channel Id"')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (36,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.CaisoPgeSingleParser1',1,'Channel Id')
insert into IdrUtilityRawParser (UtilityId,ParserType,IsAccountNumberInFile,FileStartstWith) values (33,'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.ConedSingleParser',1,'Customer Account')

update utility set WholeSaleMktID = 'NYISO' where id = 14
