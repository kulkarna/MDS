

CREATE PROCEDURE [dbo].[usp_ZoneIdExistsForUtilityId]
	@UtilityCode varchar(50),
	@ZoneCode varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
		
		Select 
			*
		From 
			Utility U
			Inner Join 
			UtilityZone UZ
			On U.ID = UZ.UtilityID
			Inner Join 
			Zone Z
			On Z.ID = UZ.ZoneID
		Where
			U.UtilityCode = @UtilityCode And
			Z.ZoneCode = @ZoneCode
   

    SET NOCOUNT OFF;
END
