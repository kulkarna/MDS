
-- exec usp_print_contracts_ins 'admin', 'TX', 'AEPNO', 'BGE-FIXED-12', 3, 2, '20060403 - OO'
-- ================================================================
-- Modified 8/30/2007  G	ail Mangaroo
-- Removed selection of template from common_product_template
-- ================================================================
-- Modified 1/25/2008 Gail Mangaroo
-- Added contract_print_type parameter - indicates whether contract is single / multi or custom rate
-- ================================================================
-- Modified 3/20/2009
-- Added check for rate_id = 999999999 when validating product rate SD#7669
-- ================================================================
-- Modified 09/26/2011 - Ryan Russon
-- Added Added TemplateId and applied ApexSQL formatting
-- ================================================================
-- Modified 06/15/2012 - Ryan Russon
-- Added @SalesChannel param to populate new sales_channel_role field in lp_deal_capture..deal_contract_print
-- ================================================================
-- Modified 10/18/2012 - Vitor Carvalho
-- Added added case 
--@w_term_months = (CASE
--WHEN rate_id=999999999 THEN ''
--ELSE term_months
--END),
-- for ticket 1-33958532
-- ================================================================
-- Modified 11/01/2012 - Lev Rosenblum
-- Added RateString input parameter to update corresponding field into deal_contract_print table
-- ================================================================
-- Modified 11/27/2012 - Lev Rosenblum
-- Merged MD084 and the production version of stored procedure 
-- ================================================================
-- Modified 12/17/2012 - Lev Rosenblum
-- Add new input param to accomodate store data without rate and tier selection
-- ================================================================

CREATE PROCEDURE [dbo].[usp_print_contracts_ins](
	@p_username				nchar( 100 ),
	@p_retail_mkt_id		char( 02 ),
	@p_utility_id			char( 15 ),
	@p_product_id			char( 20 ),
	@p_rate_id				int,
	@p_qty					int,
	@p_request_id			varchar( 20 ),
	@p_error				char( 01 )		= ' ',
	@p_msg_id				char( 08 )		= ' ',
	@p_descp				varchar( 250 )	= ' ',
	@p_result_ind			char( 01 )		= 'Y',
	@p_contract_rate_type	varchar( 50 )	= '',
	@p_TemplateId			int,
	@Rate					decimal(12,5)	= 0,
	@ContractEffStartDate	datetime		= '01-01-1900',
	@PriceID				int				= 0, -- IT106
	@PriceTier				int				= 0,  -- IT106
	@SalesChannel			varchar( 50 ) = ''
	, @RateString				varchar(200)  = NULL
	, @TotalTerm					int=NULL
	, @SubTermString				varchar(50)=NULL
)
AS

DECLARE	@w_error char( 01 )
DECLARE	@w_msg_id char( 08 )
DECLARE	@w_descp varchar( 250 )
DECLARE	@w_return int

DECLARE	@w_descp_add varchar( 10 )
DECLARE	@w_application varchar( 20 )
DECLARE	@w_puc_certification_number varchar( 20 )
DECLARE	@w_start_contract int
DECLARE	@w_contract_nbr char( 12 )
DECLARE	@w_product_category char( 20 )
DECLARE	@w_term_months int


SELECT	@w_error = 'I'
SELECT	@w_msg_id = '00000001'
SELECT	@w_descp = ' '
SELECT	@w_return = 0
SELECT	@w_descp_add = ' '
SELECT	@w_application = 'COMMON'
SELECT	@w_product_category = ' '
SELECT	@w_term_months = 0


SELECT	@w_puc_certification_number = puc_certification_number
FROM lp_common..common_retail_market WITH ( NOLOCK 
--INDEX =common_retail_market_idx 
)
WHERE retail_mkt_id = @p_retail_mkt_id

SELECT	@w_product_category = product_category
FROM lp_common..common_product WITH ( NOLOCK INDEX =
common_product_idx )
WHERE product_id = @p_product_id
AND inactive_ind = '0'

IF @@rowcount = 0
AND @p_contract_rate_type <> 'CUSTOM'
	BEGIN
		SELECT @w_descp_add = '(Product)'
		GOTO create_error
	END
IF @p_qty <= 0
	BEGIN
		SELECT @w_descp_add = '(Quantity)'
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
	
	 @w_term_months = (CASE
        WHEN rate_id=999999999 THEN 0
        ELSE term_months
        END),
	@w_grace_period = grace_period
FROM lp_common..common_product_rate WITH ( NOLOCK 
--INDEX =common_product_rate_idx 
)
WHERE product_id = @p_product_id
  AND rate_id = @p_rate_id
  
IF @@rowcount = 0 AND @p_rate_id <> 999999999
	BEGIN
	print 'here'
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
			contract_rate_type, --, include_meter_charge) 
			TemplateId,
			PriceID,
			PriceTier
			, sales_channel_role
			, RateString
			, SubTermString)
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
			@Rate,
			@w_rate_descp,
			Case WHEN @TotalTerm is NULL THEN @w_term_months ELSE @TotalTerm END,
			@ContractEffStartDate,
			@w_grace_period,
			GETDATE(),
			@w_contract_template,
			@p_contract_rate_type,
			@p_TemplateId,
			@PriceID,
			@PriceTier
			, @SalesChannel
			, @RateString
			, @SubTermString

		IF @@error <> 0 OR @@rowcount = 0
			BEGIN
				GOTO create_error
			END
		
		SELECT @w_start_contract = @w_start_contract + 1
	END

SELECT	@w_return = 0

UPDATE deal_contract_print
SET status = 'COMPLETED'
WHERE request_id = @p_request_id
GOTO selector

create_error:
SELECT	@w_application = 'DEAL'
SELECT	@w_error = 'E'
SELECT	@w_msg_id = '00000001'
SELECT	@w_return = 1

selector:

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
		GOTO exitProc
	END

SELECT
	@p_error = @w_error,
	@p_msg_id = @w_msg_id,
	@p_descp = @w_descp

exitProc:
	RETURN @w_return

