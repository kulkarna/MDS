

/*******************************************************************************
 * usp_RowsPerDealInsert_Test
 * Inserts usage into the RowsPerDeal table (for testing purposes only)
 *
 * History
 * 07/19/2012 - removed "IF NOT EXISTS" check
 *******************************************************************************
 * 02/25/2008 - Eduardo Patino
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_RowsPerDealInsert_Test]
	@AccountNumber			varchar(50),
	@DealId					varchar(50),
	@RowId					bigint,
	@isEstimated			smallint
AS
-- select top 20 * from RowsPerDeal_Test (nolock)
BEGIN
    SET NOCOUNT ON;

/*
IF NOT EXISTS (
	SELECT	AccountNumber
	FROM	RowsPerDeal_Test
	WHERE	AccountNumber	= @AccountNumber
		AND	DealID			= @DealID
		AND	RowID			= @RowID )
*/

--BEGIN
	INSERT INTO	RowsPerDeal_Test
				(AccountNumber, DealID, RowID, isEstimated)
	VALUES		(RTRIM(@AccountNumber), UPPER(RTRIM(@DealID)), @RowID, @isEstimated)
--END

/*
	SELECT	AccountNumber, DealID, RowID, isEstimated
	FROM	RowsPerDeal_Test
	WHERE	AccountNumber	= @AccountNumber
		AND	DealID			= @DealID
		AND	RowID			= @RowID
*/

	SET NOCOUNT OFF;
END

-- Copyright 2009 Liberty Power


