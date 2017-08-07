
CREATE PROCEDURE [dbo].[usp_ZoneUpdate] 
AS
BEGIN
	/* FOR CONED ACCOUNTS */
	UPDATE ACC
	SET ACC.Zone = TCA.LbmpZone
	FROM [lp_transactions].[dbo].[ConedAccount] TCA WITH (NOLOCK)
		INNER JOIN Account ACC WITH (NOLOCK)
		ON ACC.AccountNumber = TCA.AccountNumber
	WHERE (ACC.Zone is NULL or ACC.Zone = '')
	AND (TCA.LbmpZone is NOT NULL and TCA.LbmpZone <> '')
	
	/* FOR NIMO ACCOUNTS */
	UPDATE ACC
	SET ACC.Zone = TNA.ZoneCode
	FROM [lp_transactions].[dbo].[NimoAccount] TNA WITH (NOLOCK)
		INNER JOIN Account ACC WITH (NOLOCK)
		ON ACC.AccountNumber = TNA.AccountNumber
	WHERE (ACC.Zone is NULL or ACC.Zone = '')
	AND (TNA.ZoneCode is NOT NULL and TNA.ZoneCode <> '')
	
	/* FOR CENHUD ACCOUNTS */
	UPDATE ACC 
	SET ACC.Zone = TCH.ZoneCode
	FROM [lp_transactions].[dbo].[CenhudAccount] TCH WITH (NOLOCK)
	INNER JOIN Account ACC WITH (NOLOCK)
		ON ACC.AccountNumber = TCH.AccountNumber
	WHERE (ACC.Zone is NULL or ACC.Zone = '')
	AND (TCH.ZoneCode is NOT NULL and TCH.ZoneCode <> '')

	/*FOR REST OF ACCOUNTS*/
	UPDATE ACC
		SET ACC.Zone = EDI.ZoneCode	
	FROM [lp_transactions].[dbo].[EdiAccount] EDI WITH (NOLOCK)
	INNER JOIN Account ACC WITH (NOLOCK)
		ON ACC.AccountNumber = EDI.AccountNumber
	WHERE (ACC.Zone is NULL or ACC.Zone = '')
	AND (EDI.ZoneCode is NOT NULL and EDI.ZoneCode <> '')
	AND UtilityCode NOT IN ('CONED', 'NIMO', 'CENHUD')

	/* Ticket 1-60647891 Begin*/	
	--UPDATE THE LOAD PROFILE INFORMATION
	UPDATE ACC SET ACC.loadprofile = EDI.loadprofile 
	FROM libertypower..account ACC (updlock) 
	INNER JOIN lp_transactions..ediaccount EDI (nolock) on EDI.accountnumber= ACC.accountnumber
	AND EDI.ID						= (	SELECT MAX(ID)
										FROM lp_transactions..ediaccount EDIAUX (nolock)	
										WHERE  EDIAUX.AccountNumber = ACC.accountnumber
										AND isnull(EDIAUX.loadprofile,'')	<> '')
	WHERE acc.retailmktid= 16 and isnull(ACC.loadprofile,'')		= '' 
	/* Ticket 1-60647891 End */	
	
END