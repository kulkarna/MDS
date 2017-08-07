DECLARE	@UtilityTable TABLE (UtilityCode varchar(50))
DECLARE	@UtilityCode varchar(50)

INSERT	INTO @UtilityTable
SELECT	u.UtilityCode
FROM	Libertypower..Utility u WITH (NOLOCK)
		INNER JOIN Libertypower..Market m WITH (NOLOCK) ON u.MarketID = m.ID
WHERE	m.MarketCode IN ('CT', 'MD', 'PA')
ORDER BY u.UtilityCode

WHILE (SELECT COUNT(UtilityCode) FROM @UtilityTable) > 0
	BEGIN
		SELECT TOP 1 @UtilityCode = UtilityCode FROM @UtilityTable
		
		EXEC lp_common..usp_ProductSetupForUtility @UtilityCode
		
		DELETE FROM @UtilityTable WHERE UtilityCode = @UtilityCode
	END