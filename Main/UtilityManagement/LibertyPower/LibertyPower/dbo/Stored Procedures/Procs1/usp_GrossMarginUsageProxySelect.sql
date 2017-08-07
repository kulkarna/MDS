
/*******************************************************************************
 * usp_GrossMarginUsageProxySelect
 * Select proxy usage for account type
 *
 * History
 *******************************************************************************
 * 5/21/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GrossMarginUsageProxySelect]                                                                                    
	@AccountType	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	Usage
	FROM	GrossMarginUsageProxy WITH (NOLOCK)
	WHERE	AccountType = @AccountType

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

