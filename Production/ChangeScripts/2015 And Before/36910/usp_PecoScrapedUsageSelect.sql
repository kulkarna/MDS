USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_PecoScrapedUsageSelect]    Script Date: 04/03/2014 11:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_PecoScrapedUsageSelect
 * Selects usage from the peco scraped table
 *
 * History
 *04-03-2014: add created
 *******************************************************************************
 * 02-03-2011 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_PecoScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
/*
select * from PecoAccount (nolock) where accountnumber = '0217201203' order by 1 desc
select * from PecoUsage (nolock) where accountnumber = '0217201203' order by 2, 3 desc
usp_PecoScrapedUsageSelect '04411059126012', '2008-11-16', '2010-11-16'
*/
BEGIN
	SET NOCOUNT ON;

	SELECT	DISTINCT ID, AccountNumber, FromDate, ToDate, Usage, Demand, Created
	FROM	PecoUsage (nolock)
	WHERE	accountnumber = @AccountNumber
		AND FromDate >= @BeginDate
		AND	ToDate <= @EndDate
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

