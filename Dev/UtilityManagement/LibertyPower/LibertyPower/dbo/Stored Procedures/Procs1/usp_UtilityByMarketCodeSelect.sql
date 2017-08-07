/*******************************************************************************
 * usp_UtilityByMarketCodeSelect
 * To get all utilities for specified market
 *
 * History
 *******************************************************************************
 * 7/28/2009 - Rick Deigsler
 * Created.
 *
 * Modified
 * 3/18/2010 - Rick Deigsler
 * This sproc was originally for EFL only.
 * Can't change sproc call from EFL without going through Release Management.
 * Added u.ID <= 8 as a qucik fix.
 * When all utilities were added to table,
 * it caused additional items in EFL dropdown.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityByMarketCodeSelect]
	@MarketCode	varchar(50)
	,@UtilityCodeList varchar(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

	-- hotfix for 19263.  Marketing does not want this utility to show.
	SET @UtilityCodeList = replace(@UtilityCodeList,'ONCOR-SESCO','')

    SET @UtilityCodeList = ',' + @UtilityCodeList + ','
    
	SELECT	u.ID, u.UtilityCode, u.FullName, u.ShortName
	FROM	Utility u WITH (NOLOCK) INNER JOIN Market m WITH (NOLOCK) ON u.MarketID = m.ID
	WHERE	m.MarketCode = @MarketCode
	AND (
		@UtilityCodeList IS NULL OR 
		CHARINDEX(','+u.UtilityCode+',',@UtilityCodeList) <> 0
		)
	--AND		u.ID <= 8
	ORDER BY u.ShortName
    
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
