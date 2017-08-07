









/*
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- Clear code (remove prINT AND put SET notcount)
-- Put WITH (NOLOCK) in the SELECT querys
-- Verify the powermove information FROM EDI transaction
-- Add new column in the query
-- =======================================

--SELECT * FROM deal_contract_batch (NOLOCK)
--exec usp_contract_submit_batch_ins 'libertypower\dmarino', 'SALES CHANNEL-2006061214:32:27  :140'
*/

CREATE procedure [dbo].[usp_contract_submit_batch_ins]
		(@p_username								NCHAR(100),
		@p_request_id								VARCHAR(50))
AS

SET NOCOUNT ON

DECLARE @w_error								CHAR(01)
	,@w_msg_id									CHAR(08)
	,@w_return									INT
	,@w_descp_add								VARCHAR(100)
	,@w_status									VARCHAR(15)
	,@w_contract_nbr							CHAR(12)
	,@w_contract_type							VARCHAR(25)
	,@w_rowcount								INT
	,@w_request_id								VARCHAR(100)
	,@w_exec_sql								VARCHAR(max)
	,@w_dbname									NVARCHAR(128)
	,@w_server_name								VARCHAR(128)
	,@w_job_name								VARCHAR(128)
	,@w_dateexec								DATETIME
	,@w_date_start								DATETIME
	,@w_application								VARCHAR(20)


SELECT @w_application							= 'COMMON'

SET ROWCOUNT 1

SELECT @w_contract_nbr							= contract_nbr,
		@w_contract_type						= contract_type
FROM deal_contract_batch WITH (NOLOCK INDEX = deal_contract_batch_idx)
WHERE request_id								= @p_request_id

SET @w_rowcount									= @@ROWCOUNT

WHILE @w_rowcount								<> 0
BEGIN
	SET ROWCOUNT 0

	/* validacion del contrato */
	
	EXEC @w_return = usp_contract_submit @p_username,
											'BATCH',
											@w_contract_nbr,
											@w_contract_type
	
	IF @w_return									<> 0
	BEGIN
		SELECT @w_application					= 'COMMON'
			,@w_error							= 'E'
			,@w_msg_id							= '00000051'
			,@w_return							= 1
			,@w_descp_add						= ' (Submit Validation Deal Contract) '

		EXEC usp_contract_error_ins 'DEAL_CAPTURE',
								  @w_contract_nbr,
								  'ENROLL SALES',
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add
	END

	SELECT @w_status							= [status]
	FROM lp_deal_capture..deal_contract WITH (NOLOCK INDEX = deal_contract_idx)
	WHERE contract_nbr								= @w_contract_nbr

	SET @w_date_start								= GETDATE()
 
	WHILE @w_status									= 'RUNNING'
	BEGIN
	  SELECT @w_status								= [status]
	  FROM lp_deal_capture..deal_contract WITH (NOLOCK INDEX = deal_contract_idx)
	  WHERE contract_nbr							= @w_contract_nbr

	  IF DATEDIFF(mi, @w_date_start, GETDATE())	>= 2
	  BEGIN
		 SELECT @w_status							= ' '
	  END
	END
	
	SET ROWCOUNT 1

	DELETE deal_contract_batch
	FROM deal_contract_batch WITH (NOLOCK INDEX = deal_contract_batch_idx)
	WHERE request_id								= @p_request_id
	and	contract_nbr								= @w_contract_nbr

	SELECT @w_contract_nbr							= contract_nbr
	FROM deal_contract_batch WITH (NOLOCK INDEX = deal_contract_batch_idx)
	WHERE request_id								= @p_request_id

	SET @w_rowcount									= @@ROWCOUNT

END

SET ROWCOUNT 0

SET @w_return										= 0

SET NOCOUNT OFF

RETURN @w_return
