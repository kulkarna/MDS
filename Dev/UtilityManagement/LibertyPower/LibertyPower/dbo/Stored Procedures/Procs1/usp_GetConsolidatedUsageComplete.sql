
/*******************************************************************************
 * usp_GetConsolidatedUsageComplete
 * retrieves all available usage from the consolidated usage table
 *
 * History
 *
 *******************************************************************************
 * 12/02/2010 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_GetConsolidatedUsageComplete] (
	@AccountNumber	varchar(50) )
AS
/*
select * from usageconsolidated where accountnumber = '1129941118'

exec libertypower..usp_GetConsolidatedUsageComplete '1129941118'

declare	@AccountNumber	varchar(50)
set		@AccountNumber = '10032789430152011'
*/

BEGIN
	SET NOCOUNT ON;

--	note that i had to convert UT and US to int since they are defined as INTegers in the FWK
	SELECT	ID, AccountNumber, UtilityCode,
			CAST(CAST(DATEPART(mm, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, FromDate) AS varchar(4)) AS datetime) AS FromDate,
			CAST(CAST(DATEPART(mm, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, ToDate) AS varchar(4)) AS datetime) AS ToDate,	
			TotalKwh, DaysUsed, Created, CreatedBy, convert (int, UsageType) UsageType, convert (int, UsageSource) UsageSource
	FROM	UsageConsolidated (NOLOCK)
	WHERE	accountnumber = @AccountNumber
		AND	Active = 1
	ORDER BY fromdate DESC

	SET NOCOUNT OFF;
END

-- Copyright 2010 Liberty Power

