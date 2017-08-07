
CREATE PROCEDURE [dbo].[usp_VRE_PorInsert]
(
 @Utility varchar(50) ,
 @ServiceClassID varchar(50) ,
 @PorType varchar(50) ,
 @PorRate decimal(10,5) ,
 @CreatedBy int ,
 @FileContextGuid uniqueidentifier )
AS
BEGIN
      SET NOCOUNT ON ;

      INSERT INTO
          VREPorDataCurve
          (
            Utility , ServiceClassID , PorType , PorRate , CreatedBy , FileContextGuid )
      VALUES
          (
            @Utility , @ServiceClassID, @PorType , @PorRate, @CreatedBy,  @FileContextGuid )

      SELECT
          SCOPE_IDENTITY()

      SET NOCOUNT OFF ;
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_PorInsert';

