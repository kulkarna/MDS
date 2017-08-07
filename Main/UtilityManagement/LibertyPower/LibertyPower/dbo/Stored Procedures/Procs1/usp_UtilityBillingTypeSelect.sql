CREATE	PROCEDURE	[dbo].[usp_UtilityBillingTypeSelect]
		@Utility	VARCHAR(50)
AS

BEGIN
	SELECT	ub.BillingTypeID, b.Type, b.Description
	FROM	UtilityBillingType ub
	INNER	JOIN BillingType b
	ON		ub.BillingTypeID = b.BillingTypeID
	INNER	JOIN Utility u
	ON		u.ID = ub.UtilityID
	WHERE	u.UtilityCode = @Utility
	AND		b.Active = 1
	
END

