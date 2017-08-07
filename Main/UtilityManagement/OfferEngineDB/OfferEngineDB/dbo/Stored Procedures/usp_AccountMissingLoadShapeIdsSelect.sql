/*******************************************************************************
 * usp_AccountMissingLoadShapeIdsSelect
 * <Purpose,,>
 *
 * History
 *******************************************************************************
 * 4/8/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountMissingLoadShapeIdsSelect]                                                                                     
	@OfferId	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	a.ACCOUNT_NUMBER
	FROM	OE_OFFER_ACCOUNTS o WITH (NOLOCK) INNER JOIN OE_ACCOUNT a WITH (NOLOCK) 
			ON o.OE_ACCOUNT_ID = a.ID
	WHERE	o.OFFER_ID = @OfferId
	AND		(a.LOAD_SHAPE_ID IS NULL OR LEN(a.LOAD_SHAPE_ID) = 0)
	

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

