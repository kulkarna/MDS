
/*******************************************************************************
 * usp_EdiTransactionProcessingHeaderUpdate
 * Update header record, incrementing records processed
 * and updating ended date for specified batch id
 *
 * History
 *******************************************************************************
 * 4/27/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EdiTransactionProcessingHeaderUpdate]                                                                                    

@BatchId	int,
@Ended		datetime

AS
BEGIN
    SET NOCOUNT ON;

	UPDATE	EdiTransactionProcessingHeader
	SET		RecordsProcessed	= (RecordsProcessed + 1),
			Ended				= @Ended
	WHERE	BatchId				= @BatchId

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

