-- =============================================
-- Author:		Alberto Franco
-- Create date: November 12, 2007
-- Description:	Updates an existing log entry for a dropped file.
-- =============================================
CREATE PROCEDURE [dbo].[USP_LOG_FILE_DROPPED_UPD]
	@P_DROPPED_ID INT,
	@P_SUCCESS BIT,
	@P_ERROR_MSG VARCHAR(1000)
AS
	SET NOCOUNT ON;

	IF @P_ERROR_MSG IS NOT NULL
		IF LEN(@P_ERROR_MSG) = 0
			SET @P_ERROR_MSG = NULL;

	UPDATE LOG_FILE_DROPPED 
		SET SUCCESS = @P_SUCCESS, ERROR_MSG = @P_ERROR_MSG 
		WHERE ROW_ID = @P_DROPPED_ID
