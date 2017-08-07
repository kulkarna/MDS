/*******************************************************************************
 * usp_EdiTransactionStatusSelect
 * Gets transaction status'
 *
 * History
 *******************************************************************************
 * 4/27/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EdiTransactionStatusSelect]                                                                                    

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	TransactionStatus
	FROM	EdiTransactionStatus

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

