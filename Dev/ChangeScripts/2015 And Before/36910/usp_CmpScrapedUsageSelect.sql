USE [lp_transactions]

GO

Update Libertypower..Utility
SET		MultipleMeters = 1
WHERE	UtilityCode = 'CMP'


GO
/****** Object:  StoredProcedure [dbo].[usp_CmpScrapedUsageSelect]    Script Date: 04/03/2014 11:26:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_CmpScrapedSelect
 * Selects usage from the cmp scraped table
 *
 * History
 * 4-03-2014: add Created
 *******************************************************************************
 * 02-03-2011 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_CmpScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
/*
select * from CmpAccount (nolock) where accountnumber = '04411059126012' order by 3, 1 desc
select * from CmpUsage (nolock) where accountnumber = '04411059126012' order by 4 desc
usp_CmpScrapedUsageSelect '04411059126012', '2008-11-16', '2010-11-16'
*/
BEGIN
	SET NOCOUNT ON;

	SELECT	DISTINCT ID, AccountNumber, HighestDemandKw, RateCode, BeginDate, EndDate, Days, MeterNumber, TotalKwh, TotalUnmetered, TotalActiveUmetered, Created
	FROM	CmpUsage (nolock)
	WHERE	accountnumber = @AccountNumber
		AND BeginDate >= @BeginDate
		AND	EndDate <= @EndDate
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

