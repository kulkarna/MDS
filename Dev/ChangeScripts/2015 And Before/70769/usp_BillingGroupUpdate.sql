USE LIBERTYPOWER
GO
-- ==================================================
-- Author: Al Tafur
-- Date:   11/28/2012
-- Comments: This proc will be called by a schedulled job to update regularly the billing group once it becomes available.  
--                   It will only update the billinggroup if not has been assigned
-- ==================================================
-- Modify: Jose Munoz SWCS
-- Date:   12/06/2012
-- Comments: Change the update

/*
     Modify Details
     
     * 07/16/2015 - Vikas Sharma Add sections for Bill Group update for RGE And Nyseg Accounts
*/
-- ==================================================
-- EXEC [dbo].[usp_BillingGroupUpdate] 
-- SELECT *	FROM lp_historical_info..zScraperUtilities A WITH (NOLOCK)
-- SELECT *	FROM libertypower..Utility A WITH (NOLOCK)
ALTER PROCEDURE [dbo].[usp_BillingGroupUpdate] 
AS
BEGIN

	/* SELECT SCRAPPABLES UTILITIES */
	SELECT B.ID 
	INTO #ScrappableUtilities
	FROM lp_historical_info..zScraperUtilities A WITH (NOLOCK)
	INNER JOIN LibertyPower..Utility B WITH (NOLOCK)
	ON B.UtilityCode		= A.Utility_id
	WHERE A.Utility_id		NOT IN ('NYSEG', 'RGE')

	/* FOR SCRAPPABLES ACCOUNTS */
	UPDATE Libertypower..Account
	SET billinggroup		= T1.billgroup	
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN libertypower..accountusage  AU WITH (NOLOCK)
	ON AU.accountid			= A.accountid
	INNER JOIN lp_transactions.dbo.EdiAccount T1 WITH (NOLOCK)
	ON T1.accountnumber		= A.accountnumber
	INNER JOIN lp_transactions..EdiFileLog T2 WITH (NOLOCK)
	ON T2.id				= T1.edifilelogid 
	WHERE ((A.billinggroup	IS NULL) OR (A.billinggroup = ''))
	AND A.UtilityId			NOT IN (SELECT ID FROM #ScrappableUtilities WITH (NOLOCK))
	AND AU.annualusage		<> 0
	AND T1.billgroup		NOT IN (-1,0)
	
	/* FOR COMED ACCOUNTS */
	UPDATE Libertypower..Account
	SET BillingGroup			= C.MeterBillGroupNumber
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN libertypower..accountusage  AU WITH (NOLOCK)
	ON AU.accountid				= A.accountid
	INNER JOIN lp_transactions..ComedAccount C WITH (NOLOCK)
	ON C.AccountNumber			= A.AccountNumber
	WHERE ((A.billinggroup		IS NULL) OR (A.billinggroup = ''))
	AND A.UtilityId				= (	SELECT ID FROM Libertypower..Utility WITH (NOLOCK)
									WHERE UtilityCode		= 'COMED')
	AND AU.annualusage			<> 0
	AND C.MeterBillGroupNumber	NOT IN (-1,0)
	AND C.id					= (	SELECT MAX(D.id) FROM lp_transactions..ComedAccount D WITH (NOLOCK)
									WHERE D.AccountNumber		= C.AccountNumber
									AND D.MeterBillGroupNumber	NOT IN (-1,0))
	
	/* FOR CONED ACCOUNTS */
	UPDATE Libertypower..Account
	SET BillingGroup			= C.TripNumber
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN libertypower..accountusage  AU WITH (NOLOCK)
	ON AU.accountid				= A.accountid
	INNER JOIN lp_transactions..ConedAccount C WITH (NOLOCK)
	ON C.AccountNumber			= A.AccountNumber
	WHERE ((A.billinggroup		IS NULL) OR (A.billinggroup = ''))
	AND A.UtilityId				= (	SELECT ID FROM Libertypower..Utility WITH (NOLOCK)
									WHERE UtilityCode		= 'CONED')
	AND AU.annualusage			<> 0
	AND C.TripNumber			NOT IN (-1,0)
	AND C.ID					= (	SELECT MAX(D.ID) FROM lp_transactions..ConedAccount D WITH (NOLOCK)
									WHERE D.AccountNumber		= C.AccountNumber
									AND D.TripNumber			NOT IN (-1,0))
									
	/* FOR AMEREN ACCOUNTS */
	UPDATE Libertypower..Account   
	SET BillingGroup			= C.BillGroup
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN libertypower..accountusage  AU WITH (NOLOCK)
	ON AU.accountid				= A.accountid
	INNER JOIN lp_transactions..AmerenAccount C WITH (NOLOCK)
	ON C.AccountNumber			= A.AccountNumber
	WHERE ((A.billinggroup		IS NULL) OR (A.billinggroup = ''))
	AND A.UtilityId				= (	SELECT ID FROM Libertypower..Utility WITH (NOLOCK)
									WHERE UtilityCode		= 'AMEREN')
	AND AU.annualusage			<> 0
	AND C.BillGroup			NOT IN (-1,0)
	AND C.ID					= (	SELECT MAX(D.ID) FROM lp_transactions..AmerenAccount D WITH (NOLOCK)
									WHERE D.AccountNumber		= C.AccountNumber
									AND D.BillGroup			NOT IN (-1,0))

	/* FOR BGE ACCOUNTS */
	UPDATE Libertypower..Account   
	SET BillingGroup			= C.BillGroup
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN libertypower..accountusage  AU WITH (NOLOCK)
	ON AU.accountid				= A.accountid
	INNER JOIN lp_transactions..BgeAccount C WITH (NOLOCK)
	ON C.AccountNumber			= A.AccountNumber
	WHERE ((A.billinggroup		IS NULL) OR (A.billinggroup = ''))
	AND A.UtilityId				= (	SELECT ID FROM Libertypower..Utility WITH (NOLOCK)
									WHERE UtilityCode		= 'BGE')
	AND AU.annualusage			<> 0
	AND C.BillGroup			NOT IN (-1,0)
	AND C.ID					= (	SELECT MAX(D.ID) FROM lp_transactions..BgeAccount D WITH (NOLOCK)
									WHERE D.AccountNumber		= C.AccountNumber
									AND D.BillGroup			NOT IN (-1,0))


	/* FOR CENHUD ACCOUNTS */
	UPDATE Libertypower..Account   
	SET BillingGroup			= C.BillCycle
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN libertypower..accountusage  AU WITH (NOLOCK)
	ON AU.accountid				= A.accountid
	INNER JOIN lp_transactions..CenhudAccount C WITH (NOLOCK)
	ON C.AccountNumber			= A.AccountNumber
	WHERE ((A.billinggroup		IS NULL) OR (A.billinggroup = ''))
	AND A.UtilityId				= (	SELECT ID FROM Libertypower..Utility WITH (NOLOCK)
									WHERE UtilityCode		= 'CENHUD')
	AND AU.annualusage			<> 0
	AND C.BillCycle				NOT IN (-1,0)
	AND C.ID					= (	SELECT MAX(D.ID) FROM lp_transactions..CenhudAccount D WITH (NOLOCK)
									WHERE D.AccountNumber		= C.AccountNumber
									AND D.BillCycle				NOT IN (-1,0))
	
		/* FOR RGE ACCOUNTS */
	UPDATE Libertypower..Account   
	SET BillingGroup			= C.BillGroup
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN libertypower..accountusage  AU WITH (NOLOCK)
	ON AU.accountid				= A.accountid
	INNER JOIN lp_transactions..RgeAccount C WITH (NOLOCK)
	ON C.AccountNumber			= A.AccountNumber
	WHERE ((A.billinggroup		IS NULL) OR (A.billinggroup = ''))
	AND A.UtilityId				= (	SELECT ID FROM Libertypower..Utility WITH (NOLOCK)
									WHERE UtilityCode		= 'RGE')
	AND AU.annualusage			<> 0
	AND C.BillGroup			NOT IN (-1,0)
	AND C.ID					= (	SELECT MAX(D.ID) FROM lp_transactions..BgeAccount D WITH (NOLOCK)
									WHERE D.AccountNumber		= C.AccountNumber
									AND D.BillGroup			NOT IN (-1,0))
	
	
			/* FOR NYSEG ACCOUNTS */
	UPDATE Libertypower..Account   
	SET BillingGroup			= C.BillGroup
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN libertypower..accountusage  AU WITH (NOLOCK)
	ON AU.accountid				= A.accountid
	INNER JOIN lp_transactions..NysegAccount C WITH (NOLOCK)
	ON C.AccountNumber			= A.AccountNumber
	WHERE ((A.billinggroup		IS NULL) OR (A.billinggroup = ''))
	AND A.UtilityId				= (	SELECT ID FROM Libertypower..Utility WITH (NOLOCK)
									WHERE UtilityCode		= 'NYSEG')
	AND AU.annualusage			<> 0
	AND C.BillGroup			NOT IN (-1,0)
	AND C.ID					= (	SELECT MAX(D.ID) FROM lp_transactions..BgeAccount D WITH (NOLOCK)
									WHERE D.AccountNumber		= C.AccountNumber
									AND D.BillGroup			NOT IN (-1,0))
	
	/*
		UPDATE		a
		SET			billinggroup = t1.billgroup
		FROM		lp_transactions.dbo.EdiAccount (nolock) t1 
		JOIN			lp_transactions..EdiFileLog (nolock) t2 on t2.id = edifilelogid 
		JOIN			libertypower..account			a (nolock)  on t1.accountnumber = a.accountnumber
		JOIN			libertypower..accountusage		au (nolock)	on		a.accountid = au.accountid
		WHERE		t1.billgroup NOT IN (-1,0)
		AND			(a.billinggroup is null or a.billinggroup = '')
	    AND			au.annualusage <> 0
	*/
	
END


