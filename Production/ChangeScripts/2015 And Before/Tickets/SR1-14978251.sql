/*
	SCRIPT TO ADD SALES CHANNEL INFORMATION TO TEMPORARY TABLE USED TO GENERATE NEW CONTRACTS.  ALSO ADDS THIS INFORMATION TO PRINTED TEMPLATE
*/

USE lp_deal_capture

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

BEGIN TRANSACTION
GO
ALTER TABLE dbo.deal_contract_print ADD
	sales_channel_role nvarchar(50) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Added field to capture same info as other new contract tables'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'deal_contract_print', N'COLUMN', N'sales_channel_role'
GO
COMMIT


---------------------------------


USE [lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_print_contracts_ins]    Script Date: 06/15/2012 15:22:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- exec usp_print_contracts_ins 'admin', 'TX', 'AEPNO', 'BGE-FIXED-12', 3, 2, '20060403 - OO'
-- ================================================================
-- Modified 8/30/2007  Gail Mangaroo
-- Removed selection of template from common_product_template
-- ================================================================
-- Modified 1/25/2008 Gail Mangaroo
-- Added contract_print_type parameter - indicates whether contract is single / multi or custom rate
-- ================================================================
-- Modified 3/20/2009
-- Added check for rate_id = 999999999 when validating product rate SD#7669
-- ================================================================
-- Modified 09/26/2011 - Ryan Russon
-- Added TemplateId and applied ApexSQL formatting
-- ================================================================
-- Modified 06/15/2012 - Ryan Russon
-- Added @SalesChannel param to populate new sales_channel_role field in lp_deal_capture..deal_contract_print
-- ================================================================
ALTER PROCEDURE [dbo].[usp_print_contracts_ins](
	@p_username				nchar( 100 ),
	@p_retail_mkt_id		char( 02 ),
	@p_utility_id			char( 15 ),
	@p_product_id			char( 20 ),
	@p_rate_id				int,
	@p_qty					int,
	@p_request_id			varchar( 20 ),
	@p_error				char( 01 ) = ' ',
	@p_msg_id				char( 08 ) = ' ',
	@p_descp				varchar( 250 ) = ' ',
	@p_result_ind			char( 01 ) = 'Y',
	@p_contract_rate_type	varchar( 50 ) = '',
	@p_TemplateId			int,
	@SalesChannel			varchar( 50 )
--@p_include_meter_charge				int = 0
)
AS

DECLARE	@w_error char( 01 )
DECLARE	@w_msg_id char( 08 )
DECLARE	@w_descp varchar( 250 )
DECLARE	@w_return int
SELECT	@w_error = 'I'
SELECT	@w_msg_id = '00000001'
SELECT	@w_descp = ' '
SELECT	@w_return = 0
DECLARE	@w_descp_add varchar( 10 )
SELECT	@w_descp_add = ' '
DECLARE	@w_application varchar( 20 )
SELECT	@w_application = 'COMMON'
DECLARE	@w_puc_certification_number varchar( 20 )
SELECT	@w_puc_certification_number = puc_certification_number
FROM lp_common..common_retail_market WITH (NOLOCK)
WHERE retail_mkt_id = @p_retail_mkt_id

DECLARE	@w_start_contract int
DECLARE	@w_contract_nbr char( 12 )
DECLARE	@w_product_category char( 20 )
SELECT	@w_product_category = ' '
DECLARE	@w_term_months int
SELECT	@w_term_months = 0
SELECT	@w_product_category = product_category
FROM lp_common..common_product WITH (NOLOCK INDEX = common_product_idx)
WHERE product_id = @p_product_id
AND inactive_ind = '0'

IF @@rowcount = 0
AND @p_contract_rate_type <> 'CUSTOM'
	BEGIN
		SELECT
			@w_descp_add = '(Product)'
		GOTO create_error
	END
IF @p_qty <= 0
	BEGIN
		SELECT
			@w_descp_add = '(Quantity)'
		GOTO create_error
	END

DECLARE	@w_rate float
SELECT	@w_rate = 0
DECLARE	@w_rate_descp varchar( 50 )
SELECT	@w_rate_descp = ' '
DECLARE	@w_contract_eff_start_date datetime
SELECT	@w_contract_eff_start_date = '19000101'
DECLARE	@w_grace_period int
SELECT	@w_grace_period = 0

SELECT
	@w_rate = rate,
	@w_rate_descp = rate_descp,
	@w_contract_eff_start_date = contract_eff_start_date,
	@w_term_months = term_months,
	@w_grace_period = grace_period
FROM lp_common..common_product_rate WITH (NOLOCK INDEX = common_product_rate_idx)
WHERE product_id = @p_product_id
  AND rate_id = @p_rate_id
  AND CONVERT(char( 08 ), GETDATE(), 112) >= eff_date
  AND CONVERT(char( 08 ), GETDATE(), 112) < due_date
  AND inactive_ind = '0'


IF @@rowcount = 0 AND @p_rate_id <> 999999999
	BEGIN
		-- added gm 01222008
		IF @p_contract_rate_type = 'CUSTOM'
			BEGIN
				SELECT @w_rate = 0
				SELECT @w_rate_descp = ' '
				SELECT @w_contract_eff_start_date = '19000101'
				SELECT @w_grace_period = 0
				SELECT @w_term_months = 0
			END
		ELSE
			BEGIN
				SELECT @w_descp_add = '(Rate)'
				GOTO create_error
			END
	END

DECLARE @w_contract_template varchar( 50 )
SET @w_contract_template = ' '

/*
select @w_contract_template                         = contract_template
from lp_common..common_product_template with (NOLOCK INDEX = common_product_template_idx)
where product_id                                    = @p_product_id
and   getdate()                                    >= eff_date
and   getdate()                                     < due_date
and   inactive_ind                                  = '0'

if @@rowcount                                       = 0
begin
   select @w_descp_add                              = '(Template)'
   goto create_error
end
*/

SELECT	@w_start_contract = 1
SELECT	@w_contract_nbr = ' '

WHILE @w_start_contract <= @p_qty
	BEGIN
		EXEC @w_return = usp_get_key @p_username, 'CREATE CONTRACTS', @w_contract_nbr OUTPUT, 'N'
		
		IF @w_return <> 0
			BEGIN
				SELECT
					@w_descp_add = '(Contract Number)'
				GOTO create_error
			END
		
		SELECT @w_return = 0

		INSERT INTO deal_contract_print (
			request_id,
			[status],
			contract_nbr,
			username,
			retail_mkt_id,
			puc_certification_number,
			utility_id,
			product_id,
			rate_id,
			rate,
			rate_descp,
			term_months,
			contract_eff_start_date,
			grace_period,
			date_created,
			contract_template,
			contract_rate_type,
			TemplateId,
			sales_channel_role )
		SELECT
			@p_request_id,
			'PENDING',
			SUBSTRING( @w_contract_nbr, 1, 12 ),
			@p_username,
			@p_retail_mkt_id,
			@w_puc_certification_number,
			@p_utility_id,
			@p_product_id,
			@p_rate_id,
			@w_rate,
			@w_rate_descp,
			@w_term_months,
			@w_contract_eff_start_date,
			@w_grace_period,
			GETDATE(),
			@w_contract_template,
			@p_contract_rate_type,
			@p_TemplateId,
			@SalesChannel

		IF @@error <> 0 OR @@rowcount = 0
			BEGIN
				GOTO create_error
			END
		
		SELECT @w_start_contract = @w_start_contract + 1
	END

SELECT	@w_return = 0

UPDATE deal_contract_print
SET
	status = 'COMPLETED'
WHERE
	request_id = @p_request_id
GOTO SelectMessages


create_error:
--   delete deal_contract_print
--   where request_id                                 = @p_request_id
SELECT	@w_application = 'DEAL'
SELECT	@w_error = 'E'
SELECT	@w_msg_id = '00000001'
SELECT	@w_return = 1


SelectMessages:
IF @w_error <> 'N'
	BEGIN EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp OUTPUT, @w_application
		SELECT
			@w_descp = LTRIM( RTRIM( @w_descp )) + ' ' + @w_descp_add
	END

IF @p_result_ind = 'Y'
	BEGIN
		IF @p_request_id = 'SALESCHANNEL'
			BEGIN
				SELECT
					flag_error = @w_error,
					code_error = @w_msg_id,
					message_error = ISNULL( CONVERT(varchar( 250 ), @w_contract_nbr), @w_descp )
			END
		ELSE
			BEGIN
				SELECT
					flag_error = @w_error,
					code_error = @w_msg_id,
					message_error = @w_descp
			END

		RETURN @w_return
	END

SELECT
	@p_error = @w_error,
	@p_msg_id = @w_msg_id,
	@p_descp = @w_descp

GO



---------------------------------


USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_document_print_template_table_mulitrate_sel]    Script Date: 06/19/2012 13:56:25 ******/
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
-- 07/01/2009	-- GM modified format of Effective and Flow Start Datees to mm/yyyy
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
-- ==================================================================================
ALTER PROCEDURE [dbo].[usp_document_print_template_table_mulitrate_sel] 
(
	@contract_number		char(12),
	@force_row_count		int = 0,
	@account_id				varchar(40) = null
) 

AS

BEGIN
	
	DECLARE @current_row_count int 

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
--			print 'from account_renewal (1)'
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
			--, replace(s.ChannelDescription, 'Sales Channel/','')		AS ChannelName
			, s.ChannelDescription										AS ChannelName
			, s.ContactEmail											AS ChannelEmail
			, s.ContactPhone											AS ChannelPhone
			, s.ContactFax												AS ChannelFax
			, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END		AS IsChannelActive
			, s.AllowInfoOnWelcomeLetter
			, s.AllowInfoOnRenewalLetter
			, s.AllowInfoOnRenewalNotice

		FROM lp_account..account_renewal								a WITH (NOLOCK)
		LEFT JOIN LibertyPower..SalesChannel							s WITH (NOLOCK)
			--ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname
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
		--LEFT JOIN libertypower..AccountEtf				f WITH (NOLOCK)
		--	ON f.accountId = e.accountId AND f.CalculatedDate = (select max(CalculatedDate) from f where accountid = e.accountId)
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


--			print 'from RENEWAL..deal_contract_account (2)'
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
				--NEW SalesChannel items
				--, replace(s.ChannelDescription, 'Sales Channel/','')		AS ChannelName
				, a.sales_channel_role										AS ChannelName
				, s.ContactEmail											AS ChannelEmail
				, s.ContactPhone											AS ChannelPhone
				, s.ContactFax												AS ChannelFax
				, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END		AS IsChannelActive
				, s.AllowInfoOnWelcomeLetter
				, s.AllowInfoOnRenewalLetter
				, s.AllowInfoOnRenewalNotice
				
			FROM lp_contract_renewal..deal_contract_account					a WITH (NOLOCK)
				--LEFT JOIN   lp_contract_renewal..deal_name  b  (NOLOCK) ON b.contract_nbr = a.contract_nbr AND b.name_link = a.account_name_link 
				--LEFT JOIN   lp_contract_renewal..deal_name  z  (NOLOCK) ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link 
				--LEFT JOIN   lp_contract_renewal..deal_address  c  (NOLOCK) ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link 
				--LEFT JOIN   lp_contract_renewal..deal_address  w  (NOLOCK) ON w.contract_nbr = a.contract_nbr AND w.address_link = a.service_address_link 
				--LEFT JOIN   lp_contract_renewal..deal_contact  d  (NOLOCK) ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link
			JOIN @accounts													dca
				ON dca.account_id = a.account_id
			LEFT JOIN LibertyPower..SalesChannel							s WITH (NOLOCK)
				--ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname
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
		
--			print 'ETF is hardcoded to 0.0 (3)'
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
				--NEW SalesChannel items
				--, replace(s.ChannelDescription, 'Sales Channel/','')		AS ChannelName
				, a.sales_channel_role										AS ChannelName
				, s.ContactEmail											AS ChannelEmail
				, s.ContactPhone											AS ChannelPhone
				, s.ContactFax												AS ChannelFax
				, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END		AS IsChannelActive
				, s.AllowInfoOnWelcomeLetter
				, s.AllowInfoOnRenewalLetter
				, s.AllowInfoOnRenewalNotice
				
			FROM lp_contract_renewal..deal_contract							a WITH (NOLOCK)
				--LEFT JOIN   lp_contract_renewal..deal_name  b  (NOLOCK) ON b.contract_nbr = a.contract_nbr AND b.name_link = a.account_name_link 
				--LEFT JOIN   lp_contract_renewal..deal_name  z  (NOLOCK) ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link 
				--LEFT JOIN   lp_contract_renewal..deal_address  c  (NOLOCK) ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link 
				--LEFT JOIN   lp_contract_renewal..deal_address  w  (NOLOCK) ON w.contract_nbr = a.contract_nbr AND w.address_link = a.service_address_link 
				--LEFT JOIN   lp_contract_renewal..deal_contact  d  (NOLOCK) ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link 
			JOIN @accounts													dca
				ON dca.contract_nbr = a.contract_nbr
			LEFT JOIN LibertyPower..SalesChannel							s WITH (NOLOCK)
				--ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname
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
--			print 'from account (4)'
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
				--NEW SalesChannel items
			--, replace(s.ChannelDescription, 'Sales Channel/','')	AS ChannelName
			, a.sales_channel_role									AS ChannelName
			, s.ContactEmail										AS ChannelEmail
			, s.ContactPhone										AS ChannelPhone
			, s.ContactFax											AS ChannelFax
			, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END	AS IsChannelActive
			, s.AllowInfoOnWelcomeLetter
			, s.AllowInfoOnRenewalLetter
			, s.AllowInfoOnRenewalNotice
				
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
			--LEFT JOIN   libertypower..AccountEtf								f  WITH (NOLOCK)
			--	ON f.accountId = a.accountId 
			--	AND f.CalculatedDate = (select max(CalculatedDate) from f where accountid = e.accountId)
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
--			print 'from lp_deal_capture..deal_contract_account (#2)'
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
				--NEW SalesChannel items
			  , a.sales_channel_role										AS ChannelName
			  , s.ContactEmail												AS ChannelEmail
			  , s.ContactPhone												AS ChannelPhone
			  , s.ContactFax												AS ChannelFax
			  , CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END			AS IsChannelActive
			  , s.AllowInfoOnWelcomeLetter
			  , s.AllowInfoOnRenewalLetter
			  , s.AllowInfoOnRenewalNotice

			FROM lp_deal_capture..deal_contract_account						a WITH (NOLOCK)
			LEFT JOIN LibertyPower..SalesChannel							s WITH (NOLOCK)
				--ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname
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
			--LEFT JOIN   libertypower..AccountEtf							f WITH (NOLOCK)
			--	ON f.accountId = e.accountId AND f.CalculatedDate = (select max(CalculatedDate) from f where accountid = e.accountId)
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
--		print 'new contract no ETF amount'
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

			CASE WHEN a.rate_id  = 0 or a.rate_id is null 
					THEN b.rate_id 
					ELSE a.rate_id
				END													AS rate_id

			, 0														AS forced_rowcount
			, ''													AS term_months
			, ''													AS account_id

			, null													AS date_flow_start
			--, replace(s.ChannelDescription, 'Sales Channel/','')	AS sales_channel_role
			, s.ChannelDescription									AS sales_channel_role
			, 0														AS annual_usage
			, 0														AS estimated_annual_usage

			, a.contract_eff_start_date
			, ''													AS date_end
			, ''													AS date_deenrollment
			, 0.00													AS etf_amount
			--NEW SalesChannel items
--			, replace(s.ChannelDescription, 'Sales Channel/','')		AS ChannelName
			--, a.sales_channel_role									AS ChannelName
			, s.ChannelDescription									AS ChannelName
			, s.ContactEmail										AS ChannelEmail
			, s.ContactPhone										AS ChannelPhone
			, s.ContactFax											AS ChannelFax
			, CASE WHEN s.SalesStatus IN (1,2) THEN 1 ELSE 0 END	AS IsChannelActive
			, s.AllowInfoOnWelcomeLetter
			, s.AllowInfoOnRenewalLetter
			, s.AllowInfoOnRenewalNotice

		FROM lp_deal_capture..deal_contract_print				a WITH (NOLOCK) 
		LEFT JOIN libertypower..saleschannel					s WITH (NOLOCK)
			ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname
		LEFT JOIN lp_deal_capture..multi_Rates					b WITH (NOLOCK)
			ON a.contract_nbr = b.contract_nbr 
		WHERE a.contract_nbr = @contract_number 
	END 



FINAL: 
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
		a.rate,
		a.forced_rowcount, 
		a.customer_id, 
		a.retail_mkt_id														AS Market, 
		a.rate_id, 
	
		CASE WHEN a.term_months = 0 THEN pr.term_months
			ELSE a.term_months
		END																	AS Term,
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

		--NEW SalesChannel items
		, a.ChannelName
		, a.ChannelEmail
		, a.ChannelPhone
		, a.ChannelFax
		, a.ChannelIsActive
		, a.AllowInfoOnWelcomeLetter
		, a.AllowInfoOnRenewalLetter
		, a.AllowInfoOnRenewalNotice
		, IsNull(a.account_id, @account_id)									AS account_id		--Just in case we can't find anything, return param

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
	WHERE (@account_id IS NULL				OR	a.account_id = @account_id)
	ORDER BY 1 DESC	--Ensure that the empty rows come last
END

GO


---------------------------------


USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_document_print_template_table_address_sel]    Script Date: 06/20/2012 09:48:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--EXEC usp_document_print_template_table_address_sel @contract_number='2012-0038264'

-- ==========================================================================
-- Created by: Gail Mangaroo
-- Create Date: 4/4/2008
-- Purpose: Returns data to be filled in the Product portion of templates
-- ==========================================================================
--
-- LOOKS FOR DOCUMENT PRINT DATA IN THE FOLLOWING ORDER:
--		Account Renewal Tables					( lp_account..account_renewal ) 
--		Renewal Deal Capture Contract Accounts	( lp_contract_renewal..deal_contract_account )
--		Renewal Deal Capture Contract			( lp_contract_renewal..deal_contract )
--		Account Tables							( lp_account..account )
--		Deal Capture Contract Accounts			( lp_deal_capture..deal_contract_account ) 
--		Deal Capture Contract - mulitrate		( lp_deal_capture..multi_rates ) 
--		Deal Capture Contract - single rate		( lp_deal_capture..deal_contract_print ) 
-- ==========================================================================
-- Modified 05/06/2008 - Added addiitonal data sources to cover renewal and contract print scenarios
-- Modified 02/02/2009 - Added GenerateDate field.
-- Modified 04/30/2009 - Added SSN Sales Rep and Term Fields 
-- Modified 05/01/2009 - Removed Term Fields -- template seems to pick up first field it finds with the tag name even if table name is specified 
-- Modified 05/08/2009 - Added TaxID field
-- Modified 06/03/2009 - Gail Mangaroo	- Added ChannelPartnerName field
-- Modified 06/30/2010 - Gail Mangaroo	- Added ContractTypeDesc field.
-- Modified 05/10/2011 - Ryan Russon	- Added ContactDate, formatted DateTime fields, and minor cleanup
-- Modified 04/13/2012 - Eric Hernandez/Ryan Russon	- Updated Account Renewal section to use new Account structure (shortening execution time by over 30 seconds)
-- Modified 06/15/2012 - Ryan Russon	- Added Sales Channel info for printing templates in Deal Capture, now available since we added sales_channel_role field to lp_deal_capture..deal_contract_print
-- ==========================================================================
ALTER PROCEDURE [dbo].[usp_document_print_template_table_address_sel] (
	@contract_number varchar(12) = NULL
)

AS

BEGIN
	SET NOCOUNT ON;

	--ALL SELECT STATEMENTS SHOULD HAVE SAME COLUMNS		
	-- ======================================================
	CREATE TABLE  #addressInfo (
		CustomerName varchar(100)
		,BusinessType varchar (35)
		,BusinessActivity varchar(35)
		,ContactFirstName varchar(50)
		,ContactLastName varchar(50)
		,ContactTitle varchar(20)
		,ContactPhone varchar(20)
		,ContactFax varchar(20)
		,ContactEmail varchar(256)
		,ContactBirthday varchar(10)
		,ContractType varchar(25) 
		,ContractNumber varchar(20)
		--,Term int
		--,TermInWords varchar (35)
		,BillingAddressLink int
		,BillingAddress1 varchar(50)
		,BillingAddress2 varchar(30)
		,BillingCity varchar(30)
		,BillingCounty varchar(10)
		,BillingState varchar(5)
		,BillingZip varchar(10)
		,SSN varchar(50)
		,SalesRep varchar(50)
		--Term varchar(10)  -- Do Not Use term Here. All Term fields in template will use this value !!!
		,TaxID varchar(50)
		,ChannelPartnerName varchar(50) 
		,ContractTypeDescp Varchar(25) 
	)

	IF @contract_number IS NULL						--If no ContractNumber was specified, return structure only
		GOTO DummyRow

	-- CHECK ACCOUNT RENEWAL TABLES
	-- ========================================================
	IF EXISTS(	select 1 
				--from lp_account..account_renewal a  WITH (NOLOCK) 
				from LibertyPower..[Contract] c WITH (NOLOCK)
				where c.Number =  @contract_number
				and c.ContractDealTypeID = 2 	)
		BEGIN 
			-- Get Data from Account Renewal Tables 
			INSERT INTO #addressInfo
			SELECT DISTINCT
				rtrim(z.full_name)								AS CustomerName,
				left(UPPER(isnull(BT.[Type],'NONE')),35)		AS BusinessType,
				left(UPPER(isnull(BA.Activity,'NONE')),35)		AS BusinessActivity,
				rtrim(d.first_name)								AS ContactFirstName, 
				rtrim(d.last_name)								AS ContactLastName, 
				rtrim(d.title)									AS ContactTitle,
				rtrim(d.phone)									AS ContactPhone, 
				rtrim(d.fax)									AS ContactFax,
				rtrim(d.email)									AS ContactEmail, 
				rtrim(d.birthday)								AS ContactBirthday, 
				LibertyPower.dbo.ufn_GetLegacyContractTypeByID ( con.ContractTypeID, con.ContractTemplateID, con.ContractDealTypeID )
																AS ContractType,
				rtrim(con.number)								AS ContractNumber,
				c.address_link									AS BillingAddressLink,
				rtrim(c.[address])								AS BillingAddress1,
				rtrim(c.suite)									AS BillingAddress2, 
				rtrim(c.city)									AS BillingCity, 
				rtrim(c.county)									AS BillingCounty,
				rtrim(c.[state])								AS BillingState, 
				rtrim(c.zip)									AS BillingZip,
				cust.SSNClear									AS SSN,
				con.SalesRep									AS salesrep,
				cust.TaxID										AS TaxID,
				sc.ChannelDescription							AS ChannelPartnerName,
				''												AS ContractTypeDescp

			FROM LibertyPower..Account					a WITH (NOLOCK)
			JOIN LibertyPower..[Contract]				con WITH (NOLOCK)	ON a.CurrentRenewalContractID = con.ContractID AND con.ContractDealTypeID = 2
			JOIN LibertyPower..AccountContract			ac WITH (NOLOCK)	ON ac.ContractID = con.ContractID AND ac.AccountID = a.AccountID
			JOIN LibertyPower..AccountContractRate		acr WITH (NOLOCK)	ON acr.AccountContractID = ac.AccountContractID
			JOIN LibertyPower..SalesChannel				sc WITH (NOLOCK)	ON con.SalesChannelID = sc.ChannelID
			LEFT JOIN LibertyPower..Customer			cust WITH (NOLOCK)	ON a.CustomerID = cust.CustomerID
			LEFT JOIN LibertyPower..BusinessType		BT WITH (NOLOCK)	ON cust.BusinessTypeID = BT.BusinessTypeID  
			LEFT JOIN LibertyPower..BusinessActivity	BA WITH (NOLOCK)	ON cust.BusinessActivityID = BA.BusinessActivityID  
			LEFT JOIN lp_account..account_name			z WITH (NOLOCK)		ON z.AccountNameID = CUST.NameID
			LEFT JOIN lp_account..account_address		c WITH (NOLOCK)		ON c.AccountAddressID = a.BillingAddressID
			LEFT JOIN lp_account..account_contact		d WITH (NOLOCK)		ON d.AccountContactID = CUST.ContactID
			
			WHERE con.Number = @contract_number
			--GROUP BY z.full_name, BT.[Type], BA.Activity, d.first_name, d.last_name, d.title, d.phone,
			--		d.fax, d.email, d.birthday, con.ContractTypeID, con.ContractTemplateID, con.ContractDealTypeID, con.Number, c.address_link, [address],
			--		c.suite, c.city, c.county, c.[state], c.zip, acr.Term,
			--		cust.SSNClear, con.SalesRep, cust.TaxID, sc.ChannelName
			
			IF @@ROWCOUNT > 0 
				GOTO FINAL
				
		END -- GET DATA FROM ACCOUNT RENEWAL TABLES 


	-- Check Contract Renewal Deal Contract Accounts
	-- ========================================================
	IF EXISTS(	select 1
				from lp_contract_renewal..deal_contract_account a  WITH (NOLOCK) 
				where a.contract_nbr =  @contract_number	)
				
		BEGIN 
			-- Get data from Contract Renewal 
			INSERT INTO #addressInfo
			SELECT DISTINCT
				rtrim(z.full_name)				AS CustomerName
				,rtrim(a.business_type)			AS BusinessType
				,rtrim(a.business_activity)		AS BusinessActivity
				                      
				,rtrim(d.first_name)			AS ContactFirstName
				,rtrim(d.last_name)				AS ContactLastName
				,rtrim(d.title)					AS ContactTitle
				,rtrim(d.phone)					AS ContactPhone
				,rtrim(d.fax)					AS ContactFax		                      
				,rtrim(d.email)					AS ContactEmail
				,rtrim(d.birthday)				AS ContactBirthday

				,rtrim(a.contract_type)			AS ContractType
				,rtrim(a.contract_nbr)			AS ContractNumber
				--,rtrim(a.term_months)			AS Term
				--,rtrim(dbo.ufn_convert_number_to_words(a.term_months))			AS TermInWords
				
				,a.billing_address_link			AS BillingAddressLink
				,rtrim(c.address)				AS BillingAddress1
				,rtrim(c.suite)					AS BillingAddress2
				,rtrim(c.city)					AS BillingCity
				,rtrim(c.county)				AS BillingCounty
				,rtrim(c.state)					AS BillingState
				,rtrim(c.zip)					AS BillingZip

				,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))
												AS SSN
				,max(sales_rep)					AS salesrep
				--,case when a.term_months = 0 then '' else  a.term_months end 
				,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))
												AS TaxID
				,max(s.ChannelDescription)		AS ChannelPartnerName
				,''								AS ContractTypeDescp

			FROM lp_contract_renewal..deal_contract_account			a WITH (NOLOCK)
			LEFT JOIN libertypower..saleschannel					s WITH (NOLOCK)		ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName
			LEFT JOIN lp_contract_renewal..deal_account_name		z WITH (NOLOCK)		ON z.account_id = a.account_id AND z.name_link = a.customer_name_link 
			LEFT JOIN lp_contract_renewal..deal_account_address		c WITH (NOLOCK)		ON c.account_id = a.account_id AND c.address_link = a.billing_address_link 		
			LEFT JOIN lp_contract_renewal..deal_account_contact		d WITH (NOLOCK)		ON d.account_id = a.account_id AND d.contact_link = a.customer_contact_link

			WHERE a.contract_nbr = @contract_number
			GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone
					, d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]
					, c.suite , c.city , c.county , c.[state] , c.zip  , a.term_months
			
			IF @@ROWCOUNT > 0 
				GOTO FINAL	
		END -- Get data from Contract Renewal 

	-- Check Contract Renewal Deal Contract 
	-- ========================================================
	IF EXISTS(	select 1
				from lp_contract_renewal..deal_contract a  WITH (NOLOCK) 
				where a.contract_nbr =  @contract_number	)
		BEGIN
			-- Get data from Contract Renewal 
			INSERT INTO #addressInfo
			SELECT DISTINCT 
				rtrim(z.full_name)				AS CustomerName
				,rtrim(a.business_type)			AS BusinessType
				,rtrim(a.business_activity)		AS BusinessActivity
				                      
				,rtrim(d.first_name)			AS ContactFirstName
				,rtrim(d.last_name)				AS ContactLastName
				,rtrim(d.title)					AS ContactTitle
				,rtrim(d.phone)					AS ContactPhone
				,rtrim(d.fax)					AS ContactFax		                      
				,rtrim(d.email)					AS ContactEmail
				,rtrim(d.birthday)				AS ContactBirthday

				,rtrim(a.contract_type)			AS ContractType 
				,rtrim(a.contract_nbr)			AS ContractNumber	                      
				--,rtrim(a.term_months)			AS Term, 
				--,rtrim(dbo.ufn_convert_number_to_words(a.term_months))			AS TermInWords,
				
				,a.billing_address_link			AS BillingAddressLink
				,rtrim(c.address)				AS BillingAddress1
				,rtrim(c.suite)					AS BillingAddress2
				,rtrim(c.city)					AS BillingCity
				,rtrim(c.county)				AS BillingCounty
				,rtrim(c.state)					AS BillingState
				,rtrim(c.zip)					AS BillingZip
				
				,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))
												AS SSN
				,max(sales_rep)					AS salesrep
				--,case when a.term_months = 0 then '' else  a.term_months end 
				,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))
												AS TaxID
				,max(s.ChannelDescription)		AS ChannelPartnerName
				,''								AS ContractTypeDescp

			FROM lp_contract_renewal..deal_contract					a WITH (NOLOCK)
			LEFT JOIN libertypower..saleschannel					s WITH (NOLOCK)		ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName
			LEFT OUTER JOIN lp_contract_renewal..deal_name			z WITH (NOLOCK)		ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link 
			LEFT OUTER JOIN lp_contract_renewal..deal_address		c WITH (NOLOCK)		ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link 		
			LEFT OUTER JOIN lp_contract_renewal..deal_contact		d WITH (NOLOCK)		ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link
			
			WHERE a.contract_nbr = @contract_number
			GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone
					, d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]
					, c.suite , c.city , c.county , c.[state] , c.zip  , a.term_months
			
			IF @@ROWCOUNT > 0 
				GOTO FINAL			
		END -- Get data from Contract Renewal 


	-- Get data from Account table
	-- ===========================================================
	IF EXISTS(	select 1
				from lp_account..account a  WITH (NOLOCK) 
				where a.contract_nbr =  @contract_number	) 
		BEGIN 

			INSERT INTO #addressInfo
			SELECT DISTINCT
				rtrim(z.full_name)				AS CustomerName, 
				rtrim(a.business_type)			AS BusinessType, 
				rtrim(a.business_activity)		AS BusinessActivity, 
				                      
				rtrim(d.first_name)				AS ContactFirstName, 
				rtrim(d.last_name)				AS ContactLastName, 
				rtrim(d.title)					AS ContactTitle, 
				rtrim(d.phone)					AS ContactPhone, 
				rtrim(d.fax)					AS ContactFax, 		                      
				rtrim(d.email)					AS ContactEmail, 
				rtrim(d.birthday)				AS ContactBirthday, 

				rtrim(a.contract_type)			AS ContractType, 
				rtrim(a.contract_nbr)			AS ContractNumber, 		                      
				--rtrim(a.term_months)			AS Term, 
				--rtrim(dbo.ufn_convert_number_to_words(a.term_months))			AS TermInWords,

				a.billing_address_link			AS BillingAddressLink,
				rtrim(c.address)				AS BillingAddress1, 
				rtrim(c.suite)					AS BillingAddress2, 
				rtrim(c.city)					AS BillingCity, 
				rtrim(c.county)					AS BillingCounty, 		                   
				rtrim(c.state)					AS BillingState, 
				rtrim(c.zip)					AS BillingZip
				
				,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))
												AS  SSN
				,max(sales_rep)					AS salesrep
				--,case when a.term_months = 0 then '' else  a.term_months end 
				,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))
												AS TaxID
				,max(s.ChannelDescription)		AS ChannelPartnerName
				,''								AS ContractTypeDescp
			FROM lp_account..account					a WITH (NOLOCK)
			LEFT JOIN libertypower..saleschannel		s WITH (NOLOCK)		ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName
			LEFT JOIN lp_account..account_name			z WITH (NOLOCK)		ON z.account_id = a.account_id AND z.name_link = a.customer_name_link 
			LEFT JOIN lp_account..account_address		c WITH (NOLOCK)		ON c.account_id = a.account_id AND c.address_link = a.billing_address_link 		
			LEFT JOIN lp_account..account_contact		d WITH (NOLOCK)		ON d.account_id = a.account_id AND d.contact_link = a.customer_contact_link

			WHERE a.contract_nbr = @contract_number
			GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone
					, d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]
					, c.suite , c.city , c.county , c.[state] , c.zip , a.term_months
			
			IF @@ROWCOUNT > 0 
			GOTO FINAL
		END -- get data from accounts

	-- Check new Contract tables 
	-- ========================================================
	IF EXISTS(	select 1
				from lp_deal_capture..deal_contract_account a  WITH (NOLOCK) 
				where a.contract_nbr =  @contract_number	)
		BEGIN
			-- Get data from new Contract 
			INSERT INTO #addressInfo
			SELECT DISTINCT 
				rtrim(z.full_name)				AS CustomerName, 
				rtrim(a.business_type)			AS BusinessType, 
				rtrim(a.business_activity)		AS BusinessActivity, 

				rtrim(d.first_name)				AS ContactFirstName, 
				rtrim(d.last_name)				AS ContactLastName, 
				rtrim(d.title)					AS ContactTitle, 
				rtrim(d.phone)					AS ContactPhone, 
				rtrim(d.fax)					AS ContactFax, 		                      
				rtrim(d.email)					AS ContactEmail, 
				rtrim(d.birthday)				AS ContactBirthday, 

				rtrim(a.contract_type)			AS ContractType, 
				rtrim(a.contract_nbr)			AS ContractNumber, 		                      
				--rtrim(a.term_months)			AS Term, 
				--rtrim(dbo.ufn_convert_number_to_words(a.term_months))			AS TermInWords,

				a.billing_address_link			AS BillingAddressLink,
				rtrim(c.address)				AS BillingAddress1, 
				rtrim(c.suite)					AS BillingAddress2, 
				rtrim(c.city)					AS BillingCity, 
				rtrim(c.county)					AS BillingCounty, 		                   
				rtrim(c.state)					AS BillingState, 
				rtrim(c.zip)					AS BillingZip

				,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))
												AS SSN
				,max(sales_rep)					AS salesrep
				--,case when a.term_months = 0 then '' else  a.term_months end 
				,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))
												AS TaxID
				,max(s.ChannelDescription)		AS ChannelPartnerName
				,''								AS ContractTypeDescp

			FROM lp_deal_capture..deal_contract_account			a WITH (NOLOCK) 
			LEFT JOIN libertypower..saleschannel				s WITH (NOLOCK)		ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName
			LEFT JOIN lp_deal_capture..deal_name				z WITH (NOLOCK)		ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link 
			LEFT JOIN lp_deal_capture..deal_address				c WITH (NOLOCK)		ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link 		
			LEFT JOIN lp_deal_capture..deal_contact				d WITH (NOLOCK)		ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link

			WHERE a.contract_nbr = @contract_number
			GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone
					, d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]
					, c.suite , c.city , c.county , c.[state] , c.zip , a.term_months

			IF @@ROWCOUNT > 0 
				GOTO FINAL
		END -- Get data from new Contract  


	-- Check new Contract tables 
	-- ========================================================
	IF EXISTS(	select 1
				from lp_deal_capture..deal_contract a  WITH (NOLOCK) 
				where a.contract_nbr =  @contract_number	)
		BEGIN 
			-- Get data from new Contract 

			INSERT INTO #addressInfo
			SELECT DISTINCT
				rtrim(z.full_name)				AS CustomerName, 
				rtrim(a.business_type)			AS BusinessType, 
				rtrim(a.business_activity)		AS BusinessActivity, 

				rtrim(d.first_name)				AS ContactFirstName, 
				rtrim(d.last_name)				AS ContactLastName, 
				rtrim(d.title)					AS ContactTitle, 
				rtrim(d.phone)					AS ContactPhone, 
				rtrim(d.fax)					AS ContactFax, 		                      
				rtrim(d.email)					AS ContactEmail, 
				rtrim(d.birthday)				AS ContactBirthday, 

				rtrim(a.contract_type)			AS ContractType, 
				rtrim(a.contract_nbr)			AS ContractNumber, 		                      
				--rtrim(a.term_months)			AS Term, 
				--rtrim(dbo.ufn_convert_number_to_words(a.term_months))			AS TermInWords,

				a.billing_address_link			AS BillingAddressLink,
				rtrim(c.address)				AS BillingAddress1, 
				rtrim(c.suite)					AS BillingAddress2, 
				rtrim(c.city)					AS BillingCity, 
				rtrim(c.county)					AS BillingCounty, 		                   
				rtrim(c.state)					AS BillingState, 
				rtrim(c.zip)					AS BillingZip

				,max(rtrim(case when additional_id_nbr_type = 'SSN' then additional_id_nbr else '' end ))
												AS SSN
				,max(sales_rep)					AS salesrep
				--,case when a.term_months = 0 then '' else  a.term_months end 
				,max(rtrim(case when additional_id_nbr_type = 'TAX ID' then additional_id_nbr else '' end ))
												AS TaxID
				,max(s.ChannelDescription)		AS ChannelPartnerName
				,''								AS ContractTypeDescp

			FROM lp_deal_capture..deal_contract				a WITH (NOLOCK)
			LEFT JOIN libertypower..saleschannel			s WITH (NOLOCK)		ON replace(a.sales_channel_role, 'sales channel/','') = s.ChannelName
			LEFT JOIN lp_deal_capture..deal_name			z WITH (NOLOCK)		ON z.contract_nbr = a.contract_nbr AND z.name_link = a.customer_name_link 
			LEFT JOIN lp_deal_capture..deal_address			c WITH (NOLOCK)		ON c.contract_nbr = a.contract_nbr AND c.address_link = a.billing_address_link 		
			LEFT JOIN lp_deal_capture..deal_contact			d WITH (NOLOCK)		ON d.contract_nbr = a.contract_nbr AND d.contact_link = a.customer_contact_link

			WHERE a.contract_nbr = @contract_number
			GROUP BY z.full_name, a.business_type, a.business_activity, d.first_name , d.last_name , d.title , d.phone
					, d.fax , d.email , d.birthday , a.contract_type , a.contract_nbr , a.billing_address_link, c.[address]
					, c.suite , c.city , c.county , c.[state] , c.zip , a.term_months

			IF @@ROWCOUNT > 0 
				GOTO FINAL			
		END -- Get data from new Contract  

		-- no need to check lp_deal_capture..deal_contract_print and lp_deal_capture..muti_rates because 
		-- no address info can be obtained from joining on these tables

DummyRow:
		-- If nothing else works return blank row
		-- =======================================
		BEGIN
			--new deal
			-- Return mostly blanks
			INSERT INTO #addressInfo
			SELECT TOP 1
				'' 									AS CustomerName, 
				'' 									AS BusinessType, 
				'' 									AS BusinessActivity, 
				   									                   
				'' 									AS ContactFirstName, 
				'' 									AS ContactLastName, 
				'' 									AS ContactTitle, 
				'' 									AS ContactPhone, 
				'' 									AS ContactFax, 		                      
				'' 									AS ContactEmail, 
				'' 									AS ContactBirthday, 

				'' 									AS ContractType, 
				@contract_number					AS ContractNumber, 		                      
				--'' AS Term,
				--'' AS TermInWords, 
				
				0  									AS BillingAddressLink,
				'' 									AS BillingAddress1, 
				'' 									AS BillingAddress2, 
				'' 									AS BillingCity, 
				'' 									AS BillingCounty, 		                   
				'' 									AS BillingState, 
				'' 									AS BillingZip
				,''									AS SSN
				,''									AS SalesRep 
				--,'' as Term -- Do Not Use term Here. All Term fields in template will use this value !!!
				, ''								AS TAXID
--				, ''			AS ChannelPartnerName 
				,s.ChannelDescription				AS ChannelPartnerName
				, ''								AS ContractTypeDescp
			FROM lp_deal_capture..deal_contract_print		a WITH (NOLOCK) 
			LEFT JOIN libertypower..saleschannel			s WITH (NOLOCK)		ON replace(a.sales_channel_role, 'sales channel/','') = s.channelname
			WHERE a.contract_nbr = @contract_number

			IF @@ROWCOUNT > 0 
				GOTO FINAL

		END  -- return blanks 

FINAL:
	UPDATE #addressInfo SET 
		CustomerName =		case when ltrim(rtrim(CustomerName))		= 'NONE' then '' else CustomerName end 
		,BusinessType =		case when ltrim(rtrim(BusinessType))		= 'NONE' then '' else BusinessType end 
		,BusinessActivity =	case when ltrim(rtrim(BusinessActivity))	= 'NONE' then '' else BusinessActivity end  
		,ContactFirstName =	case when ltrim(rtrim(ContactFirstName))	= 'NONE' then '' else ContactFirstName end 
		,ContactLastName =	case when ltrim(rtrim(ContactLastName))		= 'NONE' then '' else ContactLastName end 
		,ContactTitle =		case when ltrim(rtrim(ContactTitle))		= 'NONE' then '' else ContactTitle end 
		,ContactPhone =		case when ltrim(rtrim(ContactPhone))		= 'NONE' then '' else ContactPhone end 
		,ContactFax =		case when ltrim(rtrim(ContactFax))			= 'NONE' then '' else ContactFax end 		                      
		,ContactEmail =		case when ltrim(rtrim(ContactEmail))		= 'NONE' then '' else ContactEmail end 
		,ContactBirthday =	case when ltrim(rtrim(ContactBirthday))		= 'NONE' then '' else ContactBirthday end 
		,ContractTypeDescp = ContractType
		,ContractType =		case when ltrim(rtrim(ContractType)) = 'NONE' then ''
								when ContractType like '%renew%' then 'RENEWAL'
								when ContractType like '%Paper%' then 'NEW'
								else ContractType
							end
		--,@contract_number			AS ContractNumber, 		                      
		--,Term = case when (ltrim(rtrim(Term)) = 'NONE' then '' else Term end 
		--,TermInWords = case when ltrim(rtrim(TermInWords)) = 'NONE' then '' else TermInWords end 
		--,BillingAddressLink = case when (ltrim(rtrim(CustomerName)) = 'NONE' then '' else CustomerName end 
		,BillingAddress1 =	case when ltrim(rtrim(BillingAddress1))		= 'NONE' then '' else BillingAddress1 end 
		,BillingAddress2 =	case when ltrim(rtrim(BillingAddress2))		= 'NONE' then '' else BillingAddress2 end 
		,BillingCity =		case when ltrim(rtrim(BillingCity))			= 'NONE' then '' else BillingCity end 
		,BillingCounty =	case when ltrim(rtrim(BillingCounty))		= 'NONE' then '' else BillingCounty end 
		,BillingState =		case when ltrim(rtrim(BillingState))		= 'NONE' then '' else BillingState end 
		,BillingZip =		case when ltrim(rtrim(BillingZip))			= 'NONE' then '' else BillingZip end 


----------------Return Data
	SELECT TOP 1
		*,
		CONVERT(VARCHAR(10), GETDATE(), 101)					as 'GeneratedDate',
		CONVERT(VARCHAR(10), DateAdd(DAY, 14, getdate()), 101)	as 'ContactDate'
	FROM #addressInfo
	
	ORDER BY 1 DESC

END


GO
