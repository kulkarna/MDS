
/*******************************************************************************
 * usp_CommTransDetailIdProcessedUpdate
 * Update last transaction processed id
 *
 * History
 *******************************************************************************
 * 6/25/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_CommTransDetailIdProcessedUpdate]
	@TransactionDetailId	int,
	@ReportDate				datetime
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE	CommTransDetailIdProcessed
	SET		TransactionDetailId	= @TransactionDetailId,
			ReportDate			= @ReportDate
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power

