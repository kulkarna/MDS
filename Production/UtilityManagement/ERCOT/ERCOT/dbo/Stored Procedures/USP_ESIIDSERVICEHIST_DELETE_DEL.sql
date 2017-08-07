-- =============================================
-- Author:		Alberto Franco
-- Create date: November 14, 2007
-- Description:	Removes the foreign key reference and deletes a rwo
--				in the ESIIDSERVICEHIST_DELETE table. 
--				At this point, we believe that a duplicate entry in this
--				table signifies that the existing one is in error so we 
--				delete it to later allow insertion of the new row.
-- =============================================
CREATE PROCEDURE [dbo].[USP_ESIIDSERVICEHIST_DELETE_DEL]
	@P_UIDESIID CHAR(50),
	@P_SERVICECODE CHAR(64),
	@P_STARTTIME DATETIME,
	@P_SRC_ADDTIME DATETIME,
	@P_ENTITY_ID CHAR(15)
AS
	SET NOCOUNT ON;

	DECLARE @M_DELETE_ID INT;

	-- Find a matching row to delete.
	SELECT TOP 1 @M_DELETE_ID = ROW_ID 
	FROM ESIIDSERVICEHIST_DELETE
	WHERE   UIDESIID    = @P_UIDESIID 
		AND SERVICECODE = @P_SERVICECODE
		AND STARTTIME   = @P_STARTTIME
		AND SRC_ADDTIME = @P_SRC_ADDTIME
		AND ENTITY_ID   = @P_ENTITY_ID
	ORDER BY SRC_ADDTIME ASC

	-- Remove foreign key reference to be able to delete row.
	IF @M_DELETE_ID IS NOT NULL
		UPDATE ESIIDSERVICEHIST 
		SET Cancelled = 0, DELETE_ID = NULL 
		WHERE DELETE_ID = @M_DELETE_ID;

	-- Finally delete row.
	DELETE FROM ESIIDSERVICEHIST_DELETE
	WHERE ROW_ID = @M_DELETE_ID;
