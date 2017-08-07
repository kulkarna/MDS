--------------------------------------------------------------------------------
-- Procedure:	USP_LOG_MARKET_DROP_NEW_INS
-- Author:		Alberto Franco
-- Written:		October 29, 2007
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_LOG_MARKET_PROCESSED_INS]
	@P_LOG_DROPPED_ID INT,
	@P_FILE_NAME VARCHAR(100),
	@P_ERROR_MSG VARCHAR(500)
AS
	INSERT INTO LOG_MARKET_PROCESSED
			(LOG_DROPPED_ID   , [FILE_NAME] , ERROR_MSG   )
		VALUES
			(@P_LOG_DROPPED_ID, @P_FILE_NAME, @P_ERROR_MSG);

	RETURN @@IDENTITY;
