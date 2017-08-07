--------------------------------------------------------------------------------
-- Procedure:	USP_DUPLICATE_MARKET_DROP_FILE_SEL
-- Author:		Alberto Franco
-- Written:		October 31, 2007
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DUPLICATE_MARKET_DROP_FILE_SEL]
	@P_FILE_NAME VARCHAR(100)
AS
	IF EXISTS (SELECT NULL FROM LOG_MARKET_DROPPED WHERE FILE_NAME = @P_FILE_NAME AND SUCCESS = 1)
		SELECT ROW_ID, CREATED FROM LOG_MARKET_DROPPED WHERE FILE_NAME = @P_FILE_NAME AND SUCCESS = 1;
	ELSE
		SELECT ROW_ID = CAST(0 AS INT), CREATED = CAST('1/1/1900' AS DATETIME);
