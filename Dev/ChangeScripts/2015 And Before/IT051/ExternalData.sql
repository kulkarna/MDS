USE [LibertyPower]
GO

/****** Object:  Table [dbo].[MtMIntraday]    Script Date: 06/17/2011 13:56:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/**************************************** MtMIntraday ***********************************************/

CREATE TABLE [dbo].[MtMIntraday](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileLogID] [int] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[UsageDate] [datetime] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[Int1] [decimal](6, 2) NULL,
	[Int2] [decimal](6, 2) NULL,
	[Int3] [decimal](6, 2) NULL,
	[Int4] [decimal](6, 2) NULL,
	[Int5] [decimal](6, 2) NULL,
	[Int6] [decimal](6, 2) NULL,
	[Int7] [decimal](6, 2) NULL,
	[Int8] [decimal](6, 2) NULL,
	[Int9] [decimal](6, 2) NULL,
	[Int10] [decimal](6, 2) NULL,
	[Int11] [decimal](6, 2) NULL,
	[Int12] [decimal](6, 2) NULL,
	[Int13] [decimal](6, 2) NULL,
	[Int14] [decimal](6, 2) NULL,
	[Int15] [decimal](6, 2) NULL,
	[Int16] [decimal](6, 2) NULL,
	[Int17] [decimal](6, 2) NULL,
	[Int18] [decimal](6, 2) NULL,
	[Int19] [decimal](6, 2) NULL,
	[Int20] [decimal](6, 2) NULL,
	[Int21] [decimal](6, 2) NULL,
	[Int22] [decimal](6, 2) NULL,
	[Int23] [decimal](6, 2) NULL,
	[Int24] [decimal](6, 2) NULL,
	[TimeInserted] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMIntraday] ADD  CONSTRAINT [DF_MtMIntraday_TimeInserted]  DEFAULT (getdate()) FOR [TimeInserted]
GO




/**************************************** MtMLossFactors ***********************************************/

CREATE TABLE [dbo].[MtMLossFactors](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileLogID] [int] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[UsageDate] [datetime] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Utility] [varchar](50) NOT NULL,
	[Int1] [decimal](6, 2) NULL,
	[Int2] [decimal](6, 2) NULL,
	[Int3] [decimal](6, 2) NULL,
	[Int4] [decimal](6, 2) NULL,
	[Int5] [decimal](6, 2) NULL,
	[Int6] [decimal](6, 2) NULL,
	[Int7] [decimal](6, 2) NULL,
	[Int8] [decimal](6, 2) NULL,
	[Int9] [decimal](6, 2) NULL,
	[Int10] [decimal](6, 2) NULL,
	[Int11] [decimal](6, 2) NULL,
	[Int12] [decimal](6, 2) NULL,
	[Int13] [decimal](6, 2) NULL,
	[Int14] [decimal](6, 2) NULL,
	[Int15] [decimal](6, 2) NULL,
	[Int16] [decimal](6, 2) NULL,
	[Int17] [decimal](6, 2) NULL,
	[Int18] [decimal](6, 2) NULL,
	[Int19] [decimal](6, 2) NULL,
	[Int20] [decimal](6, 2) NULL,
	[Int21] [decimal](6, 2) NULL,
	[Int22] [decimal](6, 2) NULL,
	[Int23] [decimal](6, 2) NULL,
	[Int24] [decimal](6, 2) NULL,
	[TimeInserted] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMLossFactors] ADD  CONSTRAINT [DF_MtMLossFactors_TimeInserted]  DEFAULT (getdate()) FOR [TimeInserted]
GO

/**************************************** [MtMLossFactorsType *******************************************/
CREATE TABLE [dbo].[MtMLossFactorsType](
	[ID] [tinyint] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_MtMLossFactorsType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO [MtMLossFactorsType] VALUES ('Primary')
GO
INSERT INTO [MtMLossFactorsType] VALUES ('Secondary')
GO
INSERT INTO [MtMLossFactorsType] VALUES ('Transmission')
GO
INSERT INTO [MtMLossFactorsType] VALUES ('Sub-Transmission')
GO

/**************************************** MtMShaping ***********************************************/

CREATE TABLE [dbo].[MtMShaping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileLogID] [int] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[UsageDate] [datetime] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[Int1] [decimal](6, 2) NULL,
	[Int2] [decimal](6, 2) NULL,
	[Int3] [decimal](6, 2) NULL,
	[Int4] [decimal](6, 2) NULL,
	[Int5] [decimal](6, 2) NULL,
	[Int6] [decimal](6, 2) NULL,
	[Int7] [decimal](6, 2) NULL,
	[Int8] [decimal](6, 2) NULL,
	[Int9] [decimal](6, 2) NULL,
	[Int10] [decimal](6, 2) NULL,
	[Int11] [decimal](6, 2) NULL,
	[Int12] [decimal](6, 2) NULL,
	[Int13] [decimal](6, 2) NULL,
	[Int14] [decimal](6, 2) NULL,
	[Int15] [decimal](6, 2) NULL,
	[Int16] [decimal](6, 2) NULL,
	[Int17] [decimal](6, 2) NULL,
	[Int18] [decimal](6, 2) NULL,
	[Int19] [decimal](6, 2) NULL,
	[Int20] [decimal](6, 2) NULL,
	[Int21] [decimal](6, 2) NULL,
	[Int22] [decimal](6, 2) NULL,
	[Int23] [decimal](6, 2) NULL,
	[Int24] [decimal](6, 2) NULL,
	[TimeInserted] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMShaping] ADD  CONSTRAINT [DF_MtMShaping_TimeInserted]  DEFAULT (getdate()) FOR [TimeInserted]
GO



/**************************************** MtMSupplierHours ***********************************************/

CREATE TABLE [dbo].[MtMSupplierHours](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileLogID] [int] NOT NULL,
	[UsageDate] [datetime] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[DayType] [tinyint] NOT NULL,
	[TimeInserted] [datetime] NOT NULL,
 CONSTRAINT [PK_MtMSupplierHours] PRIMARY KEY CLUSTERED 
(
	[FileLogID] ASC,
	[UsageDate] ASC,
	[ISO] ASC,
	[DayType]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MtMSupplierHours] ADD  CONSTRAINT [DF_MtMSupplierHours_TimeInserted]  DEFAULT (getdate()) FOR [TimeInserted]

GO

/**************************************** MtMDayType ***********************************************/

CREATE TABLE [dbo].[MtMDayType](
	[ID] [tinyint] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MtMMtMDayType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT	INTO [MtMDayType]	VALUES	('Peak')
GO

INSERT	INTO [MtMDayType]	VALUES	('Off-Peak')
GO

INSERT	INTO [MtMDayType]	VALUES	('Off-Peak Holiday')
GO

/**************************************** MtMSupplierPremiums ***********************************************/

CREATE TABLE [dbo].[MtMSupplierPremiums](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileLogID] [int] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[UsageDate] [datetime] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[Int1] [decimal](6, 2) NULL,
	[Int2] [decimal](6, 2) NULL,
	[Int3] [decimal](6, 2) NULL,
	[Int4] [decimal](6, 2) NULL,
	[Int5] [decimal](6, 2) NULL,
	[Int6] [decimal](6, 2) NULL,
	[Int7] [decimal](6, 2) NULL,
	[Int8] [decimal](6, 2) NULL,
	[Int9] [decimal](6, 2) NULL,
	[Int10] [decimal](6, 2) NULL,
	[Int11] [decimal](6, 2) NULL,
	[Int12] [decimal](6, 2) NULL,
	[Int13] [decimal](6, 2) NULL,
	[Int14] [decimal](6, 2) NULL,
	[Int15] [decimal](6, 2) NULL,
	[Int16] [decimal](6, 2) NULL,
	[Int17] [decimal](6, 2) NULL,
	[Int18] [decimal](6, 2) NULL,
	[Int19] [decimal](6, 2) NULL,
	[Int20] [decimal](6, 2) NULL,
	[Int21] [decimal](6, 2) NULL,
	[Int22] [decimal](6, 2) NULL,
	[Int23] [decimal](6, 2) NULL,
	[Int24] [decimal](6, 2) NULL,
	[TimeInserted] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMSupplierPremiums] ADD  CONSTRAINT [DF_MtMSupplierPremiums_TimeInserted]  DEFAULT (getdate()) FOR [TimeInserted]
GO


/**************************************** MtMEnergyCurves ***********************************************/
CREATE TABLE [dbo].[MtMEnergyCurves](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileLogID] [int] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[UsageDate] [datetime] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[Int1] [decimal](6, 2) NULL,
	[Int2] [decimal](6, 2) NULL,
	[Int3] [decimal](6, 2) NULL,
	[Int4] [decimal](6, 2) NULL,
	[Int5] [decimal](6, 2) NULL,
	[Int6] [decimal](6, 2) NULL,
	[Int7] [decimal](6, 2) NULL,
	[Int8] [decimal](6, 2) NULL,
	[Int9] [decimal](6, 2) NULL,
	[Int10] [decimal](6, 2) NULL,
	[Int11] [decimal](6, 2) NULL,
	[Int12] [decimal](6, 2) NULL,
	[Int13] [decimal](6, 2) NULL,
	[Int14] [decimal](6, 2) NULL,
	[Int15] [decimal](6, 2) NULL,
	[Int16] [decimal](6, 2) NULL,
	[Int17] [decimal](6, 2) NULL,
	[Int18] [decimal](6, 2) NULL,
	[Int19] [decimal](6, 2) NULL,
	[Int20] [decimal](6, 2) NULL,
	[Int21] [decimal](6, 2) NULL,
	[Int22] [decimal](6, 2) NULL,
	[Int23] [decimal](6, 2) NULL,
	[Int24] [decimal](6, 2) NULL,
	[DST] [varchar](50) NULL,
	[TimeInserted] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMEnergyCurves] ADD  CONSTRAINT [DF_MtMEnergyCurves_TimeInserted]  DEFAULT (getdate()) FOR [TimeInserted]

GO

/**************************************** MtMAttrition ***********************************************/

CREATE TABLE [dbo].[MtMAttrition](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileLogID] [int] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[DeliveryMonth] [datetime] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[Attrition] [decimal](6, 2) NULL,
	[TimeInserted] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMAttrition] ADD  CONSTRAINT [DF_MtMAttrition_TimeInserted]  DEFAULT (getdate()) FOR [TimeInserted]
GO




/**************************************** MtMFileDetailedLog ***********************************************/

CREATE TABLE [dbo].[MtMFileDetailedLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileLogID] [int] NULL,
	[Information] [varchar](500) NULL,
	[TimeInserted] [datetime] NULL,
 CONSTRAINT [PK_AccountLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/**************************************** MtMFileLog ***********************************************/
CREATE TABLE [dbo].[MtMFileLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [varchar](100) NULL,
	[FileName] [varchar](200) NULL,
	[Status] [tinyint] NULL,
	[Information] [varchar](500) NULL,
	[TimeInserted] [datetime] NULL,
 CONSTRAINT [PK_FileLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/**************************************** MtMFileNamingConvention ***********************************************/

CREATE TABLE [dbo].[MtMFileNamingConvention](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileType] [varchar](50) NOT NULL,
	[FileName] [varchar](50) NULL,
 CONSTRAINT [PK_MtMFileNamingConvention] PRIMARY KEY CLUSTERED 
(
	[FileType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

INSERT	INTO MtMFileNamingConvention 
			(FileType, FileName)
VALUES		('Attrition','Attrition_YYYYMMDD.xlsx')

INSERT	INTO MtMFileNamingConvention 
			(FileType, FileName)
VALUES		('EnergyCurves','EnergyCurves_YYYYMMDD.xlsx')

INSERT	INTO MtMFileNamingConvention 
			(FileType, FileName)
VALUES		('Intraday','IntradayPremiums_YYYYMMDD.xlsx')

INSERT	INTO MtMFileNamingConvention 
			(FileType, FileName)
VALUES		('LossFactor','LossFactors_YYYYMMDD.xlsx')

INSERT	INTO MtMFileNamingConvention 
			(FileType, FileName)
VALUES		('Shaping','ShapingPremiums_YYYYMMDD.xlsx')

INSERT	INTO MtMFileNamingConvention 
			(FileType, FileName)
VALUES		('SupplierHour','SupplierHours_YYYYMMDD.xlsx')

INSERT	INTO MtMFileNamingConvention 
			(FileType, FileName)
VALUES		('SuppplierPremium','SupplierPremiums_YYYYMMDD.xlsx')

GO

/**************************************** usp_MtMGetFileType ***********************************************/

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get the file type of a file														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMGetFileType(@FileName as varchar(50))
	AS
	
SELECT	FileType
FROM	MtMFileNamingConvention
WHERE	FileName = @FileName

GO

/**************************************** usp_MtMFileLogInsert ***********************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		insert log entry																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE Procedure [dbo].[usp_MtMFileLogInsert]
	@GUID varchar(100),
	@FileName varchar(200),
	@Status int,
	@Information varchar(500),
	@TimeInserted DateTime

AS

BEGIN

	INSERT INTO [MtMFileLog]
           ([GUID]
           ,[FileName]
           ,[Status]
           ,[Information]
           ,[TimeInserted])
     VALUES(
			@GUID,
			@FileName,
			@Status,
			@Information,
			@TimeInserted)
			
	Select @@IDENTITY

END

GO

/**************************************** usp_MtMFileLogUpdate ***********************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		update log entry																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE Procedure [dbo].[usp_MtMFileLogUpdate] 
	@ID int,
	@Status int, 
	@Information as varchar (500)
	
AS

BEGIN

	Update	MtMFileLog
	Set		[Status] = @Status,
			Information = @Information
	Where	ID = @ID

END

GO

/**************************************** usp_MtMFileDetailedLogInsert ***********************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		insert log entry																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE Procedure [dbo].usp_MtMFileDetailedLogInsert
	@FileLogID int,
	@Information varchar(500)

AS

BEGIN

INSERT INTO [MtMFileDetailedLog]
           ([FileLogID]
           ,[Information]
           ,[TimeInserted])
     VALUES(
			@FileLogID,
			@Information,
			GETDATE())
			 
END

GO

/**************************************** usp_MtMFileLogGetID ***********************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get the file log ID																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE Procedure [dbo].[usp_MtMFileLogGetID] 
	@FileName as varchar(200)
	
AS

BEGIN

	Select	ID
	From	MtMFileLog
	Where	FileName = @FileName

END

GO

/**************************************** usp_MtMFileLogSelect ***********************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select dlog data for a file														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE Procedure [dbo].[usp_MtMFileLogSelect] 
	@FileName as varchar(200)
	
AS

BEGIN

	Select	* 
	From	MtMFileLog
	Where	FileName = @FileName
	
END

GO

/*********************************** usp_MtMLossFactorsTypeSelect ************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	1/12/2012																		*
 *	Descp:		select all the types for loss factors											*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE Procedure [dbo].usp_MtMLossFactorsTypeSelect 
		
AS

BEGIN

	Select	 *
	From	MtMLossFactorsType

	
END

GO

/*********************************** usp_MtMDayTypeSelect ************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	1/12/2012																		*
 *	Descp:		select all the day types														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE Procedure [dbo].usp_MtMDayTypeSelect 
		
AS

BEGIN

	Select	 *
	From	MtMDayType

	
END

GO

