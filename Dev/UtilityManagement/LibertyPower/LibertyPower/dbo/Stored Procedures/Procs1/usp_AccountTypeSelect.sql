/*******************************************************************************
 * usp_AccountTypeSelect
 
 * Gets account type
 *
 * History
 *******************************************************************************
 * 6/3/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 11/15/2012 - Lev Rosenblum
 * Add @AccountType as intput parameter with Null default value
 * Add AccountGroup, DateCreated, ProductAccountTypeID as output fields
 * Simplified the select statement
 *******************************************************************************
 */
 --exec [usp_AccountTypeSelect] @Description='SMB'
 
CREATE PROCEDURE [dbo].[usp_AccountTypeSelect]
(	
	@Identity	 int = -1
	, @Description varchar(50) = ''
	, @AccountType varchar(50) = null
)
AS
BEGIN
    SET NOCOUNT ON;
 --   SELECT	[ID], AccountType, [Description], AccountGroup, DateCreated, ProductAccountTypeID
	--FROM	AccountType WITH (NOLOCK)
	--WHERE	ID = Case When @Identity=-1 THEN ID ELSE @Identity END
	--	AND [Description] = Case When @Description='' THEN [Description] ELSE @Description END
	--	AND AccountType = Case When @AccountType=NULL THEN AccountType ELSE @AccountType END
    
    IF @Identity <> -1
		SELECT	[ID], AccountType, [Description],AccountGroup, DateCreated, ProductAccountTypeID
		FROM	AccountType WITH (NOLOCK)
		WHERE	ID = @Identity
    ELSE
		SELECT TOP 1 [ID], AccountType, [Description]
		FROM	AccountType
		WHERE AccountType LIKE @Description
		ORDER BY [ID]
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
