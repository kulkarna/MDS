/*******************************************************************************
 * usp_AccountTypeSelectByType
 * Gets account type by account type code
 *
 * History
 *******************************************************************************
 * 6/3/2010 - George
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountTypeSelectByAccountType]
	@AccountType	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	[ID], AccountType, [Description]
	FROM	AccountType WITH (NOLOCK)
	WHERE	((AccountType = @AccountType) OR (@AccountType = 'RESIDENTIAL' AND ID = 3))
    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
