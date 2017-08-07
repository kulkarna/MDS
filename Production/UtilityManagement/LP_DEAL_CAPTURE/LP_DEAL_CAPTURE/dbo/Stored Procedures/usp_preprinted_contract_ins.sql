-- =============================================
-- Author:		Rick Deigsler
-- Create date: 10/22/2007
-- Description:	Insert multiple pre-printed contracts
-- =============================================
CREATE PROCEDURE [dbo].[usp_preprinted_contract_ins]

@p_username				varchar(100),
@p_retail_mkt_id		char(2),
@p_contract_nbr_from	int,
@p_contract_nbr_to		int,
@p_return_msg			varchar(100)	= ''	OUTPUT

AS

DECLARE	@w_contract_nbr			int,
		@w_request_id			varchar(20),
		@w_contract_nbr_prefix	varchar(20)

SET		@w_contract_nbr	= @p_contract_nbr_from
SET		@w_contract_nbr_prefix	=	UPPER(@p_retail_mkt_id + CAST(RIGHT(DATEPART(yy, GETDATE()), 2) AS varchar(2)) + '-'
									+ substring(@p_username, 15, len(@p_username) - 14))

-- check if any contract numbers exist before starting insert
WHILE @w_contract_nbr <= @p_contract_nbr_to
	BEGIN
		IF EXISTS (	SELECT	NULL
					FROM	deal_contract_print
					WHERE contract_nbr = (@w_contract_nbr_prefix + RIGHT('0000000' + CAST(@w_contract_nbr AS varchar(4)), 4))
				   )
			BEGIN
				SET		@p_return_msg = 'One or more contract numbers exist for Sales Channel and Market.'
				RETURN
			END

		SET @w_contract_nbr = @w_contract_nbr + 1
	END

-- reset contract number
SET		@w_contract_nbr = @p_contract_nbr_from

-- proceed with insert
WHILE @w_contract_nbr <= @p_contract_nbr_to
	BEGIN
		EXEC	usp_get_key @p_username, 'PRINT CONTRACTS', @w_request_id OUTPUT

		INSERT INTO deal_contract_print
					(request_id, status, contract_nbr, username, retail_mkt_id, puc_certification_number, 
					utility_id, product_id, rate_id, rate, rate_descp, term_months, contract_eff_start_date, 
					grace_period, date_created, contract_template) 
		VALUES		(@w_request_id, 'COMPLETED', @w_contract_nbr_prefix + RIGHT('0000000' + CAST(@w_contract_nbr AS varchar(4)), 4), @p_username, 
					@p_retail_mkt_id, '', '', '', 0, 0, '', 0, GETDATE(), 0, GETDATE(), '')

		SET @w_contract_nbr = @w_contract_nbr + 1
	END

SET	@p_return_msg = 'Contract numbers successfully added.'

