

CREATE PROCEDURE [dbo].[usp_VRE_ISOZoneSelectList]
(
 @UtilityCode varchar(50) ,
 @ContextDate datetime )
AS
SET NOCOUNT ON
SELECT
    ID , UtilityCode , Zone , ISOZone , 
    DateCreated , CreatedBy , DateModified , 
    ModifiedBy , IsActive
FROM
    VREISOZone WITH ( nolock )
WHERE
    ID IN ( SELECT
                MAX(ID)
            FROM
                VREISOZone WITH ( nolock )
            WHERE
                UtilityCode = @UtilityCode
                AND DateModified <= @ContextDate
                AND IsActive = 1
            GROUP BY
                Zone , ISOZone )

SET NOCOUNT OFF

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ISOZoneSelectList';

