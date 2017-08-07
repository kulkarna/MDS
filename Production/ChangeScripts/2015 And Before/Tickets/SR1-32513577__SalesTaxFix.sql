USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_document_print_template_table_mulitrate_sel]    Script Date: 01/09/2013 16:37:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date:	5/30/2007
-- Description:	Returns data to be filled in the MultiRate protion of templates
-- Use:			EXEC usp_document_print_template_table_mulitrate_sel @contract_number='2011-0028715'
-- =============================================

-- Document Print Data in the following order 
-- Account Renewal Tables   ( lp_account..account_renewal ) 
-- Renewal Deal Capture Contract Accounts   ( lp_contract_renewal..deal_contract_account )
-- Renewal Deal Capture Contract   ( lp_contract_renewal..deal_contract )
-- Account Tables ( lp_account..account )
-- Deal Capture Contract Accounts  ( lp_deal_capture..deal_contract_account ) 
-- Deal Capture Contract - mulitrate ( lp_deal_capture..multi_rates ) 
-- Deal Capture Contract - single rate ( lp_deal_capture..deal_contract_print ) 

-- ==================================================================================
-- Modification history 
-- 07/27/2007	-- Added SC and Zone columns
-- 07/31/2007	-- Added TermInWords column
-- 08/03/2007	-- Changed Term to common_product_rate.term_months
-- 10/24/2007	-- Changed to get data from contract renewal table 
-- 05/06/2008	-- added addiitonal data sources to cover renewal and contract print scenarios
-- 03/10/2009	-- Changed to select term from account table if row exists otherwise from product_rate tables
-- 05/08/2009	-- GM -- Added Billing Account field
-- 06/03/2009	-- GM -- Added FlowStartDate, ChannelPartnerName, AnnualUsage, EstAnnualUsage
-- 06/12/2009	-- GM -- Added NameKey , OMSRate place holder fields and MeterNumber field
-- 06/17/2009	-- GM -- Added EffectiveStartDate and data for NameKey , OMSRate place holder fields and MeterNumber field
-- 07/01/2009	-- GM -- Modified format of Effective and Flow Start Datees to mm/yyyy
-- 07/15/2009	-- GM -- Added End Date.
-- 08/17/2009	-- GM -- Formatted end date mm/yyyy
-- 09/29/2009	-- GM -- Added DeEnrollment Date 
-- 08/31/2010	-- SMelo -- Added EtfAmount
-- 10/28/2011	-- RR -- Added SalesChannel information and some minor cleanup for readability
-- 11/02/2011	-- RR -- Changed Etf_Amount to EtfFinalAmount
-- 11/21/2011	-- RR -- Added account_id param to attempt to fix stupid issues with getting the wrong account in LetterQueue items
-- 12/27/2011	-- RR -- Bug fix to show only most current ETF amount due
-- 01/17/2012	-- RR -- Bug fix to pick correct Account data based off @AccountId, if passed
-- 01/20/2012	-- RR -- Bug fix made join to SalesChannel optional so that "Power Move" accounts (and any other accounts with no SalesChannel) won't fail
-- 03/23/2012	-- RR -- Optimized some paths by replacing subqueries with more efficient code
-- 06/15/2012	-- RR -- Added Sales Channel info for printing templates in Deal Capture, now available since we added sales_channel_role field to lp_deal_capture..deal_contract_print
-- 11/02/2012 -- Lev Rosenblum  -- added functionality for multi-term products into contract-print section
-- 11/27/2012 -- Lev Rosenblum -- move cursor at the top of procedure: new output applied for all cases and add DefaultSubRateList to output (should be used later for PA market
-- 11/29/2012 -- Lev Rosenblum -- create @PriceId for each 'IF' statement due to unique table for selecting a priceid
-- 12/17/2012 -- Lev Rosenblum -- new functionality has been added related to Bug 4497 (No priceId selected)
-- 01/08/2013	-- RR -- Removed kludge for calculating sales tax (all post-data correction now in Doc Repository code)
-- ==================================================================================
ALTER PROCEDURE [dbo].[usp_document_print_template_table_mulitrate_sel] 
(
	@contract_number		char(12),
	@force_row_count		int = 0,
	@account_id				varchar(40) = null
)

AS



BEGIN
	-----****************MULTI-TERM implementation start here**********************----------
	DECLARE @TermStatement  nvarchar(300)
	DECLARE @RateStatement nvarchar(300)
	DECLARE @WelcomeRateStatement nvarchar(300)
	DECLARE @DefaultRateStatement nvarchar(300)

	DECLARE @StartDate			DateTime
	DECLARE @EndDate			DateTime
	DECLARE @CurrTermLength		int
	DECLARE @TermLength			int
	DECLARE @Rate				Decimal(13,5)
	DECLARE @AssignedRate		Decimal(13,5)
	DECLARE @Delta				Decimal(13,5)
	DECLARE @Count				int
	DECLARE @AccountNumber		varchar(30)
	DECLARE @PriceId			bigint
	DECLARE @ShowRate			bit
	DECLARE @current_row_count	int

	DECLARE @temp_multi_rate TABLE (
		utility_id					varchar(20),
		account_number				varchar(35),
		account_type				varchar(35),
		account_name				varchar(100), 
		customer_name				varchar(100), 
		business_type				varchar(35),
		business_activity			varchar(35),

		first_name					varchar(50),
		last_name					varchar(50), 
		title						varchar(50), 
		phone						varchar(50), 
		fax							varchar(50), 		                      
		email						varchar(256), 
		birthday					varchar(50), 
		languageId					int,					--NEW -for setting hardcoded Sales Channel text correctly

		contract_type				varchar(50), 
		contract_number				varchar(50),
		service_address				varchar(50),
		service_suite				varchar(50), 
		service_city				varchar(50), 
		service_county				varchar(50), 		                      
		service_state				varchar(50), 
		service_zip					varchar(50), 

		billing_address_link		varchar(50),
		billing_address				varchar(50), 
		billing_suite				varchar(50), 
		billing_city				varchar(50), 
		billing_county				varchar(50), 		                      
		billing_state				varchar(50), 
		billing_zip					varchar(50), 

		product_id					varchar(50), 
		rate						float,
		customer_id					varchar(50), 
		retail_mkt_id				varchar(10), 
		rate_id						int, 
		forced_rowcount				int,
		term_months					varchar(10),
		account_id					varchar(35),

		date_flow_start				datetime,
		sales_channel_role			varchar(150),
		annual_usage				float,
		estimated_annual_usage		float ,		
		contract_eff_start_date		datetime,
		date_end					datetime,
		date_deEnrollment			datetime, 
		etf_amount					decimal(10,2)

		, ChannelName				varchar(150)
		, ChannelEmail				varchar(200)
		, ChannelPhone				varchar(50)
		, ChannelFax				varchar(50)
		, ChannelIsActive			bit
		, AllowInfoOnWelcomeLetter	bit
		, AllowInfoOnRenewalLetter	bit
		, AllowInfoOnRenewalNotice	bit
		---------**MULTI-TERM implementation**---------
		, SubTermList				varchar(300)
		, SubRateList				varchar(300)
		, DefaultSubRateList		varchar(300)
		, WelcomeSubRateList		varchar(300)
	) 


	--SELECT STATEMENTS SHOULD CORRESPOND !!!

	-- Check Account Renewal tables 
	-- lp_account..account_renewal 
	-- ========================================================
	IF EXISTS(	select 1
				from lp_account..account_renewal a WITH (NOLOCK) 
				where a.contract_nbr = @contract_number
				and (@account_id is null	or	a.account_id = @account_id)	)
	BEGIN
			print 'from account_renewal (1)'
		INSERT INTO @temp_multi_rate
		SELECT DISTINCT
			rtrim(a.utility_id), 
			rtrim(a.account_number), 
			rtrim(a.account_type), 		
			rtrim(b.full_name), 
			rtrim(z.full_name) , 
			rtrim(a.business_type), 
			rtrim(a.business_activity), 
			                      
			rtrim(d.first_name), 
			rtrim(d.last_name), 
			rtrim(d.title), 
			rtrim(d.phone), 
			rtrim(d.fax), 		                      
			rtrim(d.email), 
			rtrim(d.birthday), 
			IsNull(l.LanguageId, 1),
			
			rtrim(a.contract_type), 
			rtrim(a.contract_nbr), 		                      
			rtrim(w.address), 
			rtrim(w.suite), 
			rtrim(w.city), 
			rtrim(w.county), 		                      
			rtrim(w.state), 
			rtrim(w.zip), 

			a.billing_address_link,
			rtrim(c.address), 
			rtrim(c.suite), 
			rtrim(c.city), 
			rtrim(c.county), 		                   
			rtrim(c.state), 
			rtrim(c.zip), 
			
			a.product_id,
			a.rate, 
			a.customer_id, 
			a.retail_mkt_id, 
			a.rate_id, 
			0 ,
			CASE WHEN a.term_months = 0 THEN ''
				ELSE a.term_months END									AS term_months,
			a.account_id

			, a.date_flow_start 
			, a.sales_channel_role 
			, a.annual_usage 
			, 0															AS estimated_annual_usage
			
			, a.contract_eff_start_date
			, a.date_end
			, a.date_deenrollment
			, IsNull(f.EtfFinalAmount, 0.00)							AS etf_amount
			--NEW SalesChannel items
			, s.ChannelDescription										AS ChannelName
			, s.ContactEmail											AS ChannelEmail
			, s.ContactPhone											AS ChannelPhone
			, s.ContactFax												AS ChannelFax
			, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END		AS IsChannelActive
			, s.AllowInfoOnWelcomeLetter
			, s.AllowInfoOnRenewalLetter
			, s.AllowInfoOnRenewalNotice
			, null
			, null
			, null
			, null
		FROM lp_account..account_renewal								a WITH (NOLOCK)
		LEFT JOIN LibertyPower..SalesChannel							s WITH (NOLOCK)
			ON a.sales_channel_role = 'Sales Channel/' + s.channelname
		LEFT JOIN LibertyPower..AccountLanguage							l WITH (NOLOCK)
			ON l.AccountNumber = a.account_number
		LEFT JOIN lp_account..account_renewal_name						b WITH (NOLOCK)
			ON b.account_id = a.account_id AND b.name_link = a.account_name_link 
		LEFT JOIN lp_account..account_renewal_name						z WITH (NOLOCK)
			ON z.account_id = a.account_id AND z.name_link = a.customer_name_link 
		LEFT JOIN lp_account..account_renewal_address					c WITH (NOLOCK)
			ON c.account_id = a.account_id AND c.address_link = a.billing_address_link 
		LEFT JOIN lp_account..account_renewal_address					w WITH (NOLOCK)
			ON w.account_id = a.account_id AND w.address_link = a.service_address_link 
		LEFT JOIN lp_account..account_renewal_contact					d WITH (NOLOCK)
			ON d.account_id = a.account_id AND d.contact_link = a.customer_contact_link 
		LEFT JOIN lp_account..account									e WITH (NOLOCK)
			ON e.account_id = a.account_id 
		LEFT JOIN	(	select AccountID, max(CalculatedDate) as maxdate
						from LibertyPower..AccountEtf  WITH (NOLOCK)
						group by AccountID
					)													m
			ON m.accountId = e.accountId 
		LEFT JOIN LibertyPower..AccountEtf								f WITH (NOLOCK)
			ON (m.AccountID = f.AccountID	and		m.maxdate = f.CalculatedDate)

		WHERE a.contract_nbr = @contract_number 

		IF @@ROWCOUNT > 0 
			GOTO FINAL 
	END -- renewal contract


	-------------Create temp table to get list of account_ids (with linkage for upcoming joins)
	DECLARE @accounts
		table (
			account_id				varchar(100),
			account_number			varchar(100),
			contract_nbr			varchar(100),
			account_name_link		int,
			customer_name_link		int,
			service_address_link	int, 
			billing_address_link	int,
			customer_contact_link	int
		)

	INSERT INTO @accounts
	SELECT account_id, account_number, contract_nbr, account_name_link, customer_name_link, service_address_link, billing_address_link, customer_contact_link
	FROM lp_contract_renewal..deal_contract_account WITH (NOLOCK)
	WHERE contract_nbr = @contract_number


	-- Check Contract Renewal Deal Contract Accounts
	-- lp_contract_renewal..deal_contract_account 
	-- ========================================================
	IF EXISTS(	select 1
				from lp_contract_renewal..deal_contract_account a WITH (NOLOCK) 
				where a.contract_nbr = @contract_number
				and (@account_id is null	or	a.account_id = @account_id)	)
		BEGIN


			print 'from RENEWAL..deal_contract_account (2)'
			-- get data from Contract Renewal 
			-- =============================
			INSERT INTO @temp_multi_rate
			SELECT DISTINCT 
				a.utility_id,
				a.account_number, 
				''															AS account_type, 
				b.full_name													AS account_name, 
				z.full_name													AS customer_name, 
				a.business_type, 
				a.business_activity, 
				                      
				d.first_name, 
				d.last_name, 
				d.title, 
				d.phone, 
				d.fax, 		                      
				d.email, 
				d.birthday, 
				IsNull(l.LanguageId, 1),

				a.contract_type, 
				a.contract_nbr, 		                      
				
				w.address, 
				w.suite, 
				w.city, 
				w.county, 		                      
				w.state, 
				w.zip, 

				a.billing_address_link ,
				c.address, 
				c.suite, 
				c.city, 
				c.county, 		                   
				c.state, 
				c.zip, 

				a.product_id,
				a.rate, 
				''															AS customer_id, 
				a.retail_mkt_id, 
				a.rate_id , 
				0,
				''															AS term_months,
				a.account_id 
				 
				, NULL														AS date_flow_start
				, a.sales_channel_role 
				, a.annual_usage 
				, 0															AS estimated_annual_usage

				, a.contract_eff_start_date
				, a.date_end
				, ''														AS date_deenrollment
				, IsNull(f.EtfFinalAmount, 0.00)							AS etf_amount
				, a.sales_channel_role										AS ChannelName
				, s.ContactEmail											AS ChannelEmail
				, s.ContactPhone											AS ChannelPhone
				, s.ContactFax												AS ChannelFax
				, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END		AS IsChannelActive
				, s.AllowInfoOnWelcomeLetter
				, s.AllowInfoOnRenewalLetter
				, s.AllowInfoOnRenewalNotice
				, null
				, null
				, null
				, null
			FROM lp_contract_renewal..deal_contract_account					a WITH (NOLOCK)
			JOIN @accounts													dca
				ON dca.account_id = a.account_id
			LEFT JOIN LibertyPower..SalesChannel							s WITH (NOLOCK)
				ON a.sales_channel_role = 'Sales Channel/' + s.channelname
			LEFT JOIN LibertyPower..AccountLanguage							l WITH (NOLOCK)
				ON l.AccountNumber = a.account_number
			LEFT JOIN lp_contract_renewal..deal_account_name				b WITH (NOLOCK)	
				ON b.account_id = dca.account_id 
				AND b.name_link = dca.account_name_link 
			LEFT JOIN lp_contract_renewal..deal_account_name				z WITH (NOLOCK)	
				ON z.account_id = dca.account_id 
				AND z.name_link = dca.customer_name_link 
			LEFT JOIN lp_contract_renewal..deal_account_address				w WITH (NOLOCK)	
				ON w.account_id = dca.account_id 
				AND w.address_link = dca.service_address_link 
			LEFT JOIN lp_contract_renewal..deal_account_address				c WITH (NOLOCK)	
				ON c.account_id = dca.account_id 
				AND c.address_link = dca.billing_address_link			
			LEFT JOIN lp_contract_renewal..deal_account_contact				d WITH (NOLOCK)	
				ON d.account_id = dca.account_id 
				AND d.contact_link = dca.customer_contact_link
			LEFT JOIN   lp_account..account									e  WITH (NOLOCK)
				ON e.account_id = a.account_id 
			LEFT JOIN	(	select AccountID, max(CalculatedDate) as maxdate
							from LibertyPower..AccountEtf  WITH (NOLOCK)
							group by AccountID
						)													m
				ON m.accountId = e.accountId 
			LEFT JOIN LibertyPower..AccountEtf								f WITH (NOLOCK)
				ON (m.AccountID = f.AccountID	and		m.maxdate = f.CalculatedDate)

			WHERE a.contract_nbr = @contract_number

			IF @@ROWCOUNT > 0 
				GOTO FINAL 
		END		-- new contract 

	-- Check Contract Renewal Deal Contract 
	-- lp_contract_renewal..deal_contract 
	-- ========================================================
	IF EXISTS(	select 1
				from lp_contract_renewal..deal_contract a WITH (NOLOCK) 
				where a.contract_nbr = @contract_number	)
		BEGIN
		
			print 'ETF is hardcoded to 0.0 (3)'
			-- get data from Contract Renewal 
			-- =============================
			INSERT INTO @temp_multi_rate
			SELECT
				a.utility_id,
				''															AS account_number, 
				''															AS account_type, 
				''															AS account_name, --b.full_name as account_name, 
				z.full_name													AS customer_name, 
			
				a.business_type, 
				a.business_activity, 
				                      
				d.first_name, 
				d.last_name, 
				d.title, 

				d.phone, 
				d.fax, 		                      
				d.email, 
				d.birthday, 
				IsNull(l.LanguageId, 1),

				a.contract_type, 
				a.contract_nbr, 		                      
				
				w.address, 
				w.suite, 
				w.city, 
				w.county, 		                      
				w.state, 
				w.zip, 

				a.billing_address_link ,
				c.address, 
				c.suite, 
				c.city, 
				c.county, 		                   
				c.state, 
				c.zip, 

				a.product_id,
				a.rate, 
				''															AS customer_id, 
				a.retail_mkt_id, 
				a.rate_id , 
				0,
				''															AS term_months,
				''															AS account_id
				, null														AS date_flow_start
				, a.sales_channel_role 
				, a.anual_usage 
				, 0															AS estimated_annual_usage
				
				, a.contract_eff_start_date 
				, a.date_end
				, ''														AS date_deenrollment
				, 0.00														AS etf_amount
				, a.sales_channel_role										AS ChannelName
				, s.ContactEmail											AS ChannelEmail
				, s.ContactPhone											AS ChannelPhone
				, s.ContactFax												AS ChannelFax
				, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END		AS IsChannelActive
				, s.AllowInfoOnWelcomeLetter
				, s.AllowInfoOnRenewalLetter
				, s.AllowInfoOnRenewalNotice
				, null
				, null
				, null
				, null
			FROM lp_contract_renewal..deal_contract							a WITH (NOLOCK)
			JOIN @accounts													dca
				ON dca.contract_nbr = a.contract_nbr
			LEFT JOIN LibertyPower..SalesChannel							s WITH (NOLOCK)
				ON a.sales_channel_role = 'Sales Channel/' + s.channelname
			LEFT JOIN LibertyPower..AccountLanguage							l WITH (NOLOCK)
				ON l.AccountNumber = dca.account_number 
			LEFT JOIN lp_contract_renewal..deal_account_name				z WITH (NOLOCK)	
				ON z.account_id = dca.account_id 
				AND z.name_link = dca.customer_name_link 
			LEFT JOIN lp_contract_renewal..deal_account_address				c WITH (NOLOCK)	
				ON c.account_id = dca.account_id 
				AND c.address_link = dca.billing_address_link			
			LEFT JOIN lp_contract_renewal..deal_account_address				w WITH (NOLOCK)	
				ON w.account_id = dca.account_id 
				AND w.address_link = dca.service_address_link 
			LEFT JOIN lp_contract_renewal..deal_account_contact				d WITH (NOLOCK)	
				ON d.account_id = dca.account_id 
				AND d.contact_link = dca.customer_contact_link
			WHERE a.contract_nbr = @contract_number 

			IF @@ROWCOUNT > 0 
				GOTO FINAL 
		END -- new contract 

	-- Check new Contract tables 
	-- lp_deal_capture..deal_contract_account 
	-- ========================================================
	IF EXISTS(	select 1
				from lp_account..account a  WITH (NOLOCK) 
				where a.contract_nbr = @contract_number
				and (@account_id is null	or	a.account_id = @account_id)	)
		BEGIN -- existing contract
			print 'from account (4)'
			INSERT INTO @temp_multi_rate
			SELECT
			rtrim(a.utility_id)										AS UtilityID, 
			rtrim(a.account_number)									AS AccountNumber, 
			rtrim(a.account_type)									AS AccountType, 		
			rtrim(b.full_name)										AS account_name, 
			rtrim(z.full_name)										AS CustomerName, 

			rtrim(a.business_type)									AS BusinessType, 
			rtrim(a.business_activity)								AS BusinessActivity, 
			rtrim(d.first_name)										AS ContactFirstName, 
			rtrim(d.last_name)										AS ContactLastName, 
			rtrim(d.title)											AS ContactTitle, 

			rtrim(d.phone)											AS ContactPhone, 
			rtrim(d.fax)											AS ContactFax, 		                      
			rtrim(d.email)											AS ContactEmail, 
			rtrim(d.birthday)										AS ContactBirthday, 
			IsNull(l.LanguageId, 1)									AS LanguageId,

			rtrim(a.contract_type)									AS ContractType, 
			rtrim(a.contract_nbr)									AS ContractNumber,

			rtrim(w.address)										AS ServiceAddress1, 
			rtrim(w.suite)											AS ServiceAddress2,
			rtrim(w.city)											AS ServiceCity,
			rtrim(w.county)											AS ServiceCounty,
			rtrim(w.state)											AS ServiceState, 
			rtrim(w.zip)											AS ServiceZip, 

			a.billing_address_link									AS BillingAddressLink,
			rtrim(c.address)										AS BillingAddress1, 
			rtrim(c.suite)											AS BillingAddress2, 
			rtrim(c.city)											AS BillingCity, 
			rtrim(c.county)											AS BillingCounty, 		                   
			rtrim(c.state)											AS BillingState, 
			rtrim(c.zip)											AS BillingZip, 

			a.product_id,
			a.rate													AS Rate,
			a.customer_id, 
			a.retail_mkt_id											AS Market, 
			a.rate_id,
			0,
			CASE WHEN a.term_months = 0 THEN '' 
				ELSE a.term_months
			END														AS term_months,

			a.account_id
			, a.date_flow_start 
			, a.sales_channel_role 
			, a.annual_usage 
			, estimated_annual_usage  = 0 
		
			, a.contract_eff_start_date
			, a.date_end
			, a.date_deenrollment
			, IsNull(f.EtfFinalAmount, 0.00)						AS etf_amount
			, a.sales_channel_role									AS ChannelName
			, s.ContactEmail										AS ChannelEmail
			, s.ContactPhone										AS ChannelPhone
			, s.ContactFax											AS ChannelFax
			, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END	AS IsChannelActive
			, s.AllowInfoOnWelcomeLetter
			, s.AllowInfoOnRenewalLetter
			, s.AllowInfoOnRenewalNotice
			, null
			, null
			, null
			, null	
			FROM lp_account..account											a  WITH (NOLOCK) 
			LEFT JOIN libertypower..saleschannel								s WITH (NOLOCK)
				--ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname
				ON a.sales_channel_role = 'Sales Channel/' + s.channelname
			LEFT JOIN LibertyPower..AccountLanguage								l WITH (NOLOCK)
				ON l.AccountNumber = a.account_number
			LEFT JOIN   lp_account..account_name								b  WITH (NOLOCK)
				ON b.account_id = a.account_id AND b.name_link = a.account_name_link 
			LEFT JOIN   lp_account..account_name								z  WITH (NOLOCK)
				ON z.account_id = a.account_id AND z.name_link = a.customer_name_link 
			LEFT JOIN   lp_account..account_address								c  WITH (NOLOCK)
				ON c.account_id = a.account_id AND c.address_link = a.billing_address_link 
			LEFT JOIN   lp_account..account_address								w  WITH (NOLOCK)
				ON w.account_id = a.account_id AND w.address_link = a.service_address_link 
			LEFT JOIN   lp_account..account_contact								d  WITH (NOLOCK)
				ON d.account_id = a.account_id AND d.contact_link = a.customer_contact_link 
			LEFT JOIN	(	select AccountID, max(CalculatedDate) as maxdate
							from LibertyPower..AccountEtf  WITH (NOLOCK)
							group by AccountID
						)														m
				ON m.accountId = a.accountId 
			LEFT JOIN LibertyPower..AccountEtf									f WITH (NOLOCK)
				ON (m.AccountID = f.AccountID	and		m.maxdate = f.CalculatedDate)

			WHERE a.contract_nbr = @contract_number 
		
			IF @@ROWCOUNT > 0 
				GOTO FINAL 
		END -- existing contract

	-- Check new Contract tables 
	-- lp_deal_capture..deal_contract_account 
	-- ========================================================
	IF EXISTS(	select 1
				from lp_deal_capture..deal_contract_account a  WITH (NOLOCK) 
				where a.contract_nbr = @contract_number
				and (@account_id is null	or	a.account_id = @account_id)	)
		BEGIN 
			print 'from lp_deal_capture..deal_contract_account (#2)'
			INSERT INTO @temp_multi_rate
			SELECT 
				a.utility_id,
				a.account_number, 
				'' as account_type, 
				b.full_name as account_name, 
				z.full_name as customer_name, 

				a.business_type, 
				a.business_activity, 
				d.first_name, 
				d.last_name, 
				d.title, 
				d.phone, 
				d.fax, 		                      
				d.email, 
				d.birthday, 
				IsNull(l.LanguageId, 1),

				a.contract_type, 
				a.contract_nbr, 		                      

				w.address, 
				w.suite, 
				w.city, 
				w.county, 		                      
				w.state, 
				w.zip, 

				a.billing_address_link ,
				c.address, 
				c.suite, 
				c.city, 
				c.county, 		                   
				c.state, 
				c.zip, 

				a.product_id,
				a.rate, 
				'' as customer_id, 
				a.retail_mkt_id, 
				a.rate_id , 
				0,
				term_months = '',
				a.account_id 

				, date_flow_start = null 
				, a.sales_channel_role 
				, annual_usage = 0 
				, estimated_annual_usage  = 0 
				
				, a.contract_eff_start_date
				, a.date_end
				, date_deenrollment = ''
				, IsNull(f.EtfFinalAmount, 0)								AS EtfAmount
			  , a.sales_channel_role										AS ChannelName
			  , s.ContactEmail												AS ChannelEmail
			  , s.ContactPhone												AS ChannelPhone
			  , s.ContactFax												AS ChannelFax
			  , CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END			AS IsChannelActive
			  , s.AllowInfoOnWelcomeLetter
			  , s.AllowInfoOnRenewalLetter
			  , s.AllowInfoOnRenewalNotice
			  , null
			  , null
			  , null
			  , null
			FROM lp_deal_capture..deal_contract_account						a WITH (NOLOCK)
			LEFT JOIN LibertyPower..SalesChannel							s WITH (NOLOCK)
				ON a.sales_channel_role = 'Sales Channel/' + s.channelname
			LEFT JOIN LibertyPower..AccountLanguage							l WITH (NOLOCK)
				ON l.AccountNumber = a.account_number
			LEFT JOIN   lp_deal_capture..deal_name							b WITH (NOLOCK)
				ON b.contract_nbr = a.contract_nbr AND b.name_link = a.account_name_link 
			LEFT JOIN   lp_deal_capture..deal_name							z WITH (NOLOCK)
				ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link 
			LEFT JOIN   lp_deal_capture..deal_address						c WITH (NOLOCK)
				ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link 
			LEFT JOIN   lp_deal_capture..deal_address						w WITH (NOLOCK)
				ON w.contract_nbr = a.contract_nbr AND w.address_link = a.service_address_link 
			LEFT JOIN   lp_deal_capture..deal_contact						d WITH (NOLOCK)
				ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link 
			LEFT JOIN   lp_account..account									e WITH (NOLOCK)
				ON e.account_id = a.account_id 
			LEFT JOIN	(	select AccountID, max(CalculatedDate) as maxdate
							from LibertyPower..AccountEtf  WITH (NOLOCK)
							group by AccountID
						)													m
				ON m.accountId = e.accountId 
			LEFT JOIN LibertyPower..AccountEtf								f WITH (NOLOCK)
				ON (m.AccountID = f.AccountID	and		m.maxdate = f.CalculatedDate)

			WHERE a.contract_nbr = @contract_number 

			IF @@ROWCOUNT > 0 
				GOTO FINAL 
		END -- new contract 

	-- Check new Contract tables 
	-- lp_deal_capture..multi_rates and lp_deal_cature..deal_contract_print 
	-- ========================================================
	BEGIN 
		print 'new contract no ETF amount'
		--New Contract; no accounts exist! return record anyway
		-- ========================================================	
	
		INSERT INTO @temp_multi_rate
		SELECT     
			CASE WHEN a.utility_id = 'NONE' or a.utility_id is null 
				THEN b.utility_id
				ELSE a.utility_id
			END														AS UtilityID,

			'' 														AS AccountNumber, 
			'' 														AS AccountType, 		
			'' 														AS account_full_name, 
			'' 														AS customer_full_name,
			'' 														AS BusinessType, 
			'' 														AS BusinessActivity, 

			'' 														AS ContactFirstName, 
			'' 														AS ContactLastName, 
			'' 														AS ContactTitle, 
			'' 														AS ContactPhone, 
			'' 														AS ContactFax, 		                      
			'' 														AS ContactEmail, 
			'' 														AS ContactBirthday, 
			1														AS LanguageId,		--Defaulting to English since we have no information

			'' 														AS ContractType, 
			rtrim(a.contract_nbr)									AS ContractNumber, 		                      
			''														AS ServiceAddress1,
			''														AS ServiceAddress2, 
			''														AS ServiceCity,
			''														AS ServiceCounty,
			''														AS ServiceState,
			''														AS ServiceZip,

			''														AS BillingAddressLink,
			''														AS BillingAddress1,
			''														AS BillingAddress2,
			''														AS BillingCity,
			''														AS BillingCounty,
			''														AS BillingState,
			''														AS BillingZip,

			CASE WHEN a.product_id  = 'NONE' or a.product_id is null 
					THEN b.product_id 
					ELSE a.product_id
				END													AS Product_ID,

			CASE WHEN a.rate = 0 or a.rate is null
					THEN b.rate 
					ELSE a.rate
				END													AS Rate,

			''														AS customer_id,
			a.retail_mkt_id											AS Market,

			--rate_id = 999999999 seems to be some sort of psuedo-rate used in deal capture.  Returns bad term/zone data from common_product_rate when found.
			CASE WHEN (a.rate_id = 0	or a.rate_id = 999999999	or a.rate_id is null) 
					THEN b.rate_id 
					ELSE a.rate_id
				END													AS rate_id

			, 0														AS forced_rowcount
			, Case WHEN term_months>0 THEN term_months ELSE '' END	AS term_months
			, ''													AS account_id

			, null													AS date_flow_start
			, s.ChannelDescription									AS sales_channel_role
			, 0														AS annual_usage
			, 0														AS estimated_annual_usage

			, a.contract_eff_start_date
			, ''													AS date_end
			, ''													AS date_deenrollment
			, 0.00													AS etf_amount
			, s.ChannelDescription									AS ChannelName
			, s.ContactEmail										AS ChannelEmail
			, s.ContactPhone										AS ChannelPhone
			, s.ContactFax											AS ChannelFax
			, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END	AS IsChannelActive
			, s.AllowInfoOnWelcomeLetter
			, s.AllowInfoOnRenewalLetter
			, s.AllowInfoOnRenewalNotice
			, null
			, null
			, null
			, null
		FROM lp_deal_capture..deal_contract_print				a WITH (NOLOCK) 
		LEFT JOIN libertypower..saleschannel					s WITH (NOLOCK)
			ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname
		LEFT JOIN lp_deal_capture..multi_Rates					b WITH (NOLOCK)
			ON a.contract_nbr = b.contract_nbr 
		WHERE a.contract_nbr = @contract_number 
	END
	
FINAL: 

	-----****************MULTI-TERM implementation start here**********************----------
	DECLARE AccountCursor CURSOR FAST_FORWARD FOR

	SELECT	mr.account_number,
			convert(decimal(13,5), mr.rate) as rate,
			cmnP.is_flexible as showRate
	FROM @temp_multi_rate mr
		INNER JOIN lp_common..common_product cmnP ON cmnP.product_id = mr.product_id
	ORDER BY account_number

	OPEN AccountCursor;
		FETCH NEXT FROM AccountCursor INTO @AccountNumber, @AssignedRate, @ShowRate;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @priceId = -1;

			IF EXISTS(	
				select 1
				from lp_account..account_renewal a WITH (NOLOCK) 
				where a.contract_nbr = @contract_number
				and (@account_id is null	or	a.account_id = @account_id)	
			)
				BEGIN
					SELECT @priceId = PriceID
					FROM lp_account..account_renewal WITH (NOLOCK)
					WHERE rtrim(contract_nbr) = @contract_number
					AND rtrim(account_number) = @AccountNumber
					GOTO CONTINUING;			
				END
				
			IF EXISTS(	
				select 1
				from lp_contract_renewal..deal_contract_account a WITH (NOLOCK) 
				where a.contract_nbr = @contract_number
				and (@account_id is null	or	a.account_id = @account_id)	
			)
				BEGIN
					SELECT @priceId = PriceID
					FROM lp_contract_renewal..deal_contract_account
					WHERE contract_nbr = @contract_number
					AND account_number=@AccountNumber	
					GOTO CONTINUING;			
				END
			
			IF EXISTS(	
				select 1
				from lp_contract_renewal..deal_contract a WITH (NOLOCK) 
				where a.contract_nbr = @contract_number	
			)
				BEGIN
					SELECT @priceId = PriceID
					FROM lp_contract_renewal..deal_contract
					WHERE contract_nbr = @contract_number
					GOTO CONTINUING;
				END
				
			IF EXISTS(
				select 1
				from lp_account..account a  WITH (NOLOCK) 
				where a.contract_nbr = @contract_number
				and (@account_id is null	or	a.account_id = @account_id)	
			)
				BEGIN
					SELECT @priceId = PriceID
					FROM lp_account..account
					WHERE contract_nbr = @contract_number
					AND account_number = @AccountNumber
					GOTO CONTINUING;
				END
				
			IF EXISTS(	
				select 1
				from lp_deal_capture..deal_contract_account a  WITH (NOLOCK) 
				where a.contract_nbr = @contract_number
				and (@account_id is null	or	a.account_id = @account_id)	
			)	
				BEGIN
					SELECT @priceId = PriceID 
					FROM lp_deal_capture.dbo.deal_contract_account
					WHERE contract_nbr = @contract_number
					AND account_number = @AccountNumber
					GOTO CONTINUING;
				END
					
			SELECT @priceId= PriceID
			FROM lp_deal_capture..deal_contract_print WITH (NOLOCK)
			WHERE contract_nbr = @contract_number
			AND RateString is not null
		
		CONTINUING:
			SET @TermStatement = ''
			SET @RateStatement = ''
			SET @DefaultRateStatement = ''
			SET @WelcomeRateStatement = ''
			SET @Count = 1;
			SET @TermLength = 0;
			
			IF (@priceId > 0)
			BEGIN
				DECLARE MultiTermCursor CURSOR FAST_FORWARD FOR
			
				SELECT pcm.StartDate, DATEAdd(d,-1,DateAdd(m,pcm.term,pcm.StartDate)), pcm.Price, pcm.term
				FROM LibertyPower.dbo.ProductCrossPriceMulti pcm with(nolock)
					INNER JOIN LibertyPower.dbo.Price p with(nolock) ON p.ProductCrossPriceID=pcm.ProductCrossPriceID
					--LEFT OUTER JOIN LibertyPower.dbo.AccountContractRate ACR ON ACR.
				WHERE p.ID=@priceId
			
				OPEN MultiTermCursor;
				FETCH NEXT FROM MultiTermCursor into @StartDate, @EndDate, @Rate, @CurrTermLength;
				
				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF @TermStatement = ''
						SET @TermStatement = 'Sub-term #' + Convert(varchar(2),@Count)+': Months 1 to '+ Convert(varchar(2), @CurrTermLength);
					ELSE 
						SET @TermStatement = @TermStatement + char(13)+ 'Sub-term #' + Convert(varchar(2),@Count)+': Months '+ Convert(varchar(2), @TermLength+1)+' to '+ Convert(varchar(2), @TermLength+@CurrTermLength);

					IF @WelcomeRateStatement = ''
						BEGIN
							IF (@AssignedRate > 0) SET @Delta = @AssignedRate-@Rate
							ELSE SET @Delta = 0
							
							SET @WelcomeRateStatement = 'Sub-term #' + Convert(varchar(2),@Count)+': $'+ Convert(varchar(7), @Rate+@Delta) +'/kWh*';
						END
					ELSE 
						SET @WelcomeRateStatement = @WelcomeRateStatement + char(13)+ 'Sub-term #' + Convert(varchar(2),@Count)+': $'+ Convert(varchar(7), @Rate+@Delta)+'/kWh*';
							
					IF (@ShowRate = 1)
					BEGIN
						IF @RateStatement = ''
							BEGIN
								SET @RateStatement = 'Sub-term #' + Convert(varchar(2),@Count)+': $_________/kWh*';
							END
						ELSE 
							SET @RateStatement = @RateStatement + char(13)+ 'Sub-term #' + Convert(varchar(2),@Count)+': $_________/kWh*';
					END	
					ELSE
					BEGIN
						IF @RateStatement = ''
							BEGIN
								SET @RateStatement = 'Sub-term #' + Convert(varchar(2),@Count)+': $'+ Convert(varchar(7), @Rate) +'/kWh*';
							END
						ELSE 
							SET @RateStatement = @RateStatement + char(13)+ 'Sub-term #' + Convert(varchar(2),@Count)+': $'+ Convert(varchar(7), @Rate)+'/kWh*';
					END
					
					IF @DefaultRateStatement = ''
						SET @DefaultRateStatement = 'Sub-term #' + Convert(varchar(2),@Count)+': $_______/kWh*';
					ELSE 
						SET @DefaultRateStatement = @DefaultRateStatement + char(13) + 'Sub-term #' + Convert(varchar(2),@Count)+': $_______/kWh*';
							
					SET @Count = @Count + 1;
					SET @TermLength = @TermLength + @CurrTermLength;
				   FETCH NEXT FROM MultiTermCursor into @StartDate, @EndDate, @Rate, @CurrTermLength;
				END
				
				CLOSE MultiTermCursor;
				DEALLOCATE MultiTermCursor;	
			END
			ELSE
			BEGIN
				DECLARE @SubTermString nvarchar(50)
				DECLARE @TempString nvarchar(50)
				DECLARE @Indx int
				
				SELECT @SubTermString = ISNULL(SubTermString,'')
				FROM lp_deal_capture..deal_contract_print WITH (NOLOCK)
				WHERE contract_nbr = @contract_number
				AND RateString IS NULL
				
				WHILE (LEN(@SubTermString)>0)
				BEGIN
					SET @Indx = CHARINDEX(',', @SubTermString)
					
					IF (@Indx > 0)
					BEGIN
						SET @TempString = SUBSTRING(@SubTermString, 0, @Indx )
						SET @SubTermString = SUBSTRING(@SubTermString, @Indx+1, LEN(@SubTermString)- @Indx)
					END
					ELSE
					BEGIN
						SET @TempString = @SubTermString
						SET @SubTermString = ''
					END
					
					IF @TermStatement = ''
						SET @TermStatement = 'Sub-term #' + Convert(varchar(2), @Count)+': Months 1 to ' + @TempString;
					ELSE 
						SET @TermStatement = @TermStatement + char(13) + 'Sub-term #' + Convert(varchar(2),@Count) + ': Months ' 
											+ Convert(varchar(2), @TermLength+1) + ' to ' + Convert(varchar(2), @TermLength + CONVERT(int, @TempString));
					
					IF @RateStatement = ''
						SET @RateStatement = 'Sub-term #' + Convert(varchar(2), @Count) + ': $_________/kWh*';
					ELSE 
						SET @RateStatement = @RateStatement + char(13) + 'Sub-term #' + Convert(varchar(2), @Count) + ': $_________/kWh*';
					
					IF @DefaultRateStatement = ''
						SET @DefaultRateStatement = 'Sub-term #' + Convert(varchar(2), @Count) + ': $_______/kWh*';
					ELSE 
						SET @DefaultRateStatement=@DefaultRateStatement + char(13) + 'Sub-term #' + Convert(varchar(2), @Count) + ': $_______/kWh*';
						
					IF @WelcomeRateStatement = ''
						SET @WelcomeRateStatement = 'Sub-term #' + Convert(varchar(2), @Count) + ': $_______/kWh*';
					ELSE 
						SET @WelcomeRateStatement = @DefaultRateStatement + char(13) + 'Sub-term #' + Convert(varchar(2), @Count) + ': $_______/kWh*';

					SET @TermLength = @TermLength + CONVERT(int, @TempString)				
					SET @Count = @Count + 1;
				END
			END
			
			UPDATE @temp_multi_rate
			SET SubTermList = @TermStatement
				,SubRateList = @RateStatement
				,DefaultSubRateList = @DefaultRateStatement
				,WelcomeSubRateList = @WelcomeRateStatement
			WHERE account_number = @AccountNumber
			
			FETCH NEXT FROM AccountCursor into @AccountNumber, @AssignedRate, @ShowRate;
		END
		CLOSE AccountCursor;
		DEALLOCATE AccountCursor;
	-----****************MULTI-TERM implementation end here**********************---------- 

	-- pad rows
	SELECT @current_row_count = count(1) FROM @temp_multi_rate

	IF @force_row_count <> 0 AND @current_row_count < @force_row_count
	BEGIN 
		WHILE @current_row_count < @force_row_count
			BEGIN 
				INSERT  @temp_multi_rate ( forced_rowcount )
				SELECT @force_row_count - @current_row_count
				SET @current_row_count = @current_row_count + 1 
			END 
	END 
				
	-- FINAL SELECT 
	-- =============================================
	SELECT DISTINCT
		rtrim(a.utility_id)													AS UtilityID, 
		rtrim(e.utility_descp)												AS Utility, 

		rtrim(a.account_number)												AS AccountNumber, 
		rtrim(a.account_type)												AS AccountType, 	
		rtrim(a.account_name)												AS AccountName, 
		rtrim(a.customer_name)												AS CustomerName, 
		rtrim(a.business_type)												AS BusinessType, 
		rtrim(a.business_activity)											AS BusinessActivity, 

		rtrim(a.first_name)													AS ContactFirstName, 
		rtrim(a.last_name)													AS ContactLastName, 
		rtrim(a.title)														AS ContactTitle, 
		rtrim(a.phone)														AS ContactPhone, 
		rtrim(a.fax)														AS ContactFax, 		                      
		rtrim(a.email)														AS ContactEmail, 
		rtrim(a.birthday)													AS ContactBirthday, 
		a.LanguageId														AS LanguageId,

		rtrim(a.contract_type)												AS ContractType, 
		rtrim(a.contract_number)											AS ContractNumber, 	

		rtrim(a.service_address)											AS ServiceAddress1, 
		rtrim(a.service_suite)												AS ServiceAddress2, 
		rtrim(a.service_city)												AS ServiceCity, 
		rtrim(a.service_county)												AS ServiceCounty, 		                      
		rtrim(a.service_state)												AS ServiceState, 
		rtrim(a.service_zip)												AS ServiceZip, 

		a.billing_address_link												AS BillingAddressLink,
		rtrim(a.billing_address)											AS BillingAddress1, 
		rtrim(a.billing_suite)												AS BillingAddress2, 
		rtrim(a.billing_city)												AS BillingCity, 
		rtrim(a.billing_county)												AS BillingCounty, 		                   
		rtrim(a.billing_state)												AS BillingState, 
		rtrim(a.billing_zip)												AS BillingZip, 

		rtrim(a.product_id)													AS ProductID, 
		a.product_id,
--		ROUND(a.Rate * ISNULL(1 + t.SalesTax,1) ,5)							AS Rate,						--TEMPORARY KLUDGE TO ADD SALES TAX FOR NEW JERSEY
		a.Rate																AS Rate,						--Removed after SR1-32513577
		a.forced_rowcount,
		a.customer_id, 
		a.retail_mkt_id														AS Market, 
		a.rate_id, 
	
		CASE WHEN (a.term_months = '' or a.term_months = 0) THEN	--Now would be a good time to implement SQL source control and limit direct DB access.
			CASE WHEN pr.term_months = 0 THEN ''
				ELSE pr.term_months END
			ELSE a.term_months
		END																	AS Term,

		--CASE WHEN a.term_months = '' THEN pr.term_months
		--	ELSE a.term_months
		--END																	--AS Term,
		rtrim(dbo.ufn_convert_number_to_words(	case when a.term_months = 0
												then pr.term_months 
												else a.term_months end)
		)																	AS TermInWords,
		rtrim(p.product_descp)												AS ProductName,
		rtrim('Short Desc to be added')										AS ProductDescription,
		rtrim(p.product_category)											AS ProductCategory,
		rtrim(pr.rate_descp)												AS ProductRateDescription,
		ltrim(rtrim(v.service_rate_class))									AS SC,
		ltrim(rtrim(z.zone))												AS Zone,

		a.account_id ,
		i.BillingAccount
		, REPLACE( ISNULL(CONVERT(char ,  a.date_flow_start , 101 ) , '')  , '01/01/1900' , '' )   --case when replace( isnull(convert(char, a.date_flow_start, 101) , '') , '01/01/1900' , '' ) = '' then ''  else  ltrim(rtrim( cast( month(a.date_flow_start) as char ) ))  + '/' + ltrim(rtrim( cast( year(a.date_flow_start) as char ))) end   
																			AS FlowStartDate
		--, a.sales_channel_role												AS ChannelPartnerName
		, a.ChannelName														AS ChannelPartnerName
		, a.annual_usage													AS AnnualUsage
		, a.estimated_annual_usage											AS EstAnnualUsage
		
		, ''																AS OMSRate		-- place holder for data being retrieved from OMS 
		, ISNULL((
					select top 1 name_key 
					from lp_account..account_info
					where account_id = a.account_id 
					and utility_id = a.utility_id ),
				'')															AS NameKey

		, CASE WHEN REPLACE( ISNULL(CONVERT(char, a.contract_eff_start_date, 101) , '') , '01/01/1900' , '' ) = ''
			THEN ''
			ELSE LTRIM(RTRIM( CAST( month(a.contract_eff_start_date) as char ) ))  + '/' + LTRIM(RTRIM( CAST( year(a.contract_eff_start_date) as char )))
		END																	AS EffectiveStartDate

		, ISNULL((
					select top 1 meter_number 
					from lp_account..account_meters
					where account_id = a.account_id ),
				'')															AS MeterNumber

		, CASE WHEN REPLACE( ISNULL(CONVERT(char, a.date_end, 101) , '') , '01/01/1900' , '' ) = ''
			THEN ''
			ELSE LTRIM(RTRIM( CAST( month(a.date_end) as char ) ))  + '/' + LTRIM(RTRIM( CAST( year(a.date_end) as char )))
		END																	AS EndDate
		
		, CASE WHEN REPLACE( ISNULL(CONVERT(char, a.date_deenrollment, 101) , '') , '01/01/1900' , '' ) = ''
			THEN ''
			ELSE ISNULL(CONVERT(char, a.date_deenrollment, 101) , '')
		END																	AS DeEnrollmentDate
		, a.etf_amount														AS EtfAmount

		, a.ChannelName
		, a.ChannelEmail
		, a.ChannelPhone
		, a.ChannelFax
		, a.ChannelIsActive
		, a.AllowInfoOnWelcomeLetter
		, a.AllowInfoOnRenewalLetter
		, a.AllowInfoOnRenewalNotice
		, IsNull(a.account_id, @account_id)									AS account_id		--Just in case we can't find anything, return param
-----MULTI-TERM
		, a.SubTermList
		, a.SubRateList
		, a.DefaultSubRateList
		, a.WelcomeSubRateList

	FROM @temp_multi_rate									a
	LEFT JOIN lp_common..common_product						p WITH (NOLOCK)
		ON a.product_id = p.product_id
	LEFT JOIN lp_common..common_product_rate				pr WITH (NOLOCK)
		ON a.product_id = pr.product_id and a.rate_id = pr.rate_id
	LEFT JOIN lp_common..common_utility						e WITH (NOLOCK)
		ON a.utility_id = e.utility_id 
	LEFT JOIN lp_common..service_rate_class					v WITH (NOLOCK)
		ON v.service_rate_class_id = pr.service_rate_class_id
	LEFT JOIN lp_common..zone								z WITH (NOLOCK)
		ON z.zone_id = pr.zone_id
	LEFT JOIN lp_account..account_info						i WITH (NOLOCK)
		ON a.account_id = i.account_id 

	LEFT JOIN LibertyPower..MarketSalesTax							t WITH (NOLOCK)		--TEMPORARY KLUDGE TO ADD SALES TAX FOR NEW JERSEY
		ON t.MarketId = e.MarketID
		and t.EffectiveStartDate < GETDATE()

	WHERE (@account_id IS NULL				OR	a.account_id = @account_id)
	ORDER BY 1 DESC	--Ensure that the empty rows come last
END


GO
