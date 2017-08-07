-- =============================================
-- Author:		Lev A. Rosenblum
-- Create date: 11/9/2012
-- Description:	getting the DisplayName from ProductCostRuleSetup table
-- by @UtilityId and @ServiceClassId and @SegmentId and @ZoneId and @ProductTypeId
-- =============================================
CREATE PROCEDURE usp_GetServiceClassDisplayNameFromProductCostRuleSetupTable
	@UtilityId int
	, @ServiceClassId int
	, @SegmentId int
	, @ZoneId int
	, @ProductTypeId int
AS
BEGIN

	SET NOCOUNT ON;
	SELECT DISTINCT ServiceClassDisplayName 
	FROM [Libertypower].[dbo].[ProductCostRuleSetup] a with (nolock)
	WHERE ProductCostRuleSetupSetID=
	(
		SELECT MAX(b.ProductCostRuleSetupSetID) 
		FROM [Libertypower].[dbo].[ProductCostRuleSetup] b with (nolock)
		WHERE b.Utility=a.Utility and b.ServiceClass=a.ServiceClass and b.Segment=a.Segment 
			and b.Zone=a.Zone and b.ProductType=a.ProductType
	)
		AND Utility=@UtilityId AND ServiceClass=@ServiceClassId AND Segment=@SegmentId 
		AND Zone=@ZoneId AND ProductType=@ProductTypeId
END
