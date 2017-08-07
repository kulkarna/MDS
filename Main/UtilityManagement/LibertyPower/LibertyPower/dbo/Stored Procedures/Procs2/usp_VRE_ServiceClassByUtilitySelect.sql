CREATE PROCEDURE [dbo].[usp_VRE_ServiceClassByUtilitySelect]
AS
SET NOCOUNT ON

SELECT DISTINCT
    utility_id AS UtilityCode , service_rate_class AS ServiceClass
FROM
    lp_common..service_rate_class WITH ( NOLOCK )
ORDER BY
    UtilityCode , ServiceClass

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ServiceClassByUtilitySelect';

