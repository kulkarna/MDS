
CREATE PROCEDURE [dbo].[usp_VRE_FinanceFeeCurveSelect]
	@ContextDate	DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT	ID, Market, Fee, a.CreatedBy, a.DateCreated, a.FileContextGuid
    FROM	VREFinanceFeeCurve a WITH (NOLOCK)
	WHERE	a.ID in ( 
									SELECT TOP 1 p.ID
									FROM VREFinanceFeeCurve p
									WHERE a.Market = p.Market
									AND		(@ContextDate IS NULL OR a.DateCreated < @ContextDate)
									ORDER BY p.DateCreated DESC
								   );
    

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_FinanceFeeCurveSelect';

