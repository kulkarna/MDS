--------------------------------------------------------------------------------
-- Procedure:	USP_LOG_MARKET_DROPPED_UPD
-- Author:		Alberto Franco
-- Written:		October 29, 2007
-- Description:	Updates a previously inserted log entry for LOG_MARKET_DROPPED.
--				The previously inserted row ID is required to update the row.
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_LOG_MARKET_DROPPED_UPD]
	@P_ROW_ID INT,
	@P_FILE_MAP_ID INT,
	@P_TIME_STAMP DATETIME,
	@P_SUCCESS BIT,
	@P_ERROR_MSG VARCHAR(500)
AS
	IF NOT EXISTS (SELECT NULL FROM LOG_MARKET_DROPPED WHERE ROW_ID = @P_ROW_ID)
		RAISERROR ('Invalid row identifier while updating log for dropped file.', 1, 1)
	ELSE
	BEGIN
		UPDATE LOG_MARKET_DROPPED 
		SET 
			FILE_MAP_ID = CASE WHEN @P_FILE_MAP_ID = 0 THEN NULL ELSE @P_FILE_MAP_ID END, 
			TIME_STAMP = CASE WHEN @P_TIME_STAMP = '1/1/1900' THEN NULL ELSE @P_TIME_STAMP END, 
			SUCCESS = @P_SUCCESS, 
			ERROR_MSG = @P_ERROR_MSG
		WHERE 
			ROW_ID = @P_ROW_ID;
	END
