
/*******************************************************************************
 * usp_GetLastProcessed814Key
 * Get last processed 814 key
 *
 * History
 *******************************************************************************
 * 4/27/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GetLastProcessed814Key]                                                                                    

AS
BEGIN
    SET NOCOUNT ON;

	--SELECT 4046032
	SELECT	ISNULL(MAX([Key814]), 3506555)
	FROM	EdiTransactionProcessingDetail

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

