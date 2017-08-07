

CREATE PROCEDURE [dbo].[usp_VRE_ServiceClassMapUpdate]
(
 @ID int ,
 @ServiceClass varchar(50),
 @RawServiceClass varchar(50) ) 
AS
SET NOCOUNT ON

UPDATE
    VRE_ServiceClassMapping
SET
    ServiceClass = @ServiceClass,
    RawServiceClass = @RawServiceClass 
WHERE
    [ID] = @ID

SELECT
    ID , UtilityCode, ServiceClass , RawServiceClass, DateCreated , CreatedBy , DateModified , ModifiedBy
FROM
    VRE_ServiceClassMapping 
WHERE
    IsActive = 1
    
SET NOCOUNT OFF

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ServiceClassMapUpdate';

