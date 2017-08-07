
CREATE PROCEDURE [dbo].[usp_VRE_BillingTransactionCostCurveSelect]
	@ContextDate	DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, BillingType, Cost, CreatedBy,
			FileContextGuid, DateCreated
    FROM	VREBillingTransactionCostCurve a WITH (NOLOCK)
	WHERE	a.ID in ( 
					 SELECT TOP 1 p.ID
					 FROM VREBillingTransactionCostCurve p
					 WHERE	a.BillingType = p.BillingType
					 AND	(@ContextDate IS NULL OR a.DateCreated < @ContextDate)
					 ORDER BY DateCreated DESC
				   )
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_BillingTransactionCostCurveSelect';

