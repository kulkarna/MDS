
/*******************************************************************************
 * usp_EdiTransactionProcessingHeaderInsert
 * Insert header record, returning the batch id
 *
 * History
 *******************************************************************************
 * 4/27/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EdiTransactionProcessingHeaderInsert]                                                                                    

@Began	datetime,
@Ended	datetime

AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	EdiTransactionProcessingHeader (RecordsProcessed, Began, Ended)
	VALUES		(0, @Began, @Ended)

	SELECT	@@IDENTITY

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

