Use LibertyPower

GO

  /****************************************************************************************/
 /*********************************   usp_MtMMonthlyAccountForecastCreate*****************/
/****************************************************************************************/

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		Get the montly whole account forecast											*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE	usp_MtMMonthlyAccountForecastCreate
(	@BatchNumber AS VARCHAR(50),
	@QuoteNumber AS VARCHAR(50)
)
AS

--First get the Montly retail account forecast which is the result of aggregating the account’s DRAF (R.O.) at the calendar month level.
SELECT	a.ID, a.AccountID, a.ContractID,
		CAST((CAST(MONTH(f.UsageDate) as VARCHAR(2)) + '/01/' + CAST(YEAR(f.UsageDate) as VARCHAR(4))) AS DATETIME) as UsageMonth, 
		SUM(f.Peak) as Peak, 
		SUM(f.OffPeak) as OffPeak
INTO	#MRAF
FROM	MtMDailyLoadForecast f
INNER	JOIN MtMAccount a
ON		f.MtMAccountID = a.ID
WHERE	a.BatchNumber = @BatchNumber
AND		a.QuoteNumber = @QuoteNumber
GROUP	BY 
		a.ID, a.AccountID, a.ContractID,
		CAST((CAST(MONTH(f.UsageDate) as VARCHAR(2)) + '/01/' + CAST(YEAR(f.UsageDate) as VARCHAR(4))) AS DATETIME)

-- Get Loss Factors--------------------------------------------------------------------------
/*
the effective date in all the files should be matched to the date_deal of the contract. 
The effective date should be the least great date than the date_deal. 
If date_deal is 6/15, and effective dates are 7/1 and 8/1, the effective date to be used is 7/1.
If no match was found, the effective date to be used, will the most recent one from the file.
*/
SELECT	a.UtilityID as UtilityID, MIN(s.EffectiveDate) as EffectiveDate, 0.00000 as Secondary
INTO	#Loss
FROM	MtMLossFactors s
RIGHT	JOIN (	SELECT	u.UtilityCode as UtilityID, c.SignedDate as DealDate
				FROM	#MRAF m

				INNER	JOIN Account a
				ON		m.AccountID = a.AccountID

				INNER	JOIN	Contract c
				ON		m.ContractID = c.ContractID

				INNER	JOIN LibertyPower..Utility u
				ON		u.ID = a.UtilityID
			) a
ON		s.UtilityID = a.UtilityID
AND		s.EffectiveDate >= a.DealDate
		
GROUP	BY a.UtilityID

--get the max date		
UPDATE	t1
SET		t1.EffectiveDate = t2.EffectiveDate
FROM	#Loss t1
INNER	JOIN 
		(
			SELECT	l.UtilityID, MAX(EffectiveDate) as EffectiveDate
			FROM	[LibertyPower].[dbo].[MtMLossFactors] l
			GROUP	BY l.UtilityID
		) t2
ON		t1.UtilityID = t2.UtilityID
WHERE	t1.EffectiveDate IS NULL

-- get the secondary data
UPDATE	t1
SET		t1.Secondary = t2.Secondary
FROM	#Loss t1
INNER	JOIN [LibertyPower].[dbo].[MtMLossFactors] t2
ON		t1.UtilityID = t2.UtilityID
WHERE	t1.EffectiveDate = t2.EffectiveDate 
-------------------------------------------------------------------------------------------------				

--adjust the data for losses which will result in MWAF: montly whole sale account forecast
INSERT	INTO MtMMonthlyLoadForecast
	 (
		MtMAccountID,
		UsageMonth, 
		Peak,
		OffPeak/*,
		[Status]*/
	)
SELECT	m.ID,
		UsageMonth, 
		Peak*(1+Secondary) as Peak,
		OffPeak*(1+Secondary)as OffPeak/*,
		'New'*/
FROM	#MRAF m

INNER	JOIN Account a
ON		m.AccountID = a.AccountID

INNER	JOIN Utility u
ON		u.ID = a.UtilityID

INNER	JOIN #Loss l
ON		u.UtilityCode = l.UtilityID


GO

  /******************************************************************************************************/
 /*********************************    usp_MtMAccountGet   *********************************/
/******************************************************************************************************/

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		Get the list of the accounts from the MtMAccount talbe							*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMAccountGet

	@Status as VARCHAR(10),
	@ProxiedZone AS BIT,
	@ProxiedProfile AS BIT,
	@ProxiedUsage AS BIT
	
AS

BEGIN

	SELECT	DISTINCT 
			AccountID
	FROM	MtMAccount a
	WHERE	[Status] = @Status
	AND		(ProxiedZone = @ProxiedZone OR ProxiedProfile = @ProxiedProfile OR ProxiedUsage = @ProxiedUsage)

END


GO

  /******************************************************************************************************/
 /*********************************    usp_MtMAccountGetBatches        *********************************/
/******************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		Get the list of batches processed for MtM on a certain date						*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_MtMAccountGetBatches

	@ProcessDate as DATETIME,
	@Status as VARCHAR(10)
	
	
AS

BEGIN

	SELECT	DISTINCT 
			BatchNumber, QuoteNumber
	FROM	MtMAccount a
	WHERE	[Status] = @Status
	AND		MONTH(@ProcessDate) = MONTH(a.DateCreated)
	AND		DAY(@ProcessDate) = DAY(a.DateCreated)
	AND		YEAR(@ProcessDate) = YEAR(a.DateCreated)

END


GO

  /****************************************************************************************/
 /*********************************    usp_MTMAccountUpdateStatus ************************/
/****************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		Update the status																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE	usp_MtMAccountStatusUpdate
(	@BatchNumber AS VARCHAR(50),
	@QuoteNumber AS VARCHAR(50),
	@Status AS VARCHAR(50)
)
AS

BEGIN

	UPDATE	m
	SET		m.Status = @Status,
			m.DateModified = GETDATE()
	FROM	MTMAccount m
	WHERE	BatchNumber = @BatchNumber
	AND		QuoteNumber = @QuoteNumber
END

GO

