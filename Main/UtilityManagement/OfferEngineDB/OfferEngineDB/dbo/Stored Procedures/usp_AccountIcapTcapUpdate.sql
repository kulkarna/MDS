/*******************************************************************************
 * usp_AccountIcapTcapUpdate
 * Update ICAPs and TCAPs
 *
 * History
 *******************************************************************************
 * 2/12/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountIcapTcapUpdate]                                                                                    
	@AccountNumber	varchar(50),
	@Icap			decimal(18, 9),	
	@Tcap			decimal(18, 9)	
AS
BEGIN
    SET NOCOUNT ON;

	UPDATE	OE_ACCOUNT
	SET		ICAP			= @Icap,
			TCAP			= @Tcap
	WHERE	ACCOUNT_NUMBER	= @AccountNumber

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

