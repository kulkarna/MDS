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


