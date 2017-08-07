CREATE PROCEDURE [dbo].[usp_VRE_ServiceClassMapInsert]
(
 @UtilityCode varchar(50) ,
 @ServiceClass varchar(50),
 @RawServiceClass varchar(50) ) 
AS
SET NOCOUNT ON


IF NOT EXISTS (SELECT ID FROM VRE_ServiceClassMapping WHERE UtilityCode = @UtilityCode AND RawServiceClass = @RawServiceClass)
BEGIN 

INSERT INTO
    VRE_ServiceClassMapping (UtilityCode, ServiceClass,  RawServiceClass)
	VALUES
	( @UtilityCode, @ServiceClass,  @RawServiceClass )
END
ELSE IF EXISTS (SELECT ID FROM VRE_ServiceClassMapping WHERE UtilityCode = @UtilityCode AND RawServiceClass = @RawServiceClass)
BEGIN 

	UPDATE VRE_ServiceClassMapping SET IsActive = 1 WHERE UtilityCode = @UtilityCode AND RawServiceClass = @RawServiceClass

END

SELECT
    ID , UtilityCode, ServiceClass , RawServiceClass, DateCreated , CreatedBy , DateModified , ModifiedBy
FROM
    VRE_ServiceClassMapping 
WHERE
    IsActive = 1
    
SET NOCOUNT OFF

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ServiceClassMapInsert';

