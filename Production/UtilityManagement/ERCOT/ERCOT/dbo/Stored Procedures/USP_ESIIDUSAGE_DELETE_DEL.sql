-- =============================================
-- Author:		Alberto Franco
-- Create date: November 14, 2007
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[USP_ESIIDUSAGE_DELETE_DEL]
	@P_UIDESIID CHAR(50),
	@P_STARTTIME DATETIME,
	@P_METERTYPE CHAR(64),
	@P_D_TIMESTAMP DATETIME,
	@P_ENTITY_ID CHAR(15)
AS
	SET NOCOUNT ON;

	DECLARE @M_DELETE_ID INT;

	-- Find a matching row to delete.
	SELECT TOP 1 @M_DELETE_ID = ROW_ID 
	FROM ESIIDUSAGE_DELETE
	WHERE   UIDESIID    = @P_UIDESIID 
		AND STARTTIME   = @P_STARTTIME
		AND METERTYPE   = @P_METERTYPE
		AND D_TIMESTAMP = @P_D_TIMESTAMP
		AND ENTITY_ID   = @P_ENTITY_ID
	ORDER BY D_TIMESTAMP ASC

	-- Remove foreign key reference to be able to delete row.
	IF @M_DELETE_ID IS NOT NULL
		UPDATE ESIIDUSAGE 
		SET Cancelled = 0, DELETE_ID = NULL 
		WHERE DELETE_ID = @M_DELETE_ID;

	-- Finally delete row.
	DELETE FROM ESIIDUSAGE_DELETE
	WHERE ROW_ID = @M_DELETE_ID;
