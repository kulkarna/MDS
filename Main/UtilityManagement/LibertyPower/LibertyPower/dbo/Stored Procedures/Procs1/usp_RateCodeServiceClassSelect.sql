


/*******************************************************************************
 * usp_RateCodeSelect
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeServiceClassSelect]  
	@Utility					varchar(32)
AS
	SELECT DISTINCT ServiceClass
	FROM	RateCode 
	WHERE RateCode.Utility = @Utility
	ORDER BY ServiceClass


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeServiceClassSelect';

