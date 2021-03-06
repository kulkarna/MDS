USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_ComedScrapedUsageSelect]    Script Date: 04/02/2014 16:26:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_ComedScrapedSelect
 * Selects usage from the comed scraped table
 *
 * History
 *04-03-2014: Return date created
 *******************************************************************************
 * 02-02-2011 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_ComedScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
/*
select * from ComedAccount (nolock) where accountnumber = '0010072045' order by 3, 1 desc
select * from ComedUsage (nolock) where accountnumber = '0010072045' order by 4 desc
usp_ComedScrapedUsageSelect '0010072045', '2008-11-16', '2010-11-16'
*/
BEGIN
	SET NOCOUNT ON;

	SELECT	DISTINCT AccountNumber, Rate, BeginDate, EndDate, Days, TotalKwh, OnPeakKwh, OffPeakKwh, BillingDemandKw, MonthlyPeakDemandKw, Created
	FROM	ComedUsage (nolock)
	WHERE	AccountNumber = @AccountNumber
		AND BeginDate >= @BeginDate
		AND	EndDate <= @EndDate
	ORDER BY 1 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
