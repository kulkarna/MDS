-- =============================================
-- Author:		Alberto Franco
-- Create date: November 9, 2007
-- Description:	Updates a log entry for a source file processed.
-- =============================================
CREATE PROCEDURE [dbo].[USP_LOG_FILE_PROCESSED_UPD]
	@P_ROW_ID INT,
	@P_SUCCESS BIT,
	@P_ERROR_MSG VARCHAR(1000)
AS
	SET NOCOUNT ON;

	IF @P_ERROR_MSG IS NOT NULL
		IF LEN(@P_ERROR_MSG) = 0
			SET @P_ERROR_MSG = NULL;

	UPDATE LOG_FILE_PROCESSED
		SET SUCCESS = @P_SUCCESS, ERROR_MSG = @P_ERROR_MSG
		WHERE ROW_ID = @P_ROW_ID;
