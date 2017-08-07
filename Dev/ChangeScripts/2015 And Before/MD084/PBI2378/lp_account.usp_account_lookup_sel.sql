USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_lookup_sel]    Script Date: 11/02/2012 12:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/22/2007
-- Description:	Account Lookups
-- =============================================
-- Author:		Eric Hernandez
-- Create date: 6/21/2011
-- Description:	Add lookup into renewal record.
-- =============================================
-- Author:		Eric Hernandez
-- Modify date: 5/8/2012
-- Description:	Fixed a bug which caused all accounts to show when no number match was found.
-- =============================================
-- Author:		Jose Munoz - SWCS
-- Modify date: 5/24/2012
-- Description:	Ticket 1-16221087
--				usp_account_lookup_sel "heavy" when Phone is used
--				(Remove the "OR" of the querys to allow the work of each index.)
-- =============================================
-- Author:		Cathy Ghazal
-- Modify date: 11/02/2012
-- Description:	MD084
--				use vw_AccountContractRate instead of AccountContractRate. Also get the max AccountContractRateID for isContractedRate=0
-- =============================================
/*

EXEC lp_account..[usp_account_lookup_sel] null, null
EXEC lp_account..[usp_account_lookup_sel] null, '2146371316'
EXEC lp_account..[usp_account_lookup_sel] '10443720009161132', NULL
EXEC lp_account..[usp_account_lookup_sel] '10443720009161132', '2146371316'

*/

ALTER procedure [dbo].[usp_account_lookup_sel]

@p_account_number	varchar(30),
@p_phone			varchar(20)

AS

IF LEN(@p_account_number) = 0
	SET @p_account_number = null

IF LEN(@p_phone) = 0
	SET @p_phone = null

IF (@p_account_number is null AND @p_phone is null)
	SELECT		account_number = NULL, full_name = NULL
ELSE
BEGIN

	/*
	-- search for account number
	
	CHANGED CODE IT79 IT079
	
	SELECT	DISTINCT a.account_number, n.full_name, c.phone,
			contract_status = 
			  case 
			   when r.account_id is not null then 'Contracted'
			   when p.isdefault = 0 and datediff(dd,getdate(),a.date_end) < 30 then 'Open'
			   when p.isdefault = 0 then 'Contracted'
			   when p.isdefault = 1 then 'Open'
			  end					
	FROM	account a (NOLOCK)
	LEFT JOIN account_renewal r (NOLOCK) on a.account_id = r.account_id AND r.sub_status NOT IN ('80','90')
	JOIN	account_name n (NOLOCK) ON a.account_id = n.account_id
	JOIN	account_contact c (NOLOCK) ON a.account_id = c.account_id
	JOIN	lp_common.dbo.common_product p on a.product_id = p.product_id
	WHERE	(a.account_number = @p_account_number OR @p_account_number is null)
	AND		(c.phone = @p_phone OR @p_phone is null)
	AND		a.status NOT IN ('911000', '999999', '999998')
	
	*/

	DECLARE @AccountID INT;
	--DECLARE @p_account_number	varchar(30);;
	--DECLARE  @p_phone			varchar(20);
	
	--SELECT TOP(1) * FROM Libertypower..account where account_id =  is not null 
	--SET @p_account_number = '033852001';
	-- DROP TABLE #TEMPTable;
	
	DECLARE @TEMPTable TABLE (account_number		VARCHAR(30)
								,full_name			VARCHAR(100)
								,phone				VARCHAR(20)
								,AccountID			INT
								,account_id			CHAR(12)
								,date_end			DATETIME
								,product_id			CHAR(20))
								
	-- search for account number
	IF @p_account_number IS NOT NULL
		SELECT @AccountID	= A.AccountID 
		FROM LibertyPower..Account A WITH (NOLOCK INDEX = UNQ__AccountNumber_UtilityID)
		WHERE AccountNumber = @p_account_number;

	IF NOT (@p_account_number IS NULL) AND NOT (@p_phone IS NULL)
		INSERT INTO @TEMPTable
		SELECT 	DISTINCT A.accountnumber AS account_number, 
						 n.full_name, 
						 c.phone,
						 A.AccountID AS AccountID,
						 A.AccountIDLegacy AS account_id,
						 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END AS date_end,
						 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id
		FROM LibertyPower..Account A  (NOLOCK)
		JOIN LibertyPower.dbo.AccountContract AC	WITH (NOLOCK)		
		ON A.AccountID				= AC.AccountID 
		AND A.CurrentContractID		= AC.ContractID
		JOIN LibertyPower.dbo.AccountStatus ACS	WITH (NOLOCK)			
		ON AC.AccountContractID		= ACS.AccountContractID
		JOIN LibertyPower.dbo.Customer CUST	WITH (NOLOCK)	
		ON A.CustomerID				= CUST.CustomerID
		JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	
		ON AC.AccountContractID		= ACR2.AccountContractID 
		--AND ACR2.IsContractedRate	= 1
		JOIN lp_account..account_name n (NOLOCK) 
		ON a.AccountNameID			= n.AccountNameID
		JOIN lp_account..account_contact c (NOLOCK) 
		ON CUST.ContactID			= c.AccountContactID
--		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)	
--		ON AC.AccountContractID		= AC_DefaultRate.AccountContractID 
--		AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later
		-- NEW DEFAULT RATE JOIN:
		LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
				   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
				   WHERE ACRR.IsContractedRate = 0 
				   GROUP BY ACRR.AccountContractID
				  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
		 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
		-- END NEW DEFAULT RATE JOIN:

		WHERE	(A.AccountID	= @AccountID) -- We replaced @AccountID with @p_account_number to address a bug.
		AND		(c.phone		= @p_phone)
		AND		ACS.[Status] NOT IN ('911000', '999999', '999998')

	IF NOT (@p_account_number IS NULL) AND (@p_phone IS NULL)
		INSERT INTO @TEMPTable
		SELECT 	DISTINCT A.accountnumber AS account_number, 
						 n.full_name, 
						 c.phone,
						 A.AccountID AS AccountID,
						 A.AccountIDLegacy AS account_id,
						 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END AS date_end,
						 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id
		FROM LibertyPower..Account A  (NOLOCK)
		JOIN LibertyPower.dbo.AccountContract AC	WITH (NOLOCK)		
		ON A.AccountID				= AC.AccountID 
		AND A.CurrentContractID		= AC.ContractID
		JOIN LibertyPower.dbo.AccountStatus ACS	WITH (NOLOCK)			
		ON AC.AccountContractID		= ACS.AccountContractID
		JOIN LibertyPower.dbo.Customer CUST				WITH (NOLOCK)	
		ON A.CustomerID				= CUST.CustomerID
		JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	
		ON AC.AccountContractID		= ACR2.AccountContractID 
		--AND ACR2.IsContractedRate	= 1
		JOIN account_name n (NOLOCK) 
		ON a.AccountNameID			= n.AccountNameID
		JOIN account_contact c (NOLOCK) 
		ON CUST.ContactID			= c.AccountContactID
		--LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)	
		--ON AC.AccountContractID		= AC_DefaultRate.AccountContractID 
		--AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later
		
		-- NEW DEFAULT RATE JOIN:
		LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
				   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
				   WHERE ACRR.IsContractedRate = 0 
				   GROUP BY ACRR.AccountContractID
				  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
		 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
		-- END NEW DEFAULT RATE JOIN:
		
		WHERE	(A.AccountID	= @AccountID) -- We replaced @AccountID with @p_account_number to address a bug.
		AND		ACS.[Status] NOT IN ('911000', '999999', '999998')
	
	IF (@p_account_number IS NULL) AND NOT (@p_phone IS NULL)
		INSERT INTO @TEMPTable
		SELECT 	DISTINCT A.accountnumber AS account_number, 
						 n.full_name, 
						 c.phone,
						 A.AccountID AS AccountID,
						 A.AccountIDLegacy AS account_id,
						 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END AS date_end,
						 CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id
		FROM LibertyPower..Account A  (NOLOCK)
		JOIN LibertyPower.dbo.AccountContract AC	WITH (NOLOCK)		
		ON A.AccountID				= AC.AccountID 
		AND A.CurrentContractID		= AC.ContractID
		JOIN LibertyPower.dbo.AccountStatus ACS	WITH (NOLOCK)			
		ON AC.AccountContractID		= ACS.AccountContractID
		JOIN LibertyPower.dbo.Customer CUST				WITH (NOLOCK)	
		ON A.CustomerID				= CUST.CustomerID
		JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	
		ON AC.AccountContractID		= ACR2.AccountContractID 
		--AND ACR2.IsContractedRate	= 1
		JOIN account_name n (NOLOCK) 
		ON a.AccountNameID			= n.AccountNameID
		JOIN account_contact c (NOLOCK) 
		ON CUST.ContactID			= c.AccountContactID
		--LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)	
		--ON AC.AccountContractID		= AC_DefaultRate.AccountContractID 
		--AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later
		
		-- NEW DEFAULT RATE JOIN:
		LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
				   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
				   WHERE ACRR.IsContractedRate = 0 
				   GROUP BY ACRR.AccountContractID
				  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
		 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
		-- END NEW DEFAULT RATE JOIN:
		
		WHERE	(c.phone		= @p_phone)
		AND		ACS.[Status] NOT IN ('911000', '999999', '999998')	

	--	The "top 10" is included as a failsafe, to make sure we don't show more accounts than necessary.
	SELECT	DISTINCT TOP 10 a.account_number, a.full_name, a.phone,
		contract_status = 
		case 
		when r.account_id is not null then 'Contracted'
		when p.isdefault = 0 and datediff(dd,getdate(),a.date_end) < 30 then 'Open'
		when p.isdefault = 0 then 'Contracted'
		when p.isdefault = 1 then 'Open'
		end			
	FROM @TEMPTable a
	JOIN	lp_common.dbo.common_product p (NOLOCK) on a.product_id = p.product_id
	LEFT JOIN account_renewal r (NOLOCK) on a.account_id = r.account_id AND r.sub_status NOT IN ('80','90')
	
	
	---  SELECT TOP(10) account_id, account_number  FROM lp_account..account (NOLOCK) WHERE status NOT IN ('911000', '999999', '999998')
	
END


