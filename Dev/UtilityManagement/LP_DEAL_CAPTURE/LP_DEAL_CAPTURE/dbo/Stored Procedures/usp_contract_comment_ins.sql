-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/11/2007
-- Description:	Insert comment for contract
-- =============================================
CREATE PROCEDURE [dbo].[usp_contract_comment_ins]

@p_username                                        nchar(100),
@p_contract_nbr                                    char(12) = 'NONE',
@p_date_comment                                    datetime = null,
@p_process_id                                      varchar(20) = 'DEAL CAPTURE',
@p_comment                                         varchar(max),
@p_error                                           char(01) = ' ' output,
@p_msg_id                                          char(08) = ' ' output,
@p_descp                                           varchar(250) = ' ' output,
@p_result_ind                                      char(01) = 'Y'

AS

IF @p_date_comment IS NULL SELECT  @p_date_comment = GETDATE()

DECLARE	@w_error                                    char(01),
		@w_msg_id                                   char(08),
		@w_descp                                    varchar(250),
		@w_return                                   int
 
SELECT	@w_error                                     = 'I'
SELECT	@w_msg_id                                    = '00000001'
SELECT	@w_descp                                     = ' '
SELECT	@w_return                                    = 0

IF NOT EXISTS (	SELECT	contract_nbr
				FROM	deal_contract_comment
				WHERE	 @p_contract_nbr = contract_nbr )
	BEGIN
		INSERT INTO	deal_contract_comment
		SELECT		@p_contract_nbr, @p_date_comment, @p_process_id, @p_comment, @p_username, 0
	END
ELSE
	BEGIN
		UPDATE	deal_contract_comment
		SET		date_comment = @p_date_comment, process_id = @p_process_id, 
				comment = @p_comment, username = @p_username, chgstamp = (chgstamp + 1)
		WHERE	contract_nbr = @p_contract_nbr
	END

IF	@@error <> 0 OR	@@rowcount = 0
BEGIN
	SELECT @w_error                                  = 'E'
	SELECT @w_msg_id                                 = '00000002'
	SELECT @w_return                                 = 1
END
 
IF @w_error                                        <> 'N'
BEGIN
   exec lp_common..usp_messages_sel @w_msg_id, @w_descp output
END
 
IF @p_result_ind                                    = 'Y'
BEGIN
	SELECT	flag_error								= @w_error,
			code_error								= @w_msg_id,
			message_error							= @w_descp
	GOTO	goto_return
END
 
SELECT	@p_error									= @w_error,
		@p_msg_id									= @w_msg_id,
		@p_descp									= @w_descp
 
goto_return:
RETURN @w_return

