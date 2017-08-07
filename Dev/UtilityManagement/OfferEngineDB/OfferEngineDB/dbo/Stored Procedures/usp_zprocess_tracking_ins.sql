-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/3/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_zprocess_tracking_ins]

@p_request_id		varchar(50)		= '',
@p_offer_id			varchar(50)		= '',
@p_status			varchar(50)		= '',
@p_account_number	varchar(50)		= '',
@p_process			varchar(100)	= '',
@p_process_stage	varchar(50)		= ''

AS

INSERT INTO	zPROCESS_TRACKING (REQUEST_ID, OFFER_ID, STATUS, ACCOUNT_NUMBER, PROCESS, PROCESS_STAGE, DATE_INSERT)
VALUES		(@p_request_id, @p_offer_id, @p_status, @p_account_number, @p_process, @p_process_stage, GETDATE())
