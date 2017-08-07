
CREATE PROCEDURE [dbo].[usp_ZoneIDByZoneCodeAndUtilityID]
	@UtilityID	int,
	@ZoneCode varchar(50)
AS
BEGIN
    SET NOCOUNT ON;         

	Declare @UtilityZoneTableZoneID int
	Declare @NewZoneID int
	Declare @ExistingZoneID int

	If Not Exists (Select * from Zone Where ZoneCode = @ZoneCode)
		Begin
			Insert Into Zone (ZoneCode) Values (@ZoneCode)
			Set @NewZoneID = SCOPE_IDENTITY()		
		End
		
	If @NewZoneID Is Null
	Begin
		Select @ExistingZoneID = ID from Zone Where ZoneCode = @ZoneCode
	End

	Select 
		@UtilityZoneTableZoneID = Z.ID 
	From 
		UtilityZone UZ 
		Inner Join Zone Z On UZ.ZoneID = Z.ID
		Inner Join Utility U On U.ID = UZ.UtilityID 
	Where ZoneCode = @ZoneCode And U.ID = @UtilityId	
					print @UtilityZoneTableZoneID
	If @UtilityZoneTableZoneID Is Null
		Begin				
			If @NewZoneID Is Null
				Begin					
					Insert Into UtilityZone (UtilityID,ZoneID) Values (@UtilityId,@ExistingZoneID)	
					Select @UtilityZoneTableZoneID = @ExistingZoneID
				End
			Else
				Begin					
					Insert Into UtilityZone (UtilityID,ZoneID) Values (@UtilityId,@NewZoneID)	
					Select @UtilityZoneTableZoneID = @NewZoneID			
				End						
		End
		
	Select @UtilityZoneTableZoneID as ZoneId
	
    SET NOCOUNT OFF;
END
