--------------------------------------------------------------------------------
-- Procedure:	USP_LOG_MARKET_DROPPED_INS
-- Author:		Alberto Franco
-- Written:		October 29, 2007
-- Description:	Inserts a new log entry in the LOG_MARKET_DROPPED. Save the 
--				newly inserted row identity for later update of same row.
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_LOG_MARKET_DROPPED_INS]
	@P_FILE_NAME VARCHAR(100),
	@P_ERROR_MSG VARCHAR(500)
AS
	INSERT INTO LOG_MARKET_DROPPED ([FILE_NAME], ERROR_MSG) VALUES (@P_FILE_NAME, @P_ERROR_MSG);
	RETURN @@IDENTITY;
