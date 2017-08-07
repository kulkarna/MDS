

CREATE PROCEDURE [dbo].[usp_VRE_MinUsageByServiceClassZoneSelectList]
(
 @ContextDate datetime )
AS
SET NOCOUNT ON
SELECT
    ID , ServiceClass , ISOZone , MinMonthlyKwhUsage , 
    DateModified , ModifiedBy
FROM
    VRE_MinUsageByServiceClassZone WITH ( nolock )
WHERE
    ID IN ( SELECT
                MAX(ID)
            FROM
                VRE_MinUsageByServiceClassZone WITH ( nolock )
            WHERE
                DateModified <= @ContextDate
            GROUP BY
                ServiceClass )

SET NOCOUNT OFF

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_MinUsageByServiceClassZoneSelectList';

