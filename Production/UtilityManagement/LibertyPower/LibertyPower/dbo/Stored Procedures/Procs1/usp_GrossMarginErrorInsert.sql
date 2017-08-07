
/*******************************************************************************
 * usp_GrossMarginErrorInsert
 * Log framework errors
 *
 * History
 *******************************************************************************
 * 4/27/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GrossMarginErrorInsert] 
	@AccountId		char(12) = '',                                                                                  
	@ErrorLocation	varchar(500),
	@ErrorMessage	text,
	@ErrorDate		datetime
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	GrossMarginErrorLog (AccountId, ErrorLocation, ErrorMessage, ErrorDate)
	VALUES		(@AccountId, @ErrorLocation, @ErrorMessage, @ErrorDate)

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

