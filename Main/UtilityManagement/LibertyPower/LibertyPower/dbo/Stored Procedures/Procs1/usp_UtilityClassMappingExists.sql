

CREATE PROCEDURE [dbo].[usp_UtilityClassMappingExists]
	@UtilityID	int,
	@DriverFieldName varchar(50),
	@DriverValue varchar(50)	
AS
BEGIN
    SET NOCOUNT ON;
            
    -- Figure out the ID of whatever determinant was passed in
    Declare @DeterminantID int
    Set @DeterminantID = 0
    
    Set @DeterminantID = 
    CASE @DriverFieldName
		WHEN 'CustomerType'   THEN (Select ID FROM AccountType  WITH (NOLOCK) WHERE AccountType      = @DriverValue)
		WHEN 'LoadProfileID'  THEN (Select ID FROM LoadProfile  WITH (NOLOCK) WHERE LoadProfileCode  = @DriverValue)
		WHEN 'LoadShapeID'    THEN (Select ID FROM LoadShape    WITH (NOLOCK) WHERE LoadShapeCode    = @DriverValue)
		WHEN 'MeterTypeID'    THEN (Select ID FROM MeterType    WITH (NOLOCK) WHERE MeterTypeCode    = @DriverValue)
		WHEN 'RateClassID'    THEN (Select ID FROM RateClass    WITH (NOLOCK) WHERE RateClassCode    = @DriverValue)
		WHEN 'ServiceClassID' THEN (Select ID FROM ServiceClass WITH (NOLOCK) WHERE ServiceClassCode = @DriverValue)
		WHEN 'TariffCodeID'   THEN (Select ID FROM TariffCode   WITH (NOLOCK) WHERE Code             = @DriverValue)
		WHEN 'Voltage'        THEN (Select ID FROM Voltage      WITH (NOLOCK) WHERE VoltageCode      = @DriverValue)
		WHEN 'Zone'           THEN (Select ID FROM Zone         WITH (NOLOCK) WHERE ZoneCode         = @DriverValue)
	END
			
    Declare @ssqlMain varchar(500)    
    Set @ssqlMain='SELECT Top 1 ID FROM UtilityClassMapping WITH (NOLOCK) WHERE UtilityID = ' + CAST(@UtilityID AS varchar(50)) + ' And ' +
    
    @DriverFieldName + ' = ' + CAST(@DeterminantID AS varchar(50)) 
		
	exec (@ssqlMain);

    SET NOCOUNT OFF;
END
