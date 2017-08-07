


/*******************************************************************************
 * usp_RateCodeSelect
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeZoneSelect]  
	@Utility					varchar(32)
AS
	SELECT DISTINCT ZoneCode
	FROM	RateCode 
	WHERE RateCode.Utility = @Utility
	ORDER BY ZoneCode

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeZoneSelect';

