
/*******************************************************************************
 * usp_ProspectAccountIcapFactorIns
 * INF65 Phase II - inserts into the ProspectAccountIcapFactor table
 *
 * History
 *******************************************************************************
 * 03/19/2009 - Eduardo Patino
 * Created.
 *******************************************************************************
*/

CREATE PROCEDURE [dbo].[usp_ProspectAccountIcapFactorIns]
	@OfferId		varchar(50),
	@AccountNumber	varchar(50),
	@FactorId		int
AS
BEGIN
	SET NOCOUNT ON;

IF NOT EXISTS (
	SELECT	OfferId
	FROM	ProspectAccountIcapFactor
	WHERE	AccountNumber	= @AccountNumber
		AND	OfferId			= @OfferId
		AND	FactorId		= @FactorId )

	BEGIN
		INSERT INTO ProspectAccountIcapFactor (AccountNumber, OfferId, FactorId)
		VALUES (@AccountNumber, @OfferId, @FactorId)
	END

	SELECT	ID, AccountNumber, OfferId, FactorId
	FROM	ProspectAccountIcapFactor
	WHERE	OfferId			= @OfferId 
		AND	AccountNumber	= @AccountNumber
		AND	FactorId		= @FactorId

	SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

