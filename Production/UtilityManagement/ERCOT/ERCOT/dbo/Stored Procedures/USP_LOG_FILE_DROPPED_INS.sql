-- =============================================
-- Author:		Alberto Franco
-- Create date: October 18, 2007
-- Description:	Inserts a new log entry for a dropped file.
-- =============================================
CREATE PROCEDURE [dbo].[USP_LOG_FILE_DROPPED_INS]
	@P_FILE_NAME_LOOKUP VARCHAR(50),
	@P_SEQUENCE_NUM INT,
	@P_ENTITY_ID VARCHAR(15),
	@P_SUCCESS BIT,
	@P_FILE_NAME VARCHAR(100),
	@P_DATE_STAMP DATETIME,
	@P_ERROR_MSG VARCHAR(1000),
	@P_CREATED_BY VARCHAR(50)
AS
	SET NOCOUNT ON;

	DECLARE @M_FILE_MAP_ID INT;

	-- Get the ID of the related row in the USAGE_FILE_MAP table.
	SELECT @M_FILE_MAP_ID = ROW_ID 
		FROM USAGE_FILE_MAP 
		WHERE FILE_NAME_LOOKUP = @P_FILE_NAME_LOOKUP;

	IF @P_DATE_STAMP IS NOT NULL
		IF @P_DATE_STAMP = CAST('12/30/1899 12:00:00 AM' AS DATETIME)
			SET @P_DATE_STAMP = NULL;

	IF @P_ERROR_MSG IS NOT NULL
		IF LEN(@P_ERROR_MSG) = 0
			SET @P_ERROR_MSG = NULL;

	INSERT INTO LOG_FILE_DROPPED (FILE_MAP_ID, SEQUENCE_NUM, SUCCESS, ENTITY_ID, [FILE_NAME], DATE_STAMP, ERROR_MSG, CREATED_BY)
	VALUES (@M_FILE_MAP_ID, @P_SEQUENCE_NUM, @P_SUCCESS, @P_ENTITY_ID, @P_FILE_NAME, @P_DATE_STAMP, @P_ERROR_MSG, @P_CREATED_BY);

	-- Use the returned identity value to later insert rows in the 
	-- LOG_FILE_PROCESSED table for the DROPPED_ID column.
	RETURN @@IDENTITY;
