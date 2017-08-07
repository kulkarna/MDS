
USE [Libertypower]
GO

-- ADD TimeZone to Wholesale table
ALTER table[LibertyPower].[dbo].[WholesaleMarket] ADD TimeZone VARCHAR(5)

GO

-- Update the Timezones for each ISO
UPDATE	[LibertyPower].[dbo].[WholesaleMarket]
SET		TimeZone = 'PST'
WHERE	ID = 1

UPDATE	[LibertyPower].[dbo].[WholesaleMarket]
SET		TimeZone = 'CST'
WHERE	ID = 2

UPDATE	[LibertyPower].[dbo].[WholesaleMarket]
SET		TimeZone = 'CST'
WHERE	ID = 3

UPDATE	[LibertyPower].[dbo].[WholesaleMarket]
SET		TimeZone = 'EST'
WHERE	ID = 4

UPDATE	[LibertyPower].[dbo].[WholesaleMarket]
SET		TimeZone = 'EST'
WHERE	ID = 5

UPDATE	[LibertyPower].[dbo].[WholesaleMarket]
SET		TimeZone = 'EST'
WHERE	ID = 6

GO

/****** Object:  Table [dbo].[MtMReport]    Script Date: 11/22/2011 16:08:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMReport](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportDescription] [varchar](150) NULL,
	[CounterPartyID] [int] NOT NULL,
	[Inactive] [bit] NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_MtMReport] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMReport] ADD  CONSTRAINT [DF_MtMReports_Inactive]  DEFAULT ((0)) FOR [Inactive]
GO

ALTER TABLE [dbo].[MtMReport] ADD  CONSTRAINT [DF_MtMReports_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

Insert	INTO [MtMReport] (ReportDescription, CounterPartyID, CreatedBy)
VALUES	('Fixed Price Load Obligation Position Reports Account List', 1, 'cghazal')
GO

Insert	INTO [MtMReport] (ReportDescription,CounterPartyID, CreatedBy)
VALUES	('Anticipatory Enrollment Hedge Report Account List', 2, 'cghazal')
GO

Insert	INTO [MtMReport] (ReportDescription, CounterPartyID, CreatedBy)
VALUES	('Anticipatory De-Enrollment Hedge Report Account List', 3, 'cghazal')
GO

--Insert	INTO [MtMReport] (ReportDescription, CounterPartyID, CreatedBy)
--VALUES	('De-Enrolled Early Termination', 4, 'cghazal')
--GO


USE [Libertypower]
GO
   /****************************************************************************************/
  /****** Object:  Table [dbo].[MtMReportStatus]    Script Date: 11/22/2011 16:08:35 ******/
 /****************************************************************************************/
 
SET ANSI_NULLS ON
GO


SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMReportStatus](
	[ReportStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID] [int] NULL,
	[Status] [varchar](50) NULL,
	[SubStatus] [varchar](50) NULL,
	[Inactive] [bit] NULL,
	[EffectiveDate] [datetime] NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_MtMReportStatus] PRIMARY KEY CLUSTERED 
(
	[ReportStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMReportStatus] ADD  CONSTRAINT [DF_MtMReportStatus_Inactive]  DEFAULT ((0)) FOR [Inactive]
GO

ALTER TABLE [dbo].[MtMReportStatus] ADD  CONSTRAINT [DF_MtMReportStatus_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[MtMReportStatus] ADD  CONSTRAINT [DF_MtMReportStatus_EffectiveDate]  DEFAULT (getdate()) FOR [EffectiveDate]
GO

  /**********************************************************************************************/
 /************************************** usp_MtMReportInsert  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportInsert
		(
				@ReportDescription	AS VARCHAR(150),
				@CounterPartyID		AS INT,
				@CreatedBy			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	INSERT	INTO [MtMReport] (ReportDescription, CounterPartyID, CreatedBy)
	VALUES	(@ReportDescription, @CounterPartyID, @CreatedBy)
	
	SELECT	@@IDENTITY
	
END

GO

  /**********************************************************************************************/
 /************************************** usp_MtMReportUpdate  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportUpdate
		(
				@ReportID			AS INT,
				@ReportDescription	AS VARCHAR(150),
				@CounterPartyID		AS INT,
				@DateModified		AS DATETIME,
				@ModifiedBy			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	UPDATE		MtMReport
	SET			ReportDescription = @ReportDescription,
				CounterPartyID	  = @CounterPartyID, 
				DateModified	  = @DateModified,
				ModifiedBy		  = @ModifiedBy
	WHERE		ReportID		  = @ReportID
	
	
END

GO

  /**********************************************************************************************/
 /****************************** usp_MtMReportInactiveUpdate  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportInactiveUpdate
		(
				@ReportID			AS INT,
				@DateModified		AS DATETIME,
				@ModifiedBy			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	--set all the child records to inactive also
	UPDATE		MtMReportStatus
	SET			Inactive = 1,
				DateModified = @DateModified,
				ModifiedBy = @ModifiedBy
	WHERE		ReportID = @ReportID
	
	--set the parent record to inactive
	UPDATE		MtMReport
	SET			Inactive = 1,
				DateModified = @DateModified,
				ModifiedBy = @ModifiedBy
	WHERE		ReportID = @ReportID
	
END

GO

  /**********************************************************************************************/
 /************************************** usp_MtMReportSelect  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportSelect
		@Inactive	AS BIT
		
AS

BEGIN
	
	SELECT	*
	FROM	MtMReport
	WHERE	Inactive = @Inactive
	
END

GO

  /**********************************************************************************************/
 /************************************** usp_MtMReportSelectByID  ******************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportSelectByID
		@ReportID	AS INT
		
AS

BEGIN
	
	SELECT	*
	FROM	MtMReport
	WHERE	ReportID = @ReportID
	
END

GO


  /**********************************************************************************************/
 /************************************** usp_MtMReportSelectByDesc  ****************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportSelectByDesc
		(
				@ReportDescription	AS VARCHAR(150),
				@Inactive			AS BIT
		)
		
AS

BEGIN
	
	SELECT	*
	FROM	MtMReport 
	WHERE	ReportDescription = @ReportDescription
	AND		Inactive = @Inactive
	
END

GO

  /**********************************************************************************************/
 /******************************** usp_MtMReportStatusInsert  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportStatusInsert
		(
				@ReportID			AS INT,
				@Status				AS VARCHAR(50),
				@SubStatus			AS VARCHAR(50),
				@EffectiveDate		AS DATETIME,
				@CreatedBy			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	INSERT	INTO MtMReportStatus (ReportID, Status, SubStatus, EffectiveDate, CreatedBy )
	VALUES		(@ReportID, @Status, @SubStatus, @EffectiveDate, @CreatedBy)
	
	SELECT	@@IDENTITY
	
END

GO

  /**********************************************************************************************/
 /******************************** usp_MtMReportStatusUpdate  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportStatusUpdate
		(
				@ReportStatusID		AS INT,
				@EffectiveDate		AS DATETIME,
				@DateModified		AS DATETIME,
				@ModifiedBy			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	UPDATE		MtMReportStatus
	SET			EffectiveDate = @EffectiveDate,
				DateModified = @DateModified,
				ModifiedBy = @ModifiedBy
	WHERE		ReportStatusID = @ReportStatusID
	
	
END

GO

  /**********************************************************************************************/
 /****************************** usp_MtMReportStatusInactiveUpdate  ****************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportStatusInactiveUpdate
		(
				@ReportStatusID		AS INT,
				@DateModified		AS DATETIME,
				@ModifiedBy			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	--set all the child records to inactive also
	UPDATE		MtMReportStatus
	SET			Inactive = 1,
				DateModified = @DateModified,
				ModifiedBy = @ModifiedBy
	WHERE		ReportStatusID = @ReportStatusID
		
END

GO


  /**********************************************************************************************/
 /******************************** usp_MtMReportStatusSelect  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportStatusSelect
		(
				@ReportID			AS INT,
				@Inactive			AS BIT
		)
		
AS

BEGIN
	
	SELECT	m.*, 
			s.status_descp AS StatusDescription, 
			s.sub_status_descp AS SubStatusDescription
	FROM	MtMReportStatus m
	INNER	JOIN lp_account.dbo.enrollment_status_substatus_vw s
	ON		m.Status = s.status
	AND		m.SubStatus = s.sub_status
	WHERE	ReportID = @ReportID
	AND		Inactive = @Inactive
	
END

GO

  /**********************************************************************************************/
 /******************************** usp_MtMReportStatusSelectByID  ******************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportStatusSelectByID
		(
				@ReportStatusID	AS INT
		)
		
AS

BEGIN
	
	SELECT	*
	FROM	MtMReportStatus 
	WHERE	ReportStatusID	 = @ReportStatusID	
	
END

GO


  /**********************************************************************************************/
 /************************* usp_MtMReportStatusSelectNotUsed  **********************************/
/**********************************************************************************************/

--exec usp_MtMReportStatusSelectNotUsed '0'

GO

CREATE	PROCEDURE	usp_MtMReportStatusSelectNotUsed
		(
				@Inactive			AS BIT
		)
		
AS

BEGIN
	
	SELECT	s.*, rs.Status
	FROM	lp_account.dbo.enrollment_status_substatus_vw s
	LEFT	JOIN 
			(	SELECT	rs.*
				FROM	MtMReportStatus rs
				INNER	JOIN MtMReport r
				ON		r.ReportID = rs.ReportID
				AND		r.Inactive = @Inactive
			)rs	
	ON		s.status = rs.Status
	AND		s.sub_status = rs.SubStatus
	AND		rs.Inactive = @Inactive
	WHERE	rs.Status IS NULL
	
END
GO

exec usp_MtMReportStatusInsert '1','03000','20', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','04000','20', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','05000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','05000','27', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','05000','30', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','06000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','06000','20', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','06000','27', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','06000','30', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','07000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','07000','20', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','905000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '1','906000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','01000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','01000','15', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','03000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','04000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','05000','25', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','06000','25', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','09000','20', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','10000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','10000','20', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','13000','60', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','13000','70', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '2','13000','80', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '3','11000','10', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '3','11000','20', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '3','11000','30', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '3','11000','40', '11/23/2011', 'cghazal'
GO

exec usp_MtMReportStatusInsert '3','11000','50', '11/23/2011', 'cghazal'
GO

--exec usp_MtMReportStatusInsert '4','911000','10', '11/23/2011', 'cghazal'
--GO


  /**********************************************************************************************/
 /**************************************  MtMReportCounterParty  *******************************/
/**********************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMReportCounterParty](
	[CounterPartyID] [int] IDENTITY(1,1) NOT NULL,
	[CounterParty] [varchar](50) NOT NULL,
	[BuySell] [varchar](1) NOT NULL,
/*	[Book] [varchar](50) NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[TimeZone] [varchar](5) NULL,
	[Zkey] [varchar](10) NULL,*/
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_MtMReportCounterParty] PRIMARY KEY CLUSTERED 
(
	[CounterPartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[MtMReportCounterParty]
 ADD UNIQUE (CounterParty)
 GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMReportCounterParty] ADD  CONSTRAINT [DF_MtMReportCounterParty_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

Insert	INTO [MtMReportCounterParty] (CounterParty,BuySell, CreatedBy)
VALUES	('PlContract','S', 'cghazal')

GO

Insert	INTO [MtMReportCounterParty] (CounterParty,BuySell, CreatedBy)
VALUES	('PlAnticip','S', 'cghazal')

GO

Insert	INTO [MtMReportCounterParty] (CounterParty,BuySell, CreatedBy)
VALUES	('PlDeenroll','B', 'cghazal')

GO

--Insert	INTO [MtMReportCounterParty] (CounterParty,BuySell,CreatedBy)
--VALUES	('PlAttriEST','B', 'cghazal')

--GO

  /**********************************************************************************************/
 /************************** usp_MtMReportCounterPartyInsert  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportCounterPartyInsert
		(
				@CounterParty		AS VARCHAR(50),
				@BuySell			AS VARCHAR(1),
				--@Book				AS VARCHAR(50),
				@CreatedBy			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	INSERT	INTO MtMReportCounterParty (
				CounterParty, 
				BuySell, 
				--Book, 
				CreatedBy )
	VALUES		(
				@CounterParty, 
				@BuySell, 
				--@Book, 
				@CreatedBy)
	
	SELECT	@@IDENTITY
	
END

GO

  /**********************************************************************************************/
 /************************** usp_MtMReportCounterPartyUpdate  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportCounterPartyUpdate
		(
				@CounterPartyID		AS INT,
				@CounterParty		AS VARCHAR(50),
				@BuySell			AS VARCHAR(1),
				--@Book				AS VARCHAR(50),
				@DateModified		AS DATETIME,
				@ModifiedBy			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	UPDATE		MtMReportCounterParty
	SET			CounterParty = @CounterParty,
				BuySell = @BuySell, 
				--Book = @Book,
				DateModified = @DateModified,
				ModifiedBy = @ModifiedBy
	WHERE		CounterPartyID = @CounterPartyID
	
	
END

GO

  /**********************************************************************************************/
 /****************************** usp_MtMReportCounterPartyDelete  ******************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportCounterPartyDelete
		(
				@CounterPartyID		AS INT
		)
		
AS

BEGIN
	
	--set all the child records to inactive also
	DELETE	MtMReportCounterParty
	WHERE	CounterPartyID = @CounterPartyID
		
END

GO


  /**********************************************************************************************/
 /*************************** usp_MtMReportCounterPartySelectByDesc ****************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportCounterPartySelectByDesc
		(
				@CounterParty			AS VARCHAR(50)
		)
		
AS

BEGIN
	
	SELECT	*
	FROM	MtMReportCounterParty 
	WHERE	CounterParty = @CounterParty
	
END

GO


  /**********************************************************************************************/
 /*************************** usp_MtMReportCounterPartySelect **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportCounterPartySelect
		
AS

BEGIN
	
	SELECT	*
	FROM	MtMReportCounterParty 
	
END

GO


  /**********************************************************************************************/
 /******** Object:  Table [dbo].[MtMReportZkey]    Script Date: 02/24/2012 14:21:59 ************/
/**********************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMReportZkey](
	[ZkeyID] [int] IDENTITY(1,1) NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[Year] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_MtMReportZkey_1] PRIMARY KEY CLUSTERED 
(
	[ISO] ASC,
	[Zone] ASC,
	[Year] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMReportZkey] ADD  CONSTRAINT [DF_MtMReportZkey_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO


  /**********************************************************************************************/
 /********************************* usp_MtMReportZkeySelect ************************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportZkeySelect
		@ISO	AS VARCHAR(50),
		@Zone	AS VARCHAR(50)
		
AS

BEGIN
	
	SELECT	*
	FROM	MtMReportZkey
	WHERE	ISO = @ISO
	AND		Zone = @Zone
	
END

GO

  /**********************************************************************************************/
 /********************************* usp_MtMReportZkeyInsert ************************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportZkeyInsert
		@ISO			AS VARCHAR(50),
		@Zone			AS VARCHAR(50),
		@ZoneAlias		AS VARCHAR(50),
		@CreatedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	
	INSERT	INTO MtMReportZkey 
			(
				ISO,
				Zone,
				ZoneAlias,
				CreatedBy
			)
	VALUES	(
				@ISO,
				@Zone,
				@ZoneAlias,
				@CreatedBy
			)	
			
	SELECT	@@IDENTITY
	
END

GO


  /**********************************************************************************************/
 /********************************* usp_MtMReportZkeyUpdate ************************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportZkeyUpdate
		@ZkeyID			AS INT,
		@ZoneAlias		AS VARCHAR(50),
		@DateModified	AS DATETIME,
		@ModifiedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	
	UPDATE	MtMReportZkey 
	SET		ZoneAlias		= @ZoneAlias,
			ModifiedBy		= @ModifiedBy,
			DateModified	= @DateModified
	WHERE	ZkeyID			= @ZkeyID
END

GO

  /**********************************************************************************************/
 /****** Object:  Table [dbo].[MtMReportZkeyDetail]    Script Date: 02/27/2012 14:24:27 ********/
/**********************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMReportZkeyDetail](
	[ZKeyDetailID] [int] IDENTITY(1,1) NOT NULL,
	[ZkeyID] [int] NOT NULL,
	[CounterPartyID] [int] NOT NULL,
	[Zkey] [varchar](50) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMReportZkeyDetail] ADD  CONSTRAINT [DF_MtMReportZkeyDetail_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO


ALTER TABLE [dbo].[MtMReportZkeyDetail] ADD UNIQUE (ZkeyID,CounterPartyID)
 GO


  /**********************************************************************************************/
 /***************************** usp_MtMReportZkeyDetailSelect *********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportZkeyDetailSelect
		@ZkeyID AS INT
		
AS

BEGIN
	
	SELECT	*
	FROM	MtMReportZkeyDetail
	WHERE	ZkeyID = @ZkeyID
	
END

GO

  /**********************************************************************************************/
 /********************************* usp_MtMReportZkeyDetailInsert ******************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportZkeyDetailInsert
		@ZkeyID			AS INT,
		@CounterPartyID	AS INT,
		@Zkey			AS VARCHAR(50),
		@CreatedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	
	INSERT	INTO MtMReportZkeyDetail 
			(
				ZkeyID,
				CounterPartyID,
				Zkey,
				CreatedBy
			)
	VALUES	(
				@ZkeyID,
				@CounterPartyID,
				@Zkey,
				@CreatedBy
			)	

	SELECT	@@IDENTITY	
END

GO


  /**********************************************************************************************/
 /*************************** usp_MtMReportZkeyDetailUpdate ************************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportZkeyDetailUpdate
		@ZkeyDetailID	AS INT,
		@Zkey			AS VARCHAR(50),
		@DateModified	AS DATETIME,
		@ModifiedBy		AS VARCHAR(50)
		
		
AS

BEGIN
	
	UPDATE	MtMReportZkeyDetail
	SET		Zkey			= @Zkey,
			DateModified	= @DateModified,
			ModifiedBy		= @ModifiedBy
	WHERE	ZkeyDetailID	= @ZkeyDetailID
END

GO


  /**********************************************************************************************/
 /********************** usp_MtMReportCountByCounterParty **************************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportCountByCounterParty
		@CounterPartyID	AS INT		
		
AS

BEGIN

	SELECT	COUNT(DISTINCT r.ReportID) as CountReports, MIN(r.ReportDescription) as ReportDescription
	FROM	MtMReport r
	WHERE	r.CounterPartyID = @CounterPartyID
	AND		r.Inactive = 0
	

END

GO


  /**********************************************************************************************/
 /********************** usp_MtMReportZkeyCountByCounterParty **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportZkeyCountByCounterParty
		@CounterPartyID	AS INT		
		
AS

BEGIN

	SELECT	COUNT(DISTINCT z.ZkeyID) as CountZkeys, MIN(z.ISO + '- ' + z.Zone) AS ZKeyDescrition
	FROM	MtMReportZkey z
	INNER	JOIN MtMReportZkeyDetail zd
	ON		z.ZkeyID = zd.ZkeyID
	WHERE	zd.CounterPartyID = @CounterPartyID
	

END

GO

  /**********************************************************************************************/
 /********************** usp_MtMReportZkeyDeleteByCounterParty *********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_MtMReportZkeyDeleteByCounterParty
		@CounterPartyID	AS INT		
		
AS

BEGIN

	DELETE	
	FROM	MtMReportZkeyDetail 
	WHERE	CounterPartyID = @CounterPartyID
	

END

GO

  /**********************************************************************************************/
 /*********************************************** usp_GetISO  **********************************/
/**********************************************************************************************/

CREATE	PROCEDURE	usp_GetISO
		
AS

BEGIN
	SELECT	WholesaleMktId as ISO
	FROM	WholesaleMarket
	WHERE	InactiveInd = 0
	
END

GO


  /**********************************************************************************************/
 /************************************ usp_ZonesByISO  *****************************************/
/**********************************************************************************************/

USE [Lp_common]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ZonesByISO]
	@ISO	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	DISTINCT
			zone
	FROM	LibertyPower..Utility u
	INNER	JOIN Lp_common..zone z
	ON		z.utility_id = u.UtilityCode
	WHERE	u.WholeSaleMktID = @ISO
	
    SET NOCOUNT OFF;
END
