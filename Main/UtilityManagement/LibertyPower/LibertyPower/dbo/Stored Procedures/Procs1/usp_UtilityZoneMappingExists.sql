

CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingExists]
	@UtilityID	int,
	@DriverFieldName varchar(50),
	@DriverValue varchar(50)
AS
BEGIN
    SET NOCOUNT ON;         

    Declare @ssql varchar(500)
    Set @ssql='SELECT Top 1 ID FROM UtilityZoneMapping WITH (NOLOCK) WHERE UtilityID = ' + CAST(@UtilityID AS varchar(50)) + ' And ' +    
    @DriverFieldName + ' = ' + '''' + @DriverValue + ''''
    
	
	--Print @ssql
	exec (@ssql);
    SET NOCOUNT OFF;
END
