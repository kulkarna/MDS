USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************************/

CREATE TABLE [dbo].[MtMTracking](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QuoteNumber] [varchar](50) NULL,
	[BatchNumber] [varchar](50) NULL,
	[Description] [varchar](1500) NULL,
	[row_count] [int] NULL,
	[Type] [varchar](1) NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_MtMTracking] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'I= Info, F= Failure, S= Success' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MtMTracking', @level2type=N'COLUMN',@level2name=N'Type'
GO

ALTER TABLE [dbo].[MtMTracking] ADD  CONSTRAINT [DF_Table_1_TYPE]  DEFAULT ('I') FOR [Type]
GO

ALTER TABLE [dbo].[MtMTracking] ADD  CONSTRAINT [DF_Table_1_date_insert]  DEFAULT (getdate()) FOR [DateCreated]

GO

CREATE NONCLUSTERED INDEX IX_BatchQuote ON dbo.MtMTracking (BatchNumber, QuoteNumber) 

GO
/**************************************************************************************/
CREATE PROCEDURE usp_MtMTracking

(
	@Description VARCHAR(1500),
	@RowCount INT,
	@QuoteNumber VARCHAR(50),
	@BatchNumber VARCHAR(50),
	@Type VARCHAR(1)
)

AS

BEGIN

	INSERT	INTO MtMTracking
		(
		Description, 
		row_count, 
		QuoteNumber, 
		BatchNumber,
		Type
		)
	VALUES
		(
		@Description, 
		@RowCount, 
		@QuoteNumber, 
		@BatchNumber,
		@Type
		)

END
GO

/*********************************************************************************************/

CREATE TABLE [dbo].[MtMAccount](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BatchNumber] [varchar](50) NULL,
	[QuoteNumber] [varchar](50) NULL,
	[AccountID] [int] NULL,
	[ContractID] [int] NULL,
	[Zone] [varchar](50) NULL,
	[LoadProfile] [varchar](50) NULL,
	[ProxiedZone] [bit] NULL,
	[ProxiedProfile] [bit] NULL,
	[ProxiedUsage] [bit] NULL,
	[MeterReadCount] [int] NULL,
	[Status] [varchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
 CONSTRAINT [PK_MtMAccount] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'New, Forecasted, ETPd, Failed (Forecasting), Failed (ETP)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MtMAccount', @level2type=N'COLUMN',@level2name=N'Status'
GO

ALTER TABLE [dbo].[MtMAccount] ADD  CONSTRAINT [DF_MtMAccount_ProxiedZone]  DEFAULT ((0)) FOR [ProxiedZone]
GO

ALTER TABLE [dbo].[MtMAccount] ADD  CONSTRAINT [DF_MtMAccount_ProxiedProfile]  DEFAULT ((0)) FOR [ProxiedProfile]
GO

ALTER TABLE [dbo].[MtMAccount] ADD  CONSTRAINT [DF_MtMAccount_ProxiedUsage]  DEFAULT ((0)) FOR [ProxiedUsage]
GO

ALTER TABLE [dbo].[MtMAccount] ADD  CONSTRAINT [DF_MtMAccount_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]

GO

ALTER TABLE [dbo].[MtMAccount] ADD CONSTRAINT [UC_MtMAccount_AccountID] UNIQUE (BatchNumber,QuoteNumber,AccountID)
GO

CREATE NONCLUSTERED INDEX IX_BatchQuote ON dbo.MtMAccount (BatchNumber, QuoteNumber) 
GO

CREATE NONCLUSTERED INDEX IX_DateCreated ON dbo.MtMAccount (DateCreated) 
GO

/***************************************************************************************/

CREATE TABLE [dbo].[MtMUsage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MtMAccountID] [int] NULL,
	[UsageID] [int] NULL,
	[UsageSource] [varchar](15) NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_MtMUsage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Proxy or Usage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MtMUsage', @level2type=N'COLUMN',@level2name=N'UsageSource'
GO

ALTER TABLE [dbo].[MtMUsage] ADD  CONSTRAINT [DF_MtMUsage_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

CREATE NONCLUSTERED INDEX IX_MtMAccountID ON dbo.MtMUsage (MtMAccountID) 

GO

/*****************************************************************************************/
CREATE TABLE [dbo].[MtMDailyLoadForecast](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MtMAccountID] [int] NULL,
	[UsageDate] [datetime] NULL,
	[RecordType] [varchar](50) NULL,
	[DayType] [varchar](15) NULL,
	[Peak] [float] NULL,
	[OffPeak] [float] NULL,
	[Int1] [decimal](14, 4) NULL,
	[Int2] [decimal](14, 4) NULL,
	[Int3] [decimal](14, 4) NULL,
	[Int4] [decimal](14, 4) NULL,
	[Int5] [decimal](14, 4) NULL,
	[Int6] [decimal](14, 4) NULL,
	[Int7] [decimal](14, 4) NULL,
	[Int8] [decimal](14, 4) NULL,
	[Int9] [decimal](14, 4) NULL,
	[Int10] [decimal](14, 4) NULL,
	[Int11] [decimal](14, 4) NULL,
	[Int12] [decimal](14, 4) NULL,
	[Int13] [decimal](14, 4) NULL,
	[Int14] [decimal](14, 4) NULL,
	[Int15] [decimal](14, 4) NULL,
	[Int16] [decimal](14, 4) NULL,
	[Int17] [decimal](14, 4) NULL,
	[Int18] [decimal](14, 4) NULL,
	[Int19] [decimal](14, 4) NULL,
	[Int20] [decimal](14, 4) NULL,
	[Int21] [decimal](14, 4) NULL,
	[Int22] [decimal](14, 4) NULL,
	[Int23] [decimal](14, 4) NULL,
	[Int24] [decimal](14, 4) NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMDailyLoadForecast] ADD  CONSTRAINT [DF_MtMDailyLoadForecast_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO


/*************************************************************************************************/
GO

CREATE TABLE [dbo].[MtMDailyLoadForecastTemp](
	[MtMAccountID] [int] NULL,
	[AccountID] [int] NULL,
	[UsageDate] [datetime] NOT NULL,
	[RecordType] [varchar](50) NULL,
	[DayType] [varchar](15) NULL,
	[Peak] [float] NULL,
	[OffPeak] [float] NULL,
	[Int1] [decimal](14, 4) NULL,
	[Int2] [decimal](14, 4) NULL,
	[Int3] [decimal](14, 4) NULL,
	[Int4] [decimal](14, 4) NULL,
	[Int5] [decimal](14, 4) NULL,
	[Int6] [decimal](14, 4) NULL,
	[Int7] [decimal](14, 4) NULL,
	[Int8] [decimal](14, 4) NULL,
	[Int9] [decimal](14, 4) NULL,
	[Int10] [decimal](14, 4) NULL,
	[Int11] [decimal](14, 4) NULL,
	[Int12] [decimal](14, 4) NULL,
	[Int13] [decimal](14, 4) NULL,
	[Int14] [decimal](14, 4) NULL,
	[Int15] [decimal](14, 4) NULL,
	[Int16] [decimal](14, 4) NULL,
	[Int17] [decimal](14, 4) NULL,
	[Int18] [decimal](14, 4) NULL,
	[Int19] [decimal](14, 4) NULL,
	[Int20] [decimal](14, 4) NULL,
	[Int21] [decimal](14, 4) NULL,
	[Int22] [decimal](14, 4) NULL,
	[Int23] [decimal](14, 4) NULL,
	[Int24] [decimal](14, 4) NULL,	
	[QuoteNumber] [varchar](50) NOT NULL,
	[BatchNumber] [varchar](50) NOT NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MtMDailyLoadForecastTemp] ADD  CONSTRAINT [DF_[MtMDailyLoadForecastTemp_Created]  DEFAULT (getdate()) FOR [DateCreated]
GO

CREATE NONCLUSTERED INDEX IX_MtMAccountID ON dbo.MtMDailyLoadForecastTemp (MtMAccountID) 
GO

CREATE NONCLUSTERED INDEX IX_BatchQuote ON dbo.MtMDailyLoadForecastTemp (BatchNumber, QuoteNumber) 

GO

/********************************************************************************************************************************/

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		clean up forecasted data														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE usp_MtMCleanupForecastedData
(
	@QuoteNumber VARCHAR(50),
	@BatchNumber VARCHAR(50)
)
AS

BEGIN

	-- For each account/usage data, keep only the record with the max record type value
	/*DELETE	TEMP
	FROM	MtMDailyLoadForecastTemp TEMP
	INNER	JOIN 
			(
				SELECT	t2.AccountID, t2.UsageDate, max(t2.RecordType) RecordType
				FROM	MtMDailyLoadForecastTemp t2
				GROUP	by t2.AccountID, t2.UsageDate
			)T
	ON		TEMP.AccountID = T.AccountID
	AND		TEMP.UsageDate = T.UsageDate
	AND		TEMP.RecordType <> T.RecordType
	WHERE	TEMP.BatchNumber = @BatchNumber
	AND		TEMP.QuoteNumber = @QuoteNumber
	*/

	-- update the utility and load shape ID
	UPDATE	TEMP
	SET		TEMP.MtMAccountID = a.ID,
			TEMP.CreatedBy = a.CreatedBy
	FROM	MtMDailyLoadForecastTemp TEMP
	INNER	JOIN MtMAccount a
	ON		TEMP.QuoteNumber = a.QuoteNumber
	AND		TEMP.BatchNumber = a.BatchNumber
	AND		TEMP.AccountID = a.AccountID
	WHERE	TEMP.BatchNumber = @BatchNumber
	AND		TEMP.QuoteNumber = @QuoteNumber

END

GO

/*************************************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		move forecasted data from temp location											*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE	usp_MtMMoveForecastedDataFromTemp
(
	@QuoteNumber VARCHAR(50),
	@BatchNumber VARCHAR(50)
)
AS

BEGIN

	INSERT	INTO  dbo.MtMDailyLoadForecast
		(
			MtMAccountID, 
			UsageDate, 
			RecordType, 
			DayType, 
			Peak, 
			OffPeak, 
			INT1,
			INT2,
			INT3,
			INT4,
			INT5,
			INT6,
			INT7,
			INT8,
			INT9,
			INT10,
			INT11,
			INT12,
			INT13,
			INT14,
			INT15,
			INT16,
			INT17,
			INT18,
			INT19,
			INT20,
			INT21,
			INT22,
			INT23,
			INT24,
			CreatedBy
		)

	SELECT	DISTINCT
			MtMAccountID,
			UsageDate,
			RecordType,
			DayType,
			Peak,
			OffPeak,
			INT1,
			INT2,
			INT3,
			INT4,
			INT5,
			INT6,
			INT7,
			INT8,
			INT9,
			INT10,
			INT11,
			INT12,
			INT13,
			INT14,
			INT15,
			INT16,
			INT17,
			INT18,
			INT19,
			INT20,
			INT21,
			INT22,
			INT23,
			INT24,			
			CreatedBy
	FROM	MtMDailyLoadForecastTemp 
	WHERE	BatchNumber = @BatchNumber
	AND		QuoteNumber = @QuoteNumber
END


GO


/*************************************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		clear temp table																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMClearTempTable
(
	@QuoteNumber VARCHAR(50),
	@BatchNumber VARCHAR(50)
)

AS

BEGIN

	DELETE	MtMDailyLoadForecastTemp
	WHERE	BatchNumber = @BatchNumber
	AND		QuoteNumber = @QuoteNumber

END

GO

/***********************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		update MtMAccount																*
 *	Modified:																					*
 ********************************************************************************************** */
ALTER PROCEDURE usp_MtMAccountUpdate

(
	@QuoteNumber VARCHAR(50),
	@BatchNumber VARCHAR(50)
)

AS

BEGIN

	UPDATE	a
	SET		a.ProxiedUsage = CASE WHEN U.UsageSource like '%Proxy%' THEN 1 ELSE 0 END,
			a.MeterReadCount = U.CountMeterReads
	FROM	MtMAccount a
	INNER	JOIN (
					SELECT  MtMAccountID, MIN(UsageSource) as UsageSource, COUNT(UsageID) as CountMeterReads
					FROM	MtMUsage
					GROUP	BY	MtMAccountID
					) U
	ON		a.ID = U.MtMAccountID
	WHERE	a.QuoteNumber = @QuoteNumber
	AND		a.BatchNumber = @BatchNumber

END

GO

/*****************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		update MtMaccount status														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_MtMAccountStatusUpdate]
	(	@Status VARCHAR (256),
		@BatchNumber VARCHAR(50),
		@QuoteNumber VARCHAR(50)
	 )
AS

BEGIN

	UPDATE	MtMAccount
	SET		Status = @Status,
			DateModified = GETDATE()
	WHERE	BatchNumber = @BatchNumber
	AND		QuoteNumber = @QuoteNumber

END

GO
/*****************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select MtMAccount IDs															*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_MtMAccountSelectIDs]
	(	@BatchNumber VARCHAR(50),
		@QuoteNumber VARCHAR(50)
	 )
AS

BEGIN

	SELECT	ID, AccountID
	FROM	MtMAccount
	WHERE	BatchNumber = @BatchNumber
	AND		QuoteNumber = @QuoteNumber

END

GO


/****************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select MtMAccount data															*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE usp_MtMAccountSelect
( @ProcessDate DATETIME )

AS

BEGIN

	SELECT	*
	FROM	MtMAccount
	WHERE	MONTH(DateCreated) = MONTH(@ProcessDate)
	AND		DAY(DateCreated) = DAY(@ProcessDate)
	AND		YEAR(DateCreated) = YEAR(@ProcessDate)
	
END

GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select back to back value of the acocunt/contract								*
 *	Modified:																					*
 ********************************************************************************************** */
 
CREATE	PROCEDURE	usp_AccountIsBackToBack
(	@AccountID AS INT,
	@ContractID AS INT
)
AS

BEGIN
	  SELECT	ISNULL(d.BackToBack,0) AS BackToBack 
      FROM		AccountContract ac (nolock)

      INNER		JOIN AccountContractRate acr (nolock)
      ON		ac.AccountContractID = acr.AccountContractID
      AND		acr.IsContractedRate = 1

      INNER		JOIN Lp_common..common_product p (nolock)
      ON		acr.LegacyProductID = p.product_id
      
      LEFT		JOIN lp_deal_capture.dbo.deal_pricing_detail d (nolock)
      ON		acr.RateID = d.rate_id
      AND		p.product_id = d.product_id
      AND		p.IsCustom =  1
      
      WHERE		ac.AccountID = @AccountID
      AND		ac.ContractID = @ContractID
END

GO
/****************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	04/24/2012																		*
 *	Descp:		Get the zone value from the zone table in common table for the text specified	*
 *	Modified:																					*
 ********************************************************************************************** */

CREATE	PROCEDURE	usp_ZoneMappingSelect
		@UtilityID	AS INT,
		@Text		AS nchar(50)

AS

BEGIN

	SELECT	TOP 1 
			c.Zone
	FROM	ZoneMapping m
	INNER	JOIN lp_common..zone c
	ON		m.ZoneID = c.zone_id
	WHERE	m.Text		= @TEXT
	AND		m.UtilityID = @UtilityID

END

GO

USE Lp_historical_info
GO

/****************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select utility zone lookup														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE usp_MtMRO_Util_Zone_Lkkup_Select

AS

BEGIN

	Select	*
	FROM	ro_util_zone_lkup 

END

/****************************************************************************************/

GO

/****************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select ro calendar mapping														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE usp_MtMRO_Calendar_Mapping_Select

AS

BEGIN

	Select	*
	FROM	RO_CALENDAR_MAPPING 

END


GO