USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_sel_by_contract_nbr_or_account_nbr]    Script Date: 11/02/2012 12:37:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/9/2007
-- Description:	Pull contract by contract number or account number
-- =============================================
-- Author:		Sofia Melo
-- Create date: 8/25/2010
-- Description:	add field accountId for ticket 17805
-- =============================================
-- Author:		Jose Munoz - SWCS
-- Modify date: 02/02/2012
-- Description:	Usin new account table libertypower..account
-- to replace old table lp_account..account
-- =============================================

/*
-- set statistics time off

exec [lp_account].[dbo].[usp_account_sel_by_contract_nbr_or_account_nbr] '2011-0034662', '0' , 'TRUE'
exec [lp_account].[dbo].[usp_account_sel_by_contract_nbr_or_account_nbr_JMUNOZ] '2011-0034662', '0' , 'TRUE'

exec [lp_account].[dbo].[usp_account_sel_by_contract_nbr_or_account_nbr] '0', '314685436500051' , 'TRUE'
exec [lp_account].[dbo].[usp_account_sel_by_contract_nbr_or_account_nbr_JMUNOZ] '0', '314685436500051' , 'TRUE'

exec [lp_account].[dbo].[usp_account_sel_by_contract_nbr_or_account_nbr] '0', '314685436500051' , 'FALSE'
exec [lp_account].[dbo].[usp_account_sel_by_contract_nbr_or_account_nbr_JMUNOZ] '0', '314685436500051' , 'FALSE'


exec lp_account..usp_account_sel_by_contract_nbr_or_account_nbr @p_check_contract_exists=N'FALSE',@p_account_number=N'7861108024'


*/

ALTER PROCEDURE [dbo].[usp_account_sel_by_contract_nbr_or_account_nbr]

@p_contract_nbr				char(12)		= '0',
@p_account_number			varchar(30)		= '0',
@p_check_contract_exists	varchar(5)

AS
DECLARE @w_ContractNumber		VARCHAR(12)
IF @p_check_contract_exists = 'TRUE'
BEGIN
	IF @p_contract_nbr		= '0'
	BEGIN
		SELECT @w_ContractNumber					= CC.Number
		FROM Libertypower..[Contract]				CC WITH (NOLOCK)
		INNER JOIN Libertypower..[AccountContract]	AC WITH (NOLOCK)
		ON AC.ContractID							= CC.ContractID
		INNER JOIN Libertypower..[Account]			AA WITH (NOLOCK)
		ON AA.AccountId								= AC.AccountID
		AND AA.CurrentContractID					= AC.ContractID
		WHERE AA.AccountNumber						= @p_account_number
	END
	IF NOT EXISTS
	(	SELECT	contract_nbr
		FROM	lp_contract_renewal..deal_contract WITH (NOLOCK)
		WHERE	contract_nbr =	CASE WHEN @p_contract_nbr = '0' THEN @w_ContractNumber ELSE @p_contract_nbr END
	)
	BEGIN			
		SELECT contract_nbr							= CC.Number
		FROM Libertypower..[Contract]				CC WITH (NOLOCK)
		INNER JOIN Libertypower..[AccountContract]	AC WITH (NOLOCK)
		ON AC.ContractID							= CC.ContractID
		INNER JOIN Libertypower..[Account]			AA WITH (NOLOCK)
		ON AA.AccountId								= AC.AccountID
		AND AA.CurrentContractID					= AC.ContractID
		WHERE CASE WHEN @p_contract_nbr = '0' THEN AA.AccountNumber ELSE CC.Number END 
			= CASE WHEN @p_contract_nbr = '0' THEN @p_account_number ELSE @p_contract_nbr END
	END
	ELSE
	BEGIN
		SELECT	contract_nbr
		FROM	lp_contract_renewal..deal_contract WITH (NOLOCK)
		WHERE	contract_nbr = 'KEEP EDITING'
	END
END
ELSE
BEGIN
	SELECT A.AccountID, C.ContractID
	INTO #ContractAccountFilter
	FROM LibertyPower..Account A (NOLOCK)
	JOIN LibertyPower..Contract C (NOLOCK) ON A.CurrentContractID = C.ContractID
	WHERE (@p_account_number = '0' OR A.AccountNumber = @p_account_number)
	AND (@p_contract_nbr = '0' OR C.Number = @p_contract_nbr)
	
	SELECT	contract_nbr				=	C.[Number]
		,account_id					=	A.AccountidLegacy
		,account_number				=	A.AccountNumber
		,account_type				=	AT.AccountType
		,[status]					=	CASE WHEN (ASS.[Status]		= '07000' AND ASS.SubStatus = '90' AND A.CurrentContractId = AC.ContractID) THEN '999999' 
											WHEN (ASS.[Status]		= '07000' AND ASS.SubStatus = '10' AND A.CurrentContractId = AC.ContractID) THEN '05000' 
											ELSE ASS.[Status] END 
		,sub_status					=	CASE WHEN (ASS.[Status]			= '07000' AND ASS.SubStatus = '90' AND A.CurrentContractId = AC.ContractID) THEN '10' 
											ELSE ASS.SubStatus END
		,customer_id				=	A.CustomerIDLegacy
		,entity_id					=	A.EntityId
		,contract_type				=	CT.[Type]
		,retail_mkt_id				=	MARKET.MarketCode
		,utility_id					=	U.UtilityCode
		,product_id					=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.LegacyProductID	ELSE AC_DefaultRate.LegacyProductID	END 
		,rate_id					=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateID			ELSE AC_DefaultRate.RateID			END 
		,rate						=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.Rate			ELSE AC_DefaultRate.Rate			END
		,account_name_link			=	B.NameID
		,customer_name_link			=	Z.NameID
		,customer_address_link		=	ZZ.AddressID
		,customer_contact_link		=	D.ContactID
		,billing_address_link		=	CC.AddressID
		,billing_contact_link		=	DD.ContactID
		,owner_name_link			=	OW.NameID
		,service_address_link		=	W.AddressID
		,business_type				=	UPPER(BT.[Type])
		,business_activity			=	UPPER(BA.Activity)
		,additional_id_nbr_type		=	CASE WHEN LTRIM(RTRIM(CUST.Duns))		<> '' THEN 'DUNSNBR' 
											WHEN LTRIM(RTRIM(CUST.EmployerId))	<> '' THEN 'EMPLID' 
											WHEN LTRIM(RTRIM(CUST.TaxId))		<> '' THEN 'TAX ID' 
											ELSE 
												CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN 'SSN' 
												ELSE 'NONE' END 
											END 
		,additional_id_nbr			=	CASE WHEN LTRIM(RTRIM(CUST.Duns))		<> '' THEN CUST.Duns
										WHEN LTRIM(RTRIM(CUST.EmployerId))	<> '' THEN CUST.EmployerId 
										WHEN LTRIM(RTRIM(CUST.TaxId))		<> '' THEN CUST.TaxId 
										ELSE 
											CASE WHEN CUST.SsnEncrypted IS NOT NULL  AND CUST.SsnEncrypted != '' THEN '***-**-****' 
											ELSE 'NONE' END 
										END 
		,contract_eff_start_date	=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateStart  ELSE AC_DefaultRate.RateStart END
		,term_months				=	ACR.Term
		,date_end					=	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateEnd	ELSE AC_DefaultRate.RateEnd   END 
		,date_deal					=	C.SignedDate
		,date_created				=	A.DateCreated
		,date_submit				=	CONVERT(datetime, CONVERT(char(10), C.SubmitDate, 101))
		,sales_channel_role			=	'SALES CHANNEL/' + SCH.ChannelName
		,username					=	USER1.UserName
		,sales_rep					=	C.SalesRep
		,origin						=	A.Origin
		,annual_usage				=	AU.AnnualUsage
		,date_flow_start			=	CASE WHEN ASS.[Status] in ('999998','999999','01000','03000','04000','05000') AND ASS.[SubStatus] not in ('30') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
										ELSE ISNULL(ASERVICE.StartDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END
		,date_por_enrollment		=	AC.SendEnrollmentDate
		,date_deenrollment			=	CASE WHEN ASS.[Status] in ('999998','999999','01000','03000','04000','05000') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
										WHEN ASS.[Status] in ('13000') AND ASS.[SubStatus] in ('70','80') THEN CAST('1900-01-01 00:00:00' AS DATETIME)
										ELSE ISNULL(ASERVICE.EndDate, CAST('1900-01-01 00:00:00' AS DATETIME)) END
		,date_reenrollment			=	CAST('1900-01-01 00:00:00' AS DATETIME)
		,tax_status					=	UPPER(TX.[Status])
		,tax_rate					=	CAST(0 AS INT)
		,credit_score				=	CAST(0 AS INT)
		,credit_agency				=	CA.Name 
		,por_option					=	CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END
		,billing_type				=	BILLT.[Type]
		,address_link				=	ZZ.AddressID
		,[address]					=	ZZ.[Address1]
		,suite						=	ZZ.Address2
		,city						=	ZZ.City
		,[state]					=	ZZ.[State]
		,zip						=	ZZ.zip
		,county						=	ZZ.county
		,state_fips					=	ZZ.statefips
		,county_fips				=	ZZ.countyfips
		,BB.field_01_value
		,BB.field_02_value
		,BB.field_03_value
		,BB.field_04_value
		,BB.field_05_value 
		,BB.field_06_value
		,BB.field_07_value
		,BB.field_08_value 
		,BB.field_09_value
		,BB.field_10_value
		,D.ContactID AS contact_link 
		,D.firstname
		,D.lastname
		,D.title
		,D.phone
		,D.fax 
		,D.email
		,D.birthdate
		,Z.NameID AS name_link
		,Z.Name AS full_name
		--,accountId					= A.AccountIdLegacy		--WRONG
		,accountId					= A.AccountID
	FROM #ContractAccountFilter CAF
	JOIN LibertyPower.dbo.Account				A WITH (NOLOCK)		ON CAF.AccountID = A.AccountID
	JOIN LibertyPower.dbo.AccountType			AT WITH (NOLOCK)	ON AT.ID									= A.AccountTypeID
	JOIN LibertyPower.dbo.Customer				CUST	 WITH (NOLOCK) ON CUST.CustomerID						= A.CustomerID
	JOIN Libertypower.dbo.[AccountContract]		AC WITH (NOLOCK)	ON A.AccountID								= AC.AccountID AND AC.ContractID = A.CurrentContractID
	JOIN Libertypower.dbo.[Contract]			C WITH (NOLOCK) 	ON C.ContractID    = AC.ContractID AND CAF.ContractID = C.ContractID
	JOIN Libertypower.dbo.ContractType			CT WITH (NOLOCK)	ON CT.ContractTypeID						= C.ContractTypeID
	JOIN Libertypower.dbo.vw_AccountContractRate	ACR WITH (NOLOCK)	ON ACR.AccountContractID					= AC.AccountContractID
																	--AND ACR.IsContractedRate				= 1 
	JOIN Libertypower.dbo.AccountStatus			ASS WITH (NOLOCK)	ON ASS.AccountContractID					= AC.AccountContractID
	JOIN Libertypower.dbo.BillingType			BILLT WITH (NOLOCK) ON BILLT.BillingTypeID						= A.BillingTypeID
	JOIN Libertypower.dbo.Market				MARKET WITH (NOLOCK) ON MARKET.ID								= A.RetailMktID
	JOIN lp_account..account_additional_info BB WITH (NOLOCK) ON BB.account_id							= A.AccountidLEgacy
																		
	LEFT JOIN LibertyPower.dbo.Utility			U WITH (NOLOCK)		ON U.ID = A.UtilityID
	LEFT JOIN Libertypower.dbo.Address			W WITH (NOLOCK)     ON W.AddressID						= A.ServiceAddressID
	LEFT JOIN Libertypower.dbo.Address			CC WITH (NOLOCK) 	ON CC.AddressID						= A.BillingAddressID
	LEFT JOIN Libertypower.dbo.Address			ZZ WITH (NOLOCK) 	ON ZZ.AddressID						= CUST.AddressID
	
	LEFT JOIN dbo.enrollment_status_substatus_vw f WITH (NOLOCK) 	ON f.[status]								= ASS.[Status]
																	AND f.sub_status							= ASS.SubStatus
	--LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)		ON AC_DefaultRate.AccountContractID				= AC.AccountContractID
	--																AND AC_DefaultRate.IsContractedRate				= 0 -- temporary measure, should be changed later
	-- NEW DEFAULT RATE JOIN:
	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
			   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
			   WHERE ACRR.IsContractedRate = 0 
			   GROUP BY ACRR.AccountContractID
			  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
	LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
	 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
	-- END NEW DEFAULT RATE JOIN:

	
	LEFT JOIN Libertypower.dbo.TaxStatus		TX WITH (NOLOCK) 	ON TX.TaxStatusID							= A.TaxStatusID
	LEFT JOIN LibertyPower.dbo.SalesChannel		SCH WITH (NOLOCK)	ON SCH.ChannelID							= C.SalesChannelID
	LEFT JOIN Libertypower.dbo.AccountUsage		AU WITH (NOLOCK) 	ON AU.AccountID								= A.AccountID
																	AND AU.EffectiveDate						= C.StartDate
	LEFT JOIN LibertyPower.dbo.CreditAgency		CA WITH (NOLOCK) 	ON CA.CreditAgencyID						= CUST.CreditAgencyID
	LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) 	ON ASERVICE.AccountID						= A.AccountID
	
	LEFT JOIN LibertyPower.dbo.[User]			USER1	WITH (NOLOCK)ON USER1.UserID								= A.ModifiedBy 
	LEFT JOIN lp_common.dbo.common_product		P WITH (NOLOCK) ON P.product_id								= ISNULL(AC_DefaultRate.LegacyProductID,ACR.LegacyProductID)
	
	LEFT JOIN lp_common.dbo.common_product_rate PR WITH (NOLOCK) ON PR.product_id							= P.product_id 
																	and PR.rate_id								= ISNULL(AC_DefaultRate.AccountContractRateID, ACR.RateID)
	
	LEFT JOIN Libertypower.dbo.Name				B WITH (NOLOCK)  ON B.NameID							= A.AccountNameID
	LEFT JOIN Libertypower.dbo.Name				Z WITH (NOLOCK) ON Z.NameID							= CUST.NameID -- Z
	LEFT JOIN Libertypower.dbo.Contact	D WITH (NOLOCK) ON D.ContactID						= CUST.ContactID
	LEFT JOIN Libertypower.dbo.Name				OW WITH (NOLOCK)ON OW.NameID							= CUST.OwnerNameID
	LEFT JOIN Libertypower.dbo.Contact	DD WITH (NOLOCK)	ON DD.ContactID						= A.BillingContactID

	LEFT JOIN Libertypower.dbo.BusinessType		BT WITH (NOLOCK) ON BT.BusinessTypeID						= CUST.BusinessTypeID 
	LEFT JOIN Libertypower.dbo.BusinessActivity BA WITH (NOLOCK) ON BA.BusinessActivityID					= CUST.BusinessActivityID 
	
END


