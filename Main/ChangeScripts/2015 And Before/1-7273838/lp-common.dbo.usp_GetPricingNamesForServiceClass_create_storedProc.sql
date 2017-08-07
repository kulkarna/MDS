USE [lp_common]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev A. Rosenblum
-- Create date: 11/12/2012
-- Description:	getting the DisplayName from ProductCostRuleSetup table
-- by @UtilityId and @ServiceClassId
-- =============================================
CREATE PROCEDURE dbo.usp_GetPricingNamesForServiceClass
(
	@UtilityId int
	, @ServiceClassId int
)

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
		AND Utility=@UtilityId AND ServiceClass=@ServiceClassId 
END
GO
