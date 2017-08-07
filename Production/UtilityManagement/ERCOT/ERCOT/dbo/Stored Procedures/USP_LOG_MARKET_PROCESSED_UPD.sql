--------------------------------------------------------------------------------
-- Procedure:	USP_LOG_MARKET_PROCESSED_UPD
-- Author:		Alberto Franco
-- Written:		October 30, 2007
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_LOG_MARKET_PROCESSED_UPD]
	@P_ROW_ID INT,
	@P_FILE_TYPE_ID INT,
	@P_TIME_STAMP AS DATETIME,
	@P_SUCCESS BIT,
	@P_ERROR_MSG VARCHAR(500)
AS
	UPDATE LOG_MARKET_PROCESSED
	SET FILE_TYPE_ID = @P_FILE_TYPE_ID, TIME_STAMP = @P_TIME_STAMP, SUCCESS = @P_SUCCESS, ERROR_MSG = @P_ERROR_MSG
	WHERE ROW_ID = @P_ROW_ID;
