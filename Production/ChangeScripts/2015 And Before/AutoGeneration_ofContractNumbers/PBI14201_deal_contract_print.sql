USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_print_contracts_empty_ins]    Script Date: 07/05/2013 15:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC usp_print_contracts_empty_ins 'libertypower\e3hernandez'
-- select * from lp_deal_capture..deal_contract_print order by date_created desc

-- =============================================
-- Author:		Eric Hernandez
-- Create date: 9/28/2009
-- Description:	Insert multiple rate contracts
-----------------------------------------------
--Revision:		Sara Lakshmanan
--Date: 7/8/2013
--Description:--Based on the discussion with Jaime and Eric we are now removing the code to insert records into deal_contract_print table
--Commented on July 8 2013-- 14201 cleanup and page refactoring on Deal Capture
--This fix is to able to autogenerate a contract number and then use it. Earlier it was working only for paper contracts
-- =============================================

ALTER PROCEDURE [dbo].[usp_print_contracts_empty_ins]
(@p_username NCHAR(100),
 @p_contract_nbr CHAR(12) = '' OUTPUT,
 @p_error CHAR(01) = ' ',
 @p_msg_id CHAR(08) = ' ',
 @p_descp VARCHAR(250) = ' ',
 @p_result_ind CHAR(01) = 'Y',
 @p_contract_rate_type VARCHAR(50) = ''
)
AS

DECLARE @w_error CHAR(01), @w_msg_id CHAR(08), @w_descp VARCHAR(250), @w_return int

SELECT @w_error = 'I', @w_msg_id = '00000001', @w_descp = ' ', @w_return = 0

DECLARE @w_descp_add VARCHAR(10)
SELECT @w_descp_add = ' '

DECLARE @w_application VARCHAR(20)
SELECT @w_application = 'COMMON'

--DECLARE @p_contract_nbr CHAR(12)
EXEC @w_return = usp_get_key @p_username, 'CREATE CONTRACTS', @p_contract_nbr OUTPUT, 'N'

IF @w_return <> 0
BEGIN
   SELECT @w_descp_add = '(Contract Number)'
   GOTO GOTO_create_error
END

SELECT @w_return = 0

--Based on the discussion with Jaime and Eric we are now removing the code to insert records into deal_contract_print table
--Commented on July 8 2013-- 14201 cleanup and page refactoring on Deal Capture
--This fix is to able to autogenerate a contract number and then use it. Earlier it was working only for paper contracts
--INSERT INTO [lp_deal_capture].[dbo].[deal_contract_print]
--       ([request_id]    , [status] , [contract_nbr]                   , [username] , [retail_mkt_id], [puc_certIFication_number],[utility_id],[product_id],[rate_id]  ,[rate],[rate_descp],[term_months],[contract_eff_start_date],[grace_period],[date_created],[contract_template],[contract_rate_type])
--SELECT  'BLANK CONTRACT', 'COMPLETED', substring(@p_contract_nbr, 1, 12), @p_username, ''             , ''                        , 'NONE'     ,'NONE'      ,'999999999',0     ,''          ,0            ,getdate()                ,365           ,getdate()     ,''                 ,null

IF @@error <> 0 OR @@rowcount = 0
BEGIN
  GOTO GOTO_create_error
END

SELECT @w_return = 0

GOTO GOTO_SELECT

GOTO_create_error:

SELECT @w_application = 'DEAL', @w_error = 'E', @w_msg_id = '00000001', @w_return = 1

GOTO_SELECT:

IF @w_error <> 'N'
BEGIN
   EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp output, @w_application
   SELECT @w_descp = ltrim(rtrim(@w_descp)) + ' ' + @w_descp_add 
END

IF @p_result_ind = 'Y'
BEGIN
   SELECT flag_error = @w_error, code_error = @w_msg_id, message_error = @w_descp
   GOTO GOTO_RETURN
END

SELECT @p_error = @w_error, @p_msg_id = @w_msg_id, @p_descp = @w_descp

GOTO_RETURN:
RETURN @w_return










