-- =============================================
-- Author:		Rick Deigsler
-- Create date: 10/3/2007
-- Description:	
-- =============================================
-- Author:		Thiago Nogueira
-- Create date: 24/3/2011
-- Description:	Added check_account test
-- =============================================
CREATE PROCEDURE [dbo].[usp_contract_exists]

@p_contract_nbr_bogus				char(12),
@p_contract_nbr_amend				char(12)

AS

DECLARE @w_application									varchar(20),
		@w_error										char(01),
		@w_msg_id										char(08),
		@w_descp										varchar(250),
		@w_return										int

SELECT	@w_application									= 'DEAL'
SELECT	@w_error										= 'I'
SELECT	@w_msg_id										= '00000001'
SELECT	@w_descp										= ' '
SELECT	@w_return										= 0

-- make sure contract number to amend exists as either a new deal or renewal
IF NOT EXISTS (	SELECT	NULL
				FROM	lp_account..account a WITH (NOLOCK)
				WHERE	contract_nbr = @p_contract_nbr_amend )
AND NOT EXISTS(	SELECT	NULL
				FROM	lp_account..account_renewal a WITH (NOLOCK)
				WHERE	contract_nbr = @p_contract_nbr_amend )
	BEGIN
      SELECT	@w_application                         = 'DEAL'
      SELECT	@w_error                               = 'E'
      SELECT	@w_msg_id                              = '00000049'
      SELECT	@w_return                              = 1
      GOTO		GOTO_SELECT
	END

-- make sure bogus contract number does not exist
IF EXISTS (	SELECT	NULL
				FROM	lp_account..account a WITH (NOLOCK)
				WHERE	contract_nbr = @p_contract_nbr_bogus )
OR EXISTS (	SELECT	NULL
				FROM	lp_account..account_renewal a WITH (NOLOCK)
				WHERE	contract_nbr = @p_contract_nbr_bogus )
	BEGIN
      SELECT	@w_application                         = 'DEAL'
      SELECT	@w_error                               = 'E'
      SELECT	@w_msg_id                              = '00000050'
      SELECT	@w_return                              = 1
      GOTO		GOTO_SELECT
	END

-- make sure at least one account in contract number to amend is enrolled
IF NOT EXISTS (	SELECT	NULL
				FROM	lp_account..account a WITH (NOLOCK)
				WHERE	contract_nbr = @p_contract_nbr_amend
				AND		status IN ('01000','03000','04000','05000','06000','07000','08000','10000','905000','906000') )
	BEGIN
      SELECT	@w_application                         = 'DEAL'
      SELECT	@w_error                               = 'E'
      SELECT	@w_msg_id                              = '00000051'
      SELECT	@w_return                              = 1
      GOTO		GOTO_SELECT
	END


-- make sure bogus contract number is not submitted
IF EXISTS (	SELECT	NULL
				FROM	lp_enrollment..check_account c WITH (NOLOCK)
				WHERE	contract_nbr = @p_contract_nbr_bogus )
	BEGIN
      SELECT	@w_application                         = 'DEAL'
      SELECT	@w_error                               = 'E'
      SELECT	@w_msg_id                              = '00000010'
      SELECT	@w_return                              = 1
      GOTO		GOTO_SELECT
	END

GOTO_SELECT:
IF @w_error												<> 'N'
	BEGIN
	   EXEC		lp_common..usp_messages_sel @w_msg_id, @w_descp OUTPUT, @w_application
	   SELECT	@w_descp = LTRIM(RTRIM(@w_descp))
	END

SELECT	flag_error										= @w_error,
		code_error										= @w_msg_id,
		message_error									= @w_descp

