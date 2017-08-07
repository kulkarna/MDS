
Create PROCEDURE [dbo].[usp_UtilityIDUtilityCodeListSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	Select
		ID,
		UtilityCode
	From
		LibertyPower.dbo.Utility			

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

