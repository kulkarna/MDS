-- exec libertypower.dbo.usp_ZoneMapper 'ACE','nonsense'
-- =============================================
-- Author:		Eric Hernandez
-- Create date: 2010-09-27
-- Description:	Helps identify a standard ID for various zone spellings.
--              Any failed attempt to find a mapping gets logged to ZoneMapping_ErrorLog
--              Any successful mapping gets cleared from ZoneMapping_ErrorLog if it is there.
-- =============================================
CREATE PROCEDURE usp_ZoneMapper (@Utility VARCHAR(20),@Zone VARCHAR(50))
AS
BEGIN
	DECLARE @UtilityID INT
	SELECT @UtilityID = ID
	FROM libertypower..Utility
	WHERE UtilityCode = rtrim(ltrim(@Utility))

	DECLARE @ZoneID INT
	SET @ZoneID = NULL


	SELECT @ZoneID = z.zone_id 
	FROM lp_common..zone z
	JOIN libertypower..Utility u ON z.utility_id = u.UtilityCode
	LEFT JOIN libertypower..ZoneMapping zm ON zm.zoneId = z.zone_id AND zm.utilityId = u.ID
	WHERE u.ID = @UtilityID
	AND (
		 zm.[text] = @Zone  -- Check if the text appears in mapping table.
			OR 
		 z.Zone = @Zone     -- Check if spelling is a direct match to our zone table.
			OR
		 (u.HasZones = 0 AND z.zone_id = u.ZoneDefault) -- For utilities which don't have zone, we can use the default value.
		 )


	-- Here we track all failed attempts to look up a value.
	IF (@ZoneID IS NULL)
		INSERT INTO ZoneMapping_ErrorLog
		(UtilityID, Zone, [Description])
		VALUES (@UtilityID, @Zone, 'No mapping')
	ELSE
		UPDATE ZoneMapping_ErrorLog
		SET [Description] = 'Mapping found'
		WHERE UtilityID = @UtilityID AND Zone = @Zone AND [Description] = 'No mapping'

	PRINT @ZoneID
	RETURN @ZoneID
END
