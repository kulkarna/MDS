
/*
* AUTHOR: Al Tafur
*
* FUNCTION:	usp_GetApplicationFeatureSetting
*
* DEFINITION:  Determines a true/false value for the requested appication feature
*
* RETURN CODE: TRUE/FALSE
*
* REVISIONS:	9/21/2012
TEST:
EXEC ufn_GetApplicationFeatureSetting 'IT043','EnrollmentApp'
*/

CREATE FUNCTION [dbo].[ufn_GetApplicationFeatureSetting]
(
		 @Featurename VARCHAR(20)
		,@ProcessName VARCHAR(50) = NULL
)
RETURNS BIT
AS
BEGIN

	DECLARE @FeatureValue BIT
	SET @FeatureValue = 0
     
	SELECT @FeatureValue = CASE WHEN [FeatureValue] IS NULL THEN 0
						   ELSE [FeatureValue]
						   END
	FROM  [ApplicationFeatureSettings] with (nolock)
	where [FeatureName] = @FeatureName
	and   (@ProcessName IS NULL OR Processname = @ProcessName)
	

	RETURN @FeatureValue 
	
END
----------------------------------------------------------------------------------------------------------


--commit
--rollback
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetApplicationFeatureSetting] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetApplicationFeatureSetting] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

