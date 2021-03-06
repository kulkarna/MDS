USE [integration]
GO
/****** Object:  StoredProcedure [dbo].[usp_lp_transaction_mapping_upd]    Script Date: 11/04/2013 15:01:21 ******/
/*********************************************************
 11/06/2013 - Sal Tenorio
 PBI 15029
 Update wholesale_market_id as well
*********************************************************/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_lp_transaction_mapping_upd] 
( @lp_transaction_mapping_id int
, @lp_transaction_id int = null
, @lp_reasoncode varchar(100) = null
, @market_id int = null
, @utility_id int = null
, @external_transaction_type varchar(10) = null
, @external_action_code varchar(10) = null
, @external_request_or_response varchar(10) = null
, @external_reject_or_accept varchar(10) = null
, @external_reasoncode varchar(100) = null
, @external_reasontext varchar(1000) = null
, @date_last_mod datetime = null
, @active tinyint = null
, @wholesale_market_id char(10) = null
)
AS
BEGIN

SET NOCOUNT ON;

	UPDATE lp_transaction_mapping
	SET 
	lp_transaction_id = isnull(@lp_transaction_id,lp_transaction_id),
	lp_reasoncode = isnull(@lp_reasoncode,lp_reasoncode),
	wholesale_market_id = isnull(@wholesale_market_id, wholesale_market_id),
	market_id = isnull(@market_id,market_id),
	utility_id = isnull(@utility_id,utility_id),
	external_transaction_type = isnull(@external_transaction_type,external_transaction_type),
	external_action_code = isnull(@external_action_code,external_action_code),
	external_request_or_response = isnull(@external_request_or_response,external_request_or_response),
	external_reject_or_accept = isnull(@external_reject_or_accept,external_reject_or_accept),
	external_reasoncode = isnull(@external_reasoncode,external_reasoncode),
	external_reasontext = isnull(@external_reasontext,external_reasontext),
	date_last_mod = getdate(),
	active = isnull(@active,active)
	WHERE lp_transaction_mapping_id = @lp_transaction_mapping_id

	EXEC usp_process_mapped_EDI @market_id, @utility_id , @external_transaction_type, @external_action_code, @external_request_or_response, @external_reject_or_accept, @external_reasoncode, @external_reasontext 
	
	SET NOCOUNT OFF;
END

