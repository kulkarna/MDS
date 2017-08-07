--exec usp_contract_submit_ins 'libertypower\dmarino', 'Contracto A1'
--usp_contract_submit 'libertypower\dmarino', 'ONLINE', 'A1'
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- Clear code (remove print AND put SET nocount)
-- Put WITH (NOLOCK) in the SELECT querys
-- Verify the powermove information FROM EDI transaction
-- =======================================

CREATE procedure [dbo].[usp_contract_submit]
		(@p_username							NCHAR(100),
		@p_process								VARCHAR(15),
		@p_contract_nbr							CHAR(12),
		@p_contract_type						VARCHAR(25) = ' ')
AS

SET NOCOUNT ON

DECLARE @w_error								CHAR(01)
	,@w_msg_id									CHAR(08)
	,@w_return									INT
	,@w_descp									VARCHAR(255)
	,@w_descp_add								VARCHAR(100)
	,@w_request_id								CHAR(50)
	,@w_exec_sql								VARCHAR(max)
	,@w_dbname									NVARCHAR(128)
	,@w_server_name								VARCHAR(128)
	,@w_job_name								VARCHAR(128)
	,@w_dateexec								DATETIME
	,@w_application								VARCHAR(20)
	
SELECT @w_error									= 'I'
	,@w_msg_id									= '00000001'
	,@w_return									= 0
	,@w_descp									= ' ' 
	,@w_descp_add								= ' ' 
	,@w_application								= 'COMMON'

UPDATE deal_contract SET status = 'RUNNING'
FROM deal_contract WITH (NOLOCK INDEX = deal_contract_idx)
WHERE contract_nbr								= @p_contract_nbr

IF (exists (SELECT origin
			FROM deal_contract WITH (NOLOCK INDEX = deal_contract_idx)
			WHERE contract_nbr					= @p_contract_nbr
			AND   origin						= 'BATCH')
AND @p_process									= 'ONLINE')
BEGIN

   DELETE deal_contract_error
   FROM deal_contract_error WITH (NOLOCK INDEX = deal_contract_error_idx)
   WHERE contract_nbr							= @p_contract_nbr

   SELECT @w_request_id							= 'DEAL_CAPTURE-VALIDATION-'
													+ LTRIM(RTRIM(@p_contract_nbr))
		,@w_dbname								= 'lp_deal_capture'
		,@w_server_name							= @@servername
		,@w_job_name							= @w_request_id

   SELECT @w_exec_sql							   = 'exec'
													+ ' '
													+ 'usp_contract_submit_val'
													+ ' '
													+ '''' + LTRIM(RTRIM(@p_username)) + ''''
													+ ', '
													+ '''' + LTRIM(RTRIM(@p_process)) + ''''
													+ ', '
													+ '''' + LTRIM(RTRIM(@p_contract_nbr)) + ''''
													+ ', '
													+ '''' + LTRIM(RTRIM(@p_contract_type)) + ''''
	
   EXEC @w_return = lp_common..usp_summit_job @p_username,
											  @w_request_id,
											  @w_exec_sql,
											  @w_dbname,
											  @w_server_name,
											  @w_job_name,
											  @w_dateexec,
											  @w_error OUTPUT,
											  @w_msg_id OUTPUT

	
END
ELSE
BEGIN
   DELETE deal_contract_error
   FROM deal_contract_error WITH (NOLOCK INDEX = deal_contract_error_idx)
   WHERE contract_nbr							   = @p_contract_nbr
	
   EXEC @w_return = usp_contract_submit_val @p_username,
											@p_process,
											@p_contract_nbr,
											@p_contract_type,
											@w_application OUTPUT,
											@w_error OUTPUT,
											@w_msg_id OUTPUT,
											@w_descp_add OUTPUT
											

   IF @p_process									= 'BATCH'
   BEGIN

	  IF @w_error								   = 'E'
	  BEGIN
		 UPDATE deal_contract SET status = 'DRAFT - ERROR'
		 FROM deal_contract WITH (NOLOCK INDEX = deal_contract_idx)
		 WHERE contract_nbr						= @p_contract_nbr
	  END
  
	  RETURN @w_return
   END
END

IF @w_error										 = 'E'
BEGIN
   UPDATE deal_contract SET status = 'DRAFT - ERROR'
   FROM deal_contract WITH (NOLOCK INDEX = deal_contract_idx)
   WHERE contract_nbr					= @p_contract_nbr
END

IF @w_error										<> 'N'
BEGIN
   EXEC lp_common..usp_messages_sel @w_msg_id,
									@w_descp OUTPUT,
									@w_application

   SELECT @w_descp								  = LTRIM(RTRIM(@w_descp ))
													+ ' '
													+ @w_descp_add
END
 
SELECT flag_error								= @w_error,
	   code_error								= @w_msg_id,
	   message_error							= @w_descp

SET NOCOUNT OFF

RETURN @w_return
