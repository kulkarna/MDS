CREATE PROCEDURE [dbo].[usp_UtilityClassMappingZoneExists]
	@UtilityId int = null,
	@UtilityCode varchar(50) = null
AS
BEGIN
    SET NOCOUNT ON;
    
    If @UtilityId is null    
		Select @UtilityId = U.ID From Utility U Where UtilityCode = @UtilityCode
		
	Select 
		Top 1 UCM.ID
	From
		UtilityClassMapping UCM
		Inner Join
		Zone Z
		On
		UCM.ZoneID = Z.Id
	Where
		UtilityID = @UtilityId And
		(Z.ZoneCode <> '' And Z.ZoneCode Is Not Null) 

    SET NOCOUNT OFF;
END


