USE [lp_historical_info]
GO
/****** Object:  StoredProcedure [dbo].[usp_usage_acquire_accounts_sel]    Script Date: 10/18/2016 13:40:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:        Rick Deigsler  
-- Create date: 11/9/2007  
-- Description:   Get accounts for specified utility that need usage  
  
-- Modified 5/8/2009 - Rick Deigsler  
-- Changed to pull accounts form Offer Engine  
  
-- Modified 5/11/2010 - Rick Deigsler  
-- Added zip from OE  
  
-- Modified 05/20/2011 - Eduardo Patino  
-- IT022 - added account_id to resultset  
  
-- EXEC usp_usage_acquire_accounts_sel_WPOLLACK '148', 'ENROLLMENT';  
-- EXEC usp_usage_acquire_accounts_sel  '148', 'ENROLLMENT';  
  
-- Modified 2/2/2012 -- Wayne Pollack  
-- Refactored Select statements for 'Renewal'  

-- Modified 6/10/2013 -- Rafael Vasques  
-- Refactored to use the tables instead of view.
-- SR#1-138152491

--  Modifed 18/10/2016 -- vikas sharma
--  Handle case when utility is invalid
-- PBI 124291
-- =============================================  
ALTER PROCEDURE [dbo].[usp_usage_acquire_accounts_sel]  
(@p_utility_id       char(15),  
 @p_process          varchar(25),  
 @p_account_number varchar(30) = '')  
  
  AS  
  
  -- usp_usage_acquire_accounts_sel_WPOLLACK 'AMEREN', 'ENROLLMENT';  
  -- usp_usage_acquire_accounts_sel_WPOLLACK 'AMEREN', 'RENEWAL';  
  -- usp_usage_acquire_accounts_sel '147', 'ENROLLMENT';  
  -- usp_usage_acquire_accounts_sel 'AMEREN', 'RENEWAL';  
      
  
  -- usp_usage_acquire_accounts_sel_WPOLLACK 'COMED', 'ENROLLMENT';  
  -- usp_usage_acquire_accounts_sel_WPOLLACK 'COMED', 'RENEWAL';  
  -- usp_usage_acquire_accounts_sel 'COMED', 'ENROLLMENT';  
  -- usp_usage_acquire_accounts_sel 'COMED', 'RENEWAL';  
    
     
  -- usp_usage_acquire_accounts_sel_WPOLLACK 'PPL', 'ENROLLMENT';  
  -- usp_usage_acquire_accounts_sel_WPOLLACK 'PPL', 'RENEWAL';  
  -- usp_usage_acquire_accounts_sel 'PPL', 'ENROLLMENT';  
  -- usp_usage_acquire_accounts_sel 'PPL', 'RENEWAL';  
  -- meter number required  
    
-- Select top 100 * from libertypower.dbo.account  
-- Select * from libertypower.dbo.utility  
  
SET NOCOUNT ON;  
  
IF (SELECT meter_number_required FROM lp_common..common_utility WITH (NOLOCK) WHERE utility_id = @p_utility_id) = 1  
BEGIN  
    IF @p_process = 'ENROLLMENT'  
    BEGIN  
		-- Scraping single account 
		
		 
		IF LEN(@p_account_number) > 0  
		BEGIN  
			SELECT a.accountnumber, a.accountidlegacy, A.CurrentContractID, A.ServiceAddressID, A.AccountNameID  
			INTO #Account  
             
            FROM LibertyPower..Account A (NOLOCK)   
            inner join C U With(nolock) on a.UtilityID = UtilityID
            WHERE A.AccountNumber   = @p_account_number  
            and u.utilitycode = @p_utility_id;

			SELECT LTRIM(RTRIM(a.accountnumber)) AS account_number,  
				(LTRIM(RTRIM(ISNULL(b.Address1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.Address2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.city, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.state, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.zip, '')))) as service_address,   
                LTRIM(RTRIM(ISNULL(b.zip, ''))) AS zip, LTRIM(RTRIM(ISNULL(REPLACE(c.Name, '&', 'and'), ''))) AS full_name,  
                LTRIM(RTRIM(ISNULL(e.meter_number, ''))) AS meter_number,  
                '' AS deal_id,  
                CONT.Number AS contract_nbr,  
                a.accountidlegacy as account_id  
            FROM  -- lp_account..account a WITH (NOLOCK)  
            #Account A (NOLOCK)   
            JOIN LibertyPower..[Contract] CONT (NOLOCK)  ON A.CurrentContractID = CONT.ContractID   
            LEFT JOIN libertypower..Address b WITH (NOLOCK) ON a.ServiceAddressID = b.AddressID  
            left JOIN libertypower..Name c WITH (NOLOCK) ON a.AccountNameID = c.NameID   
            LEFT JOIN   lp_account..account_meters e WITH (NOLOCK) ON A.AccountIdLegacy = e.account_id  
		END  
		ELSE  
		BEGIN  
		 
		 
			SELECT      LTRIM(RTRIM(a.accountnumber)) AS account_number,  
				(LTRIM(RTRIM(ISNULL(b.Address1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.Address2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.city, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.state, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.zip, '')))) as service_address,   
				LTRIM(RTRIM(ISNULL(b.zip, ''))) AS zip,   
				LTRIM(RTRIM(ISNULL(REPLACE(c.Name, '&', 'and'), ''))) AS full_name,   
				LTRIM(RTRIM(ISNULL(e.meter_number, ''))) AS meter_number,  
				'' AS deal_id,  
				CONT.Number AS contract_nbr,  
				a.accountidlegacy AS account_id  
			FROM  LibertyPower..Account A (NOLOCK)   
			JOIN LibertyPower..[Contract] CONT (NOLOCK)  ON A.CurrentContractID = CONT.ContractID   
			JOIN lp_enrollment..check_account d WITH (NOLOCK) ON CONT.Number = d.contract_nbr  
			JOIN LibertyPower..Utility U (NOLOCK)           ON A.UtilityID  = U.ID  
			JOIN LibertyPower..AccountContract AC (NOLOCK)          ON A.AccountID = AC.AccountID AND CONT.ContractID = AC.ContractID  
			JOIN LibertyPower..AccountStatus  ST (NOLOCK)            ON AC.AccountContractID = ST.AccountContractID  
			JOIN LibertyPower..AccountUsage  AU (NOLOCK)            ON A.AccountID = AU.AccountID AND CONT.StartDAte = AU.EffectiveDate  
			LEFT JOIN libertypower..Address b WITH (NOLOCK) ON a.ServiceAddressID = b.AddressID  
			left JOIN libertypower..Name c WITH (NOLOCK) ON a.AccountNameID = c.NameID    
			LEFT JOIN   lp_account..account_meters e WITH (NOLOCK) ON a.AccountIdLegacy = e.account_id                                                                                                                     

			WHERE d.check_type            = 'USAGE ACQUIRE'  
			AND         (d.approval_status      = 'PENDING' OR d.approval_status = 'INCOMPLETE')  
			AND         U.UtilityCode           = @p_utility_id  
			AND         AU.annualusage          = 0  
			AND         ST.[status]             NOT IN ('911000','999998','999999');  
		END  
	END  
	ELSE IF @p_process = 'RENEWAL'  
	BEGIN  
		-- Scraping single account  
		IF LEN(@p_account_number) > 0  
		BEGIN  
			SELECT LTRIM(RTRIM(a.accountnumber)) AS account_number,   
			(LTRIM(RTRIM(ISNULL(b.Address1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.Address2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.city, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.state, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.zip, '')))) as service_address,   
			LTRIM(RTRIM(ISNULL(b.zip, ''))) AS zip,   
			LTRIM(RTRIM(ISNULL(REPLACE(c.Name, '&', 'and'), ''))) AS full_name,   
			LTRIM(RTRIM(ISNULL(e.meter_number, ''))) AS meter_number,  
			'' AS deal_id,   
			CONT.Number AS contract_nbr,  
			a.accountIdlegacy AS account_id  
			FROM LibertyPower..Account AS a WITH (NOLOCK)  
			JOIN LibertyPower..[Contract] CONT (NOLOCK)  ON a.CurrentRenewalContractID = CONT.ContractID   
			LEFT JOIN libertypower..Address b WITH (NOLOCK) ON a.ServiceAddressID = b.AddressID   
			left JOIN libertypower..Name c WITH (NOLOCK) ON a.AccountNameID = c.NameID  
			LEFT JOIN   lp_account..account_meters e WITH (NOLOCK) ON a.AccountIdLegacy = e.account_id                                                                                                                          

			WHERE a.AccountNumber = @p_account_number;  
		END  
		ELSE  
		BEGIN  
			SELECT LTRIM(RTRIM(a.accountNumber)) AS account_number,   
				(LTRIM(RTRIM(ISNULL(b.Address1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.Address2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.city, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.state, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.zip, '')))) as service_address,   
				LTRIM(RTRIM(ISNULL(b.zip, ''))) AS zip,   
				LTRIM(RTRIM(ISNULL(REPLACE(c.full_name, '&', 'and'), ''))) AS full_name,   
				LTRIM(RTRIM(ISNULL(e.meter_number, ''))) AS meter_number,  
				'' AS deal_id,   
				CONT.Number AS contract_nbr,    
				a.accountID  
			FROM LibertyPower..Account AS a WITH (NOLOCK)  
			JOIN LibertyPower..[Contract] AS CONT      WITH (NOLOCK) ON a.CurrentRenewalContractID = CONT.ContractID  
			JOIN lp_enrollment..check_account AS d     WITH (NOLOCK) ON CONT.Number = d.contract_nbr  
			JOIN LibertyPower..Utility AS U WITH (NOLOCK) ON A.UtilityID  = U.ID  
			JOIN LibertyPower..AccountContract AS AC   WITH (NOLOCK) ON A.AccountID = AC.AccountID AND CONT.ContractID = AC.ContractID  
			JOIN LibertyPower..AccountStatus  AS ST    WITH (NOLOCK) ON AC.AccountContractID = ST.AccountContractID  
			JOIN LibertyPower..AccountUsage  AS AU     WITH (NOLOCK) ON A.AccountID = AU.AccountID AND CONT.StartDAte = AU.EffectiveDate  
			LEFT JOIN libertypower..Address b WITH (NOLOCK) ON a.ServiceAddressID = b.AddressID  
			LEFT JOIN lp_account..account_renewal_name AS c WITH (NOLOCK) ON a.accountID = c.account_id AND a.accountNameID = c.name_link  
			LEFT JOIN lp_account..account_meters AS e  WITH (NOLOCK) ON a.AccountIdLegacy = e.account_id   
			WHERE d.check_type = 'USAGE ACQUIRE'  
			AND (d.approval_status = 'PENDING' OR d.approval_status = 'INCOMPLETE')  
			AND U.UtilityCode = @p_utility_id;  
		END  
	END  
END  
--------------------------------------------------------------------------------- no meter number  
ELSE  
BEGIN  
	IF @p_process = 'ENROLLMENT'  
	BEGIN  
	  
	if not exists( select 1 from libertypower..Utility(NOLOCK) U where UtilityCode=@p_utility_id)
		 begin 
		 
		 RAISERROR(N'Invalid Utility',16,1)

		 End 
	   
		-- Scraping single account  
		IF LEN(@p_account_number) > 0  
		BEGIN  
			SELECT      LTRIM(RTRIM(a.accountnumber)) AS account_number,   
			(LTRIM(RTRIM(ISNULL(b.Address1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.Address2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.city, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.state, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.zip, '')))) as service_address,   
			LTRIM(RTRIM(ISNULL(b.zip, ''))) AS zip,   
			LTRIM(RTRIM(ISNULL(REPLACE(c.Name, '&', 'and'), ''))) AS full_name,   
			'' AS meter_number,   
			'' AS deal_id,   
			CONT.Number AS contract_nbr,  
			a.accountidlegacy AS account_id   
			FROM  LibertyPower..Account A (NOLOCK)   
			JOIN LibertyPower..[Contract] CONT (NOLOCK)  ON A.CurrentContractID = CONT.ContractID   
			LEFT JOIN libertypower..Address b WITH (NOLOCK) ON a.ServiceAddressID = b.AddressID  
			left JOIN libertypower..Name c WITH (NOLOCK) ON a.AccountNameID = c.NameID  
			-- LEFT JOIN   lp_account..account_meters e WITH (NOLOCK) ON a.AccountIdLegacy = e.account_id  
			WHERE A.AccountNumber   = @p_account_number;                                    
		END  
		ELSE  
		BEGIN  
			SELECT      LTRIM(RTRIM(a.AccountNumber)) AS account_number,   
			(LTRIM(RTRIM(ISNULL(b.Address1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.Address2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.city, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.state, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.zip, '')))) as service_address,   
			LTRIM(RTRIM(ISNULL(b.zip, ''))) AS zip,   
			LTRIM(RTRIM(ISNULL(REPLACE(c.Name, '&', 'and'), ''))) AS full_name,   
			'' AS meter_number,   
			'' AS deal_id,   
			CONT.Number AS contract_nbr,  
			A.AccountIdLegacy AS account_id  
			FROM  LibertyPower..Account AS a (NOLOCK)   
			JOIN LibertyPower..[Contract] CONT WITH (NOLOCK)   ON a.CurrentContractID = CONT.ContractID   
			JOIN  lp_enrollment..check_account d WITH (NOLOCK) ON CONT.Number = d.contract_nbr  
			JOIN LibertyPower..Utility U  WITH(NOLOCK)         ON a.UtilityID  = U.ID  
			JOIN LibertyPower..AccountContract AC WITH(NOLOCK) ON a.AccountID = AC.AccountID AND CONT.ContractID = AC.ContractID  
			JOIN LibertyPower..AccountStatus  ST WITH (NOLOCK) ON AC.AccountContractID = ST.AccountContractID  
			JOIN LibertyPower..AccountUsage  AU WITH (NOLOCK)  ON a.AccountID = AU.AccountID AND CONT.StartDAte = AU.EffectiveDate  
			LEFT JOIN libertypower..Address b WITH (NOLOCK) ON a.ServiceAddressID = b.AddressID   
			left JOIN libertypower..Name c WITH (NOLOCK) ON a.AccountNameID = c.NameID    
			-- LEFT JOIN lp_account..account_meters e WITH (NOLOCK) ON a.AccountIdLegacy = e.account_id            
			WHERE d.check_type = 'USAGE ACQUIRE'  
			AND         (d.approval_status      = 'PENDING' OR d.approval_status = 'INCOMPLETE')  
			AND         U.UtilityCode   = @p_utility_id  
			AND         AU.annualusage          = 0  
			AND         ST.[status]             NOT IN ('911000','999998','999999');  


		END  
	END  
	ELSE IF @p_process = 'RENEWAL'  
	BEGIN  
		-- Scraping single account  
		IF LEN(@p_account_number) > 0  
		BEGIN  
			SELECT LTRIM(RTRIM(a.accountNumber)) AS account_number,   
			(LTRIM(RTRIM(ISNULL(b.Address1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.Address2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.city, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.state, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.zip, '')))) as service_address,   
			LTRIM(RTRIM(ISNULL(b.zip, ''))) AS zip,   
			LTRIM(RTRIM(ISNULL(REPLACE(c.Name, '&', 'and'), ''))) AS full_name,   
			'' AS meter_number,  
			'' AS deal_id,   
			CONT.Number AS contract_nbr,  
			a.accountIdLegacy AS account_id   
			FROM  LibertyPower..Account AS a (NOLOCK)   
			JOIN LibertyPower..[Contract] CONT (NOLOCK) ON a.CurrentRenewalContractID = CONT.ContractID   
			LEFT JOIN libertypower..Address b WITH (NOLOCK) ON a.ServiceAddressID = b.AddressID   
			left JOIN libertypower..Name c WITH (NOLOCK) ON a.AccountNameID = c.NameID   
			-- LEFT JOIN   lp_account..account_meters e WITH (NOLOCK) ON a.AccountIdLegacy = e.account_id  
			WHERE a.accountNumber  =  @p_account_number;  
		END  
		ELSE  
		BEGIN  
			SELECT LTRIM(RTRIM(a.accountNumber)) AS account_number,   
			(LTRIM(RTRIM(ISNULL(b.Address1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.Address2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.city, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.state, ''))) + ' ' + LTRIM(RTRIM(ISNULL(b.zip, '')))) as service_address,   
			LTRIM(RTRIM(ISNULL(b.zip, ''))) AS zip,   
			LTRIM(RTRIM(ISNULL(REPLACE(c.Name, '&', 'and'), ''))) AS full_name,   
			'' AS meter_number,   
			'' AS deal_id,   
			CONT.Number AS contract_nbr,  
			a.accountidlegacy AS account_id                                         
			FROM  LibertyPower..Account AS a (NOLOCK)   
			JOIN LibertyPower..[Contract] CONT WITH (NOLOCK)   ON a.CurrentRenewalContractID = CONT.ContractID   
			JOIN  lp_enrollment..check_account d WITH (NOLOCK) ON CONT.Number = d.contract_nbr  
			JOIN LibertyPower..Utility U  WITH(NOLOCK)         ON a.UtilityID  = U.ID  
			JOIN LibertyPower..AccountContract AC WITH(NOLOCK) ON a.AccountID = AC.AccountID AND CONT.ContractID = AC.ContractID  
			JOIN LibertyPower..AccountStatus  ST WITH (NOLOCK) ON AC.AccountContractID = ST.AccountContractID  
			JOIN LibertyPower..AccountUsage  AU WITH (NOLOCK)  ON a.AccountID = AU.AccountID AND CONT.StartDAte = AU.EffectiveDate  
			LEFT JOIN libertypower..Address b WITH (NOLOCK) ON a.ServiceAddressID = b.AddressID   
			left JOIN libertypower..Name c WITH (NOLOCK) ON a.AccountNameID = c.NameID    
			-- LEFT JOIN lp_account..account_meters AS e  WITH (NOLOCK) ON a.AccountIdLegacy = e.account_id   
			WHERE d.check_type = 'USAGE ACQUIRE'  
			AND (d.approval_status = 'PENDING' OR d.approval_status = 'INCOMPLETE')  
			AND U.UtilityCode = @p_utility_id;  
		END  
	END  
END  
  
IF @p_process = 'PROSPECTS'  
BEGIN  
    -- Scraping single account  
    IF LEN(@p_account_number) > 0  
	BEGIN  
		SELECT DISTINCT a.ACCOUNT_NUMBER AS account_number, '' AS service_address, ISNULL(ad.ZIP, '') AS zip,  
			   ISNULL(m.METER_NUMBER, '') AS meter_number, '' AS full_name, '' AS deal_id, '' AS contract_nbr, '' account_id  
		FROM  OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK)  
					INNER JOIN OfferEngineDB..OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER  
					LEFT JOIN  
					(  
						  SELECT TOP 1 ACCOUNT_NUMBER, METER_NUMBER  
						  FROM  OfferEngineDB..OE_ACCOUNT_METERS WITH (NOLOCK)  
						  WHERE ACCOUNT_NUMBER = @p_account_number  
					) m ON a.ACCOUNT_NUMBER = m.ACCOUNT_NUMBER  
					LEFT JOIN OfferEngineDB..OE_ACCOUNT_ADDRESS ad WITH (NOLOCK) ON a.ID = ad.OE_ACCOUNT_ID  
		WHERE a.ACCOUNT_NUMBER = @p_account_number;  
	END  
    ELSE  
	BEGIN  
		SELECT DISTINCT a.ACCOUNT_NUMBER AS account_number, '' AS service_address, ISNULL(ad.ZIP, '') AS zip,  
			   ISNULL(m.METER_NUMBER, '') AS meter_number, '' AS full_name, '' AS deal_id, '' AS contract_nbr, '' account_id  
		FROM  OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK)  
					INNER JOIN OfferEngineDB..OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER  
					LEFT JOIN  
					(  
						  SELECT TOP 1 ACCOUNT_NUMBER, METER_NUMBER  
						  FROM  OfferEngineDB..OE_ACCOUNT_METERS WITH (NOLOCK)  
						  WHERE ACCOUNT_NUMBER = @p_account_number  
					) m ON a.ACCOUNT_NUMBER = m.ACCOUNT_NUMBER  
					LEFT JOIN OfferEngineDB..OE_ACCOUNT_ADDRESS ad WITH (NOLOCK) ON a.ID = ad.OE_ACCOUNT_ID;  
	END  
END  

  