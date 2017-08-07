CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingZoneExists]
	@UtilityId int = null,
	@UtilityCode varchar(50) = null
AS
BEGIN
    SET NOCOUNT ON;
    
    If @UtilityId is null    
		Select @UtilityId = U.ID From Utility U Where UtilityCode = @UtilityCode
		
	Select 
		Top 1 UZM.ID
	From
		UtilityZoneMapping UZM
		Inner Join 
		UtilityZone UZ
		On UZM.UtilityZoneID = UZ.ID
		Inner Join
		Zone Z
		On Z.ID = UZ.ZoneID		
	Where
		UZM.UtilityID = @UtilityId And
		(Z.ZoneCode <> '' And Z.ZoneCode Is Not Null) 

    SET NOCOUNT OFF;
END


