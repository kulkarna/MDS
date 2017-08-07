
/*******************************************************************************
 * usp_EdiTransactionProcessingDetailInsert
 * Insert detail record
 *
 * History
 *******************************************************************************
 * 4/27/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EdiTransactionProcessingDetailInsert]                                                                                   

@Key814		int,
@Outcome	tinyint,
@Message	varchar(1000),
@BatchId	int

AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	EdiTransactionProcessingDetail ([Key814], Outcome, [Message], BatchId)
	VALUES		(@Key814, @Outcome, @Message, @BatchId)

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

