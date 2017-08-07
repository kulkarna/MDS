/*******************************************************************************
 * usp_GetAccountUsageComplete
 * To retrieve all records in consolidated usage table
 *
 * History
 *******************************************************************************
 * 5/15/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GetAccountUsageComplete]                                                                                     
	@AccountNumber	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT		ID, AccountNumber, UtilityCode, 
				CAST(CAST(DATEPART(mm, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, FromDate) AS varchar(4)) AS datetime) AS FromDate,
				CAST(CAST(DATEPART(mm, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, ToDate) AS varchar(4)) AS datetime) AS ToDate,	
				TotalKwh, DaysUsed, MeterNumber, OnPeakKWH, TransactionNumber,
				OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Created, CreatedBy, UsageType, UsageSource
	FROM		Usage WITH (NOLOCK)
	WHERE		accountnumber	= @AccountNumber
	AND			FromDate		>= '2009-01-01' -- no 2008 usage	
	ORDER BY	FromDate

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
