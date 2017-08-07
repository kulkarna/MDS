﻿-- =============================================
-- Author:		Alberto Franco
-- Create date: October 18, 2007
-- Description:	Inserts a new log entry for a processed source file.
-- =============================================
CREATE PROCEDURE [dbo].[USP_LOG_FILE_PROCESSED_INS]
	@P_DROPPED_ID INT,
	@P_FILE_TYPE VARCHAR(50),
	@P_SUCCESS BIT,
	@P_FILE_NAME VARCHAR(100),
	@P_DATE_STAMP DATETIME,
	@P_ERROR_MSG VARCHAR(1000),
	@P_CREATED_BY VARCHAR(50)
AS
	SET NOCOUNT ON;

	DECLARE @M_FILE_TYPE_ID INT;

	-- Get the ID of the related row in the USAGE_FILE_MAP table.
	SELECT @M_FILE_TYPE_ID = ROW_ID 
	FROM USAGE_FILE_TYPE 
	WHERE FILE_TYPE = @P_FILE_TYPE;

	IF @P_DATE_STAMP IS NOT NULL
		IF @P_DATE_STAMP = CAST('12/30/1899 12:00:00 AM' AS DATETIME)
			SET @P_DATE_STAMP = NULL;

	IF @P_ERROR_MSG IS NOT NULL
		IF LEN(@P_ERROR_MSG) = 0
			SET @P_ERROR_MSG = NULL;

	INSERT INTO LOG_FILE_PROCESSED (DROPPED_ID, FILE_TYPE_ID, SUCCESS, [FILE_NAME], DATE_STAMP, ERROR_MSG, CREATED_BY)
	VALUES (@P_DROPPED_ID, @M_FILE_TYPE_ID, @P_SUCCESS, @P_FILE_NAME, @P_DATE_STAMP, @P_ERROR_MSG, @P_CREATED_BY);

	RETURN @@IDENTITY;
