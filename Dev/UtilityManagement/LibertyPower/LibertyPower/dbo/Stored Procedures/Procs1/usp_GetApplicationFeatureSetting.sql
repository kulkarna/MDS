
/*
* AUTHOR: Al Tafur
*
* PROCEDURE:	usp_GetApplicationFeatureSetting
*
* DEFINITION:  Determines a true/false value for the requested appication feature
*
* RETURN CODE: TRUE/FALSE
*
* REVISIONS:	9/21/2012
TEST:
EXEC usp_GetApplicationFeatureSetting 'IT043','EnrollmentApp'
*/

CREATE PROCEDURE [dbo].[usp_GetApplicationFeatureSetting]
		 @Featurename VARCHAR(20)
		,@ProcessName VARCHAR(50) = NULL
AS
BEGIN

SET NOCOUNT ON
	DECLARE @FeatureValue BIT
	SET @FeatureValue = 0
     
	SELECT @FeatureValue = CASE WHEN [FeatureValue] IS NULL THEN 0
						   ELSE [FeatureValue]
						   END
	FROM  [ApplicationFeatureSettings] with (nolock)
	where [FeatureName] = @FeatureName
	and   (@ProcessName IS NULL OR Processname = @ProcessName)
	

	SELECT @FeatureValue 
	
SET NOCOUNT OFF
END
