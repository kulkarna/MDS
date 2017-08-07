USE [lp_account]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_contract_summary_info]    Script Date: 11/02/2012 11:02:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [dbo].[ufn_contract_summary_info]
( 
@p_contract_nbr varchar(35) 
) 

RETURNS @contract_summary_info TABLE 
		(
		   contract_nbr varchar(30)
		 , acct_nbr_list varchar(max)
		 --Ticket 9717-----------------------------
		 , Product_list varchar(max)
		 , PriceRate_list varchar(max)
		 , CreditScore_list varchar(max)
		 , ServiceRateClass_list varchar(max)
		 , Zone_list varchar(max)
		 , FlowStartDate_list varchar(max)
		 -----------------------------------------
		 , billing_address varchar(50) 
		 , billing_suite varchar(10)
		 , billing_city varchar(30)	
		 , billing_state varchar(2)
		 , billing_zip varchar(10) 
		 , service_address varchar(50) 
		 , service_suite varchar(10)
		 , service_city varchar(30)	
		 , service_state varchar(2)
		 , service_zip varchar(10) 
		 , product varchar(50)		 
		)

AS 
BEGIN 

	DECLARE @acct_nbr_list varchar(max) 
	SET @acct_nbr_list = '='
	
	--Ticket 9717---------
	DECLARE @Products_list varchar(max)
	set @Products_list = '='
	
	DECLARE @PriceRate_list varchar(max)
	set @PriceRate_list = '='
	
	DECLARE @CreditScore_list varchar(max)
	set @CreditScore_list = '='
	
	DECLARE @ServiceRateClass_list varchar(max)
	set @ServiceRateClass_list = '='
	
	DECLARE @Zone_list varchar(max)
	set @Zone_list = '='
	
	DECLARE @FlowStartDate_list varchar(max)
	set @FlowStartDate_list = '='
	---------------------
		
		
	-- append all account numbers to string 
	-- TOP 15 was set because more than that could cause error when exporting to excel (character limit of the cell)
	SELECT  top 15 @acct_nbr_list =  @acct_nbr_list + ltrim(rtrim(a.account_number)) + '&CHAR(10)&' 
			
			--Ticket 9717 - append all to string
			,@Products_list = @Products_list + '"' + RIGHT(a.account_number,4) + '-' + ltrim(rtrim(a.product_id)) + '"&CHAR(10)&'
			,@PriceRate_list = @PriceRate_list + '"' + RIGHT(a.account_number,4) + ' - '  + ltrim(rtrim(CONVERT(varchar(30),a.rate))) + '"&CHAR(10)&'
			,@CreditScore_list = @CreditScore_list + '"' + RIGHT(a.account_number,4) + ' - '  + ltrim(rtrim(CONVERT(varchar(20),a.credit_score))) + '"&CHAR(10)&'
			,@ServiceRateClass_list = @ServiceRateClass_list + '"' + RIGHT(a.account_number,4) + ' - '  + ltrim(rtrim(CONVERT(varchar(20),a.Service_rate_class))) + '"&CHAR(10)&'
			,@Zone_list = @Zone_list + '"' + RIGHT(a.account_number,4) + ' - '  + ltrim(rtrim(a.Zone)) + '"&CHAR(10)&'
			,@FlowStartDate_list = @FlowStartDate_list + '"' + RIGHT(a.account_number,4) + ' - '  + ltrim(rtrim(CONVERT(varchar(20),a.requested_flow_start_date))) + '"&CHAR(10)&'
			--------------
	FROM (
		SELECT
		 A1.AccountNumber			AS account_number
		,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id
		,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate			 ELSE AC_DefaultRate.Rate			 END AS rate
		,CAST(0 AS INT)			AS credit_score
		,A1.ServiceRateClass		AS service_rate_class
		,A1.Zone				AS Zone
		,AC.RequestedStartDate			AS requested_flow_start_date

		FROM LibertyPower.dbo.Account A1 (NOLOCK)
		JOIN LibertyPower.dbo.AccountContract AC	WITH (NOLOCK)		ON A1.AccountID = AC.AccountID AND A1.CurrentContractID = AC.ContractID
		JOIN LibertyPower.dbo.Contract C (NOLOCK) ON AC.ContractID = C.ContractID
		JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
		LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK) WHERE ACRR.IsContractedRate = 0 GROUP BY ACRR.AccountContractID) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK) ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
	) a
		--FROM lp_account..account a
		--WHERE contract_nbr = @p_contract_nbr



	--remove last 'CHAR(10)' on string
	IF len(@acct_nbr_list) > 2 
		SELECT @acct_nbr_list = left(@acct_nbr_list, len(@acct_nbr_list) - 10 ) 
		
	--Ticket 9717	 - remove last 'CHAR(10)' on string
	IF len(@Products_list) > 2 
		SELECT @Products_list = left(@Products_list, len(@Products_list) - 1 ) 
		
	IF len(@PriceRate_list) > 2 
		SELECT @PriceRate_list = left(@PriceRate_list, len(@PriceRate_list) - 1 ) 
	
	IF len(@CreditScore_list) > 2 
		SELECT @CreditScore_list = left(@CreditScore_list, len(@CreditScore_list) - 1 ) 
		
	IF len(@ServiceRateClass_list) > 2 
		SELECT @ServiceRateClass_list = left(@ServiceRateClass_list, len(@ServiceRateClass_list) - 1 ) 
	
	IF len(@Zone_list) > 2 
		SELECT @Zone_list = left(@Zone_list, len(@Zone_list) - 1 ) 
		
	IF len(@FlowStartDate_list) > 2 
		SELECT @FlowStartDate_list = left(@FlowStartDate_list, len(@FlowStartDate_list) - 1 ) 
	--------------
	
	
	DECLARE @Contract TABLE ( ContractID INT )
		
	INSERT INTO @Contract
	SELECT ContractID
	FROM LibertyPower..Contract (NOLOCK)
	WHERE Number = @p_contract_nbr

	INSERT INTO @contract_summary_info
	SELECT TOP 1 @p_contract_nbr as contract_nbr , @acct_nbr_list , 
	
	    --Ticket 9717-----------
	    @Products_list,
	    @PriceRate_list,
	    @CreditScore_list,
	    @ServiceRateClass_list,
	    @zone_list,
	    @FlowStartDate_list,
		-------------------------
		billing_address = BA.Address1,
		billing_suite = BA.Address2,
		billing_city = BA.City,
		billing_state = BA.State,
		billing_zip = BA.Zip,

		service_address = SA.Address1,
		service_suite = SA.Address2,
		service_city = SA.City,
		service_state = SA.State,
		service_zip = SA.Zip,
        product = p.product_descp

	FROM LibertyPower..Account A (NOLOCK)
	JOIN LibertyPower..Address BA (NOLOCK) ON A.BillingAddressID = BA.AddressID
	JOIN LibertyPower..Address SA (NOLOCK) ON A.ServiceAddressID = SA.AddressID
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID
	JOIN @Contract C ON AC.ContractID = C.ContractID
	JOIN LibertyPower..AccountContractRate ACR (NOLOCK) ON AC.AccountContractID = ACR.AccountContractID
	JOIN lp_common.dbo.common_product P on ACR.LegacyProductID = p.product_id


	RETURN 

END 

