CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingLossFactorExists]
	@UtilityId int = null,
	@UtilityCode varchar(50) = null
AS
BEGIN
    SET NOCOUNT ON;
    
    If @UtilityId is null    
		Select @UtilityId = U.ID From Utility U Where UtilityCode = @UtilityCode
		
	Select 
		Top 1 ID
	From
		UtilityZoneMapping
	Where
		UtilityID = @UtilityId
		And
		(LossFactor > 0)

    SET NOCOUNT OFF;
END


