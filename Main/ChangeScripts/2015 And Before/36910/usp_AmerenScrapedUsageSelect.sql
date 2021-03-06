USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_AmerenScrapedUsageSelect]    Script Date: 04/03/2014 09:43:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AmerenScrapedUsageSelect
 * Selects usage from the Ameren scraped table
 *
 * History
 *04-03-2014: Return date created
 *******************************************************************************
 * 12-15-2010 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_AmerenScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime ,
	@MeterNumber	varchar(50) = '')
AS

/*
select * from AmerenAccount order by 2, 6
usp_AmerenScrapedUsageSelect '7865000116', '', '2008-11-16', '2011-01-16'	-- Lighting
*/
BEGIN
	SET NOCOUNT ON;
	IF @MeterNumber <> ''
	  BEGIN
		SELECT	DISTINCT t2.Id, AccountId, BeginDate, EndDate, Days, TotalKwh, OnPeakKwh, OffPeakKwh, OnPeakDemandKw, OffPeakDemandKw, PeakReactivePowerKvar,
				AccountNumber, MeterNumber, t2.Created
		FROM	AmerenAccount (NOLOCK) t1 INNER JOIN
				AmerenUsage (NOLOCK) t2 ON AccountId = t1.Id
		WHERE	AccountNumber = @AccountNumber
			AND	MeterNumber = @MeterNumber
			AND BeginDate >= @BeginDate
			AND	EndDate <= @EndDate
		ORDER BY 3 DESC, 4
	  END
	ELSE
	  BEGIN
		SELECT	DISTINCT t2.Id, AccountId, BeginDate, EndDate, Days, TotalKwh, OnPeakKwh, OffPeakKwh, OnPeakDemandKw, OffPeakDemandKw, PeakReactivePowerKvar,
				AccountNumber, MeterNumber, t2.Created
		FROM	AmerenAccount (NOLOCK) t1 INNER JOIN
				AmerenUsage (NOLOCK) t2 ON AccountId = t1.Id
		WHERE	AccountNumber = @AccountNumber
			AND BeginDate >= @BeginDate
			AND	EndDate <= @EndDate
		ORDER BY 2, 3 DESC, 4
	  END

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

