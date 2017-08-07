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

CREATE PROCEDURE [dbo].[usp_ProspectAccountIcapFactorSelect]
	@OfferId		varchar(50),
	@AccountNumber	varchar(50)
AS

BEGIN
	SET NOCOUNT ON;

	SELECT	t1.ID, OfferId, FactorId, AccountNumber, IcapFactor, IcapDate, UtilityCode, LoadShapeId
	FROM	ProspectAccountIcapFactor t1 (nolock)
			INNER JOIN OE_ACCOUNT t2 (nolock)
				ON AccountNumber = account_number
			INNER JOIN libertypower..IcapFactors t3 (nolock)
				ON FactorId = t3.Id
	WHERE	OfferId		= @OfferId 
		AND	t1.AccountNumber	= @AccountNumber

	SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

