CREATE PROCEDURE [dbo].[usp_VRE_ServiceClassMapUpdateServiceClass]
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

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ServiceClassMapUpdateServiceClass';

