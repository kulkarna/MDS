-- exec libertypower.dbo.usp_ServiceClassMapper 'CONED','9'
-- =============================================
-- Author:		Eric Hernandez
-- Create date: 2010-09-27
-- Description:	Helps identify a standard ID for various service class spellings.
--              Any failed attempt to find a mapping gets logged to ServiceClassMapping_ErrorLog
--              Any successful mapping gets cleared from ServiceClassMapping_ErrorLog if it is there.
-- =============================================
CREATE PROCEDURE usp_ServiceClassMapper (@Utility VARCHAR(20),@ServiceClass VARCHAR(50))
AS
BEGIN
	DECLARE @UtilityID INT
	SELECT @UtilityID = ID
	FROM libertypower..Utility
	WHERE UtilityCode = rtrim(ltrim(@Utility))

	DECLARE @ServiceClassID INT
	SET @ServiceClassID = NULL

	SELECT @ServiceClassID = sc.service_rate_class_id
	FROM lp_common..service_rate_class sc
	JOIN libertypower..Utility u ON sc.utility_id = u.UtilityCode
	LEFT JOIN libertypower..ServiceClassMapping scm ON scm.ServiceClassID = sc.service_rate_class_id AND scm.utilityId = u.ID
	WHERE u.ID = @UtilityID
	AND (
		 scm.[text] = @ServiceClass  -- Check if the text appears in mapping table.
			OR 
		 sc.service_rate_class = @ServiceClass     -- Check if spelling is a direct match to our service class table.
		 )


	-- Here we track all failed attempts to look up a value.
	IF (@ServiceClassID IS NULL)
		INSERT INTO ServiceClassMapping_ErrorLog
		(UtilityID, ServiceClass, [Description])
		VALUES (@UtilityID, @ServiceClass, 'No mapping')
	ELSE
		UPDATE ServiceClassMapping_ErrorLog
		SET [Description] = 'Mapping found'
		WHERE UtilityID = @UtilityID AND ServiceClass = @ServiceClass AND [Description] = 'No mapping'

	PRINT @ServiceClassID
	RETURN @ServiceClassID
END
