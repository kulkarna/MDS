USE [integration]
GO
/****** Object:  StoredProcedure [dbo].[usp_lp_transaction_mapping_ins]    Script Date: 11/04/2013 14:57:47 ******/

/**********************************************
11/06/2013 - Sal Tenorio
PBI 15029
Insert wholesale_market_id 
***********************************************/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_lp_transaction_mapping_ins] 
( @lp_transaction_id int
, @lp_reasoncode varchar(100) = null
, @market_id int
, @utility_id int
, @external_transaction_type varchar(10) = '*ALL*'
, @external_action_code varchar(10) = '*ALL*'
, @external_request_or_response varchar(10) = '*ALL*'
, @external_reject_or_accept varchar(10) = '*ALL*'
, @external_reasoncode varchar(100) = '*ALL*'
, @external_reasontext varchar(1000) = '*ALL*'
, @active tinyint
, @process_at_once tinyint = 0
, @wholesale_market_id char(10) = null
)
AS
BEGIN
SET NOCOUNT ON;

	IF @external_reasoncode is null
		SET @external_reasoncode = '*ALL*'
	IF @external_reasontext is null
		SET @external_reasontext = '*ALL*'
		
	INSERT INTO lp_transaction_mapping 
	(lp_transaction_id , lp_reasoncode , wholesale_market_id, market_id, utility_id , external_transaction_type , external_action_code , external_service_type2, external_request_or_response , external_reject_or_accept , external_reasoncode , external_reasontext , active) 
	VALUES 
	(@lp_transaction_id, @lp_reasoncode, @wholesale_market_id, @market_id, @utility_id, @external_transaction_type, @external_action_code, '*ALL*'               , @external_request_or_response, @external_reject_or_accept, @external_reasoncode, @external_reasontext, @active)
	
	IF (@process_at_once = 1)
	BEGIN
		DECLARE @lp_transaction_mapping_id int
		SET @lp_transaction_mapping_id = (select top 1 lp_transaction_mapping_id from lp_transaction_mapping order by date_created desc)
		EXEC usp_process_mapped_EDI_by_MapID @lp_transaction_mapping_id
		--EXEC usp_process_mapped_EDI @market_id, @utility_id , @external_transaction_type, @external_action_code, @external_request_or_response, @external_reject_or_accept, @external_reasoncode, @external_reasontext 
	END
	
	SET NOCOUNT OFF;
END
