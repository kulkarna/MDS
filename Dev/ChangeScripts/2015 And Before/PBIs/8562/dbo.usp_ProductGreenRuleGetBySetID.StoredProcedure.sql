USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductGreenRuleGetBySetID]    Script Date: 03/13/2013 16:00:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductGreenRuleGetBySetID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductGreenRuleGetBySetID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductGreenRuleGetBySetID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductGreenRuleGetBySetID
 * Gets green rule records by set ID
 *
 * History
 *******************************************************************************
 * 3/13/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductGreenRuleGetBySetID]
	@ProductGreenRuleSetID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ProductGreenRuleID
			,ProductGreenRuleSetID
			,SegmentID
			,MarketID
			,UtilityID
			,ServiceClassID
			,ZoneID
			,ProductTypeID
			,ProductBrandID
			,StartDate
			,Term
			,Rate
			,CreatedBy
			,DateCreated
			,ISNULL(PriceTier, 0) AS PriceTier
	  FROM	LibertyPower.dbo.ProductGreenRule WITH (NOLOCK)
	  WHERE	ProductGreenRuleSetID = @ProductGreenRuleSetID
	  ORDER BY ProductGreenRuleID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
