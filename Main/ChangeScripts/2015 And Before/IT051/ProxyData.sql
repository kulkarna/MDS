/****************************************** usp_GetAccountUsageByUtility ****************************/
USE [Libertypower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec usp_GetUsageByUtility '3', 0, 1, 2, 'FIXED','1/1/2011','1/1/2012'

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get usage by utility															*
 *	Modified:	4/12: get the usage for 12 months. No need to group by year						*
 ********************************************************************************************** */
 
ALTER PROCEDURE [dbo].[usp_GetUsageByUtility]
(
	@UtilityID			int,
	@IsCustom			tinyint,
	--@BeginUsageInterval int,
	--@EndUsageInterval	int,
	@UsageTypeBilled	int,
	@UsageTypeHist		int,
	@Category			varchar(50),
	@DateUsageStart		datetime,
	@DateUsageEnd		datetime
)

AS

BEGIN

	SELECT	s.AccountNumber, 
			--CAST(DATEPART(yyyy, s.ToDate) AS varchar(4)) as UsageYear, 
			SUM (s.TotalKwh) as TotalKwh, COUNT(*) as CountUsage
	
	FROM	UsageConsolidated s (nolock)
		
	INNER	JOIN Account a (nolock)
	ON		s.AccountNumber = a.AccountNumber
	
	INNER	JOIN AccountContract ac (nolock)
	ON		a.AccountID = ac.AccountID
	
	INNER	JOIN AccountContractRate acr (nolock)
	ON		ac.AccountContractID = acr.AccountContractID
	AND		acr.IsContractedRate = 1
	
	INNER	JOIN Lp_common..common_product p (nolock)
	ON		acr.LegacyProductID = p.product_id
	AND		LTRIM(RTRIM(p.product_category)) = @Category
	AND		p.IsCustom = @IsCustom
		
	WHERE	a.UtilityID = @UtilityID
	AND		(	UsageType = @UsageTypeBilled
			OR	UsageType = @UsageTypeHist
			)
	AND		s.ToDate BETWEEN @DateUsageStart AND @DateUsageEnd
				
	GROUP	BY s.AccountNumber/*, 
				CAST(DATEPART(yyyy, s.ToDate) AS varchar(4))*/
	
	--HAVING	SUM (s.TotalKwh) < @EndUsageInterval
	--AND		SUM (s.TotalKwh) > @BeginUsageInterval

END


GO 

/****************************************** MtM_ProxyMeterReads ****************************************************/

CREATE TABLE [dbo].[MtMProxyUsage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityID] [int] NOT NULL,
	[UsageStart] [datetime] NOT NULL,
	[UsageEnd] [datetime] NOT NULL,
	[AverageKwh] [decimal](14, 4) NOT NULL,
	[ValidDate] [datetime] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_MtMProxyUsage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MtMProxyUsage] ADD  CONSTRAINT [DF_MtMProxyUsage_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]

GO

/****************************************** usp_MtM_ProxyUsageInsert ****************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		insert proxy usage																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMProxyUsageInsert
			(
			@UtilityID int,
			@UsageStart datetime,
			@UsageEnd datetime,
			@AverageKwh decimal(14, 4),
			@ValidDate datetime
			)
			
AS

BEGIN

	DECLARE	@ID INT
	SET	@ID = -1

	IF (EXISTS (SELECT	AverageKwh
				FROM	MtMProxyUsage
				WHERE	UtilityID = @UtilityID
				AND		UsageStart = @UsageStart
				AND		UsageEnd = @UsageEnd
				AND		YEAR(ValidDate) = YEAR(@ValidDate)
				AND		MONTH(ValidDate) = MONTH(@ValidDate)
				AND		DAY(ValidDate) = DAY(@ValidDate)
				)
		)
		BEGIN	
			UPDATE	MtMProxyUsage
			SET		AverageKwh = @AverageKwh,
					@ID = ID
			WHERE	UtilityID = @UtilityID
			AND		UsageStart = @UsageStart
			AND		UsageEnd = @UsageEnd
			AND		YEAR(ValidDate) = YEAR(@ValidDate)
			AND		MONTH(ValidDate) = MONTH(@ValidDate)
			AND		DAY(ValidDate) = DAY(@ValidDate)
		END
	ELSE
		BEGIN	
			INSERT INTO MtMProxyUsage (
					UtilityID,
					UsageStart,
					UsageEnd,
					AverageKwh,
					ValidDate)
			VALUES	(
					@UtilityID,
					@UsageStart,
					@UsageEnd,
					@AverageKwh,
					@ValidDate)
	
			SET	@ID = @@IDENTITY
		END
	
	SELECT @ID as ID
END

GO

/****************************************** usp_MtM_ProxyUsageSelect ****************************************************/

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select proxy usage																*
 *	Modified:																					*
 ********************************************************************************************** */
-- exec usp_MtMProxyUsageSelect 41, '9/26/2011'

CREATE PROCEDURE usp_MtMProxyUsageSelect
			(
			@UtilityID int,
			@ValidDate datetime
			)
			
AS

BEGIN

	SELECT	*
	FROM	MtMProxyUsage
	WHERE	UtilityID = @UtilityID
	AND		YEAR(ValidDate) = YEAR(@ValidDate)
	AND		MONTH(ValidDate) = MONTH(@ValidDate)
	AND		DAY(ValidDate) = DAY(@ValidDate)
	
END

GO

/****************************************** usp_MtM_ProxyUsageSelectByID ****************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select one proxy usage entry													*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMProxyUsageSelectByID
			(
			@ID int
			)
			
AS

BEGIN

	SELECT	*
	FROM	MtMProxyUsage
	WHERE	ID = @ID
	
END

GO

  /* **********************************************************************************************/
 /****** Object:  Table [dbo].[MtMProxyUsageDefault]    Script Date: 04/16/2012 09:44:08 *********/
/* **********************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MtMProxyUsageDefault](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityID] [int] NOT NULL,
	[Month] [smallint] NOT NULL,
	[AverageKwh] [decimal](14, 4) NULL,
 CONSTRAINT [PK_MtMProxyUsageDefault_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



/****************************** usp_MtMProxyUsageDefaultSelect **********************************/

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	4/16/2012																		*
 *	Descp:		select default proxy usage entry												*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMProxyUsageDefaultSelect
			(
			@UtilityID int
			)
			
AS

BEGIN

	SELECT	*
	FROM	MtMProxyUsageDefault
	WHERE	UtilityID = @UtilityID
	
END

GO


/********************************** usp_GetProxyMonthlyFactors *********************************************/

USE Lp_historical_info

GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get monthly factors											*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMGetProxyMonthlyFactors( @ISO varchar(50))

AS

BEGIN

	SELECT *
	  FROM [lp_historical_info].[dbo].[ProxyMonthlySeasonalFactors]
	  Where	market = @ISO
END

GO

SELECT DISTINCT so.name
FROM syscomments sc
INNER JOIN sysobjects so ON sc.id=so.id
WHERE sc.TEXT LIKE '%ProxyMonthlySeasonalFactors%'

GO
