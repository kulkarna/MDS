USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetAnnualUsage]    Script Date: 10/15/2015 09:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
-- =============================================
-- AUTHOR:		VIKAS SHARMA
-- CREATE DATE: 10-13-2015
-- DESCRIPTION:	 USED TO CALCULATE ANNUAL USAGE
-- =============================================
 

*/
CREATE PROCEDURE [dbo].[Usp_GetAnnualUsage]
	@LISTUSAGELIST AS DBO.USAGELIST READONLY
AS
BEGIN

	SET NOCOUNT ON;
 SELECT ID,
        ACCOUNTNUMBER,
        UTILITYCODE,
        USAGESOURCE,
        BEGINDATE,
        ENDDATE,
        CASE WHEN [DAYS]>1 THEN [DAYS]-1 ELSE 0 END DAYS,
        TOTALKWH AS QUANTITY,
        isnull(METERNUMBER,'') as METERNUMBER
         INTO #TEMPUSAGE FROM @LISTUSAGELIST
         WHERE ISACTIVE=1
         
         UPDATE #TEMPUSAGE SET METERNUMBER='#' WHERE ISNULL(METERNUMBER,'')=''
         
       SELECT SUM(ANNUALUSAGE) AS ANNUALUSAGE
       FROM  ( SELECT  CAST(SUM(QUANTITY) AS FLOAT) /SUM(DAYS)*365 AS ANNUALUSAGE
         FROM #TEMPUSAGE
         GROUP BY ISNULL(METERNUMBER,''))VW_SUMMETERNUMBER



    SET NOCOUNT OFF;
END

GO
/****** Object:  UserDefinedTableType [dbo].[UsageList]    Script Date: 10/15/2015 09:16:52 ******/
CREATE TYPE [dbo].[UsageList] AS TABLE(
	[AccountNumber] [varchar](50) NULL,
	[UtilityCode] [varchar](50) NULL,
	[ISO] [varchar](50) NULL,
	[UsageSource] [varchar](50) NULL,
	[UsageType] [varchar](50) NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Days] [int] NULL,
	[TotalKwh] [decimal](15, 5) NULL,
	[BillingDemandKwh] [decimal](15, 5) NULL,
	[OffPeakKwh] [decimal](15, 5) NULL,
	[OnPeakKwh] [decimal](15, 5) NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
	[InterMediateKwh] [decimal](15, 5) NULL,
	[MonthlyOffPeakDemandKw] [decimal](15, 5) NULL,
	[ModifiedBy] [varchar](50) NULL,
	[MonthlyPeakDemandKw] [decimal](15, 5) NULL,
	[ID] [int] NULL,
	[IsConsolidated] [varchar](50) NULL,
	[isActive] [bit] NULL,
	[ReasonCode] [varchar](50) NULL,
	[MeterNumber] [varchar](50) NULL
)
GO
