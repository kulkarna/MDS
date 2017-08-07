CREATE	PROCEDURE	[dbo].[usp_UtilityBillingTypeList]
		
AS

BEGIN
	SELECT	BillingTypeID, [Description]
	FROM LibertyPower.dbo.BillingType
	Where active = 1
END
