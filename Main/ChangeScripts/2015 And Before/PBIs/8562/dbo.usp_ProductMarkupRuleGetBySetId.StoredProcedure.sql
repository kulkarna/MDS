USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleGetBySetId]    Script Date: 03/13/2013 16:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleGetBySetId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductMarkupRuleGetBySetId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleGetBySetId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductMarkupRuleGetBySetId
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added product brand field  
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleGetBySetId]  
	@ProductMarkupRuleSetID					int
AS
	SELECT [ProductMarkupRuleID]
	  ,[ProductMarkupRuleSetID]
	  ,[ChannelTypeID]
	  ,[ChannelGroupID]
	  ,[SegmentID]
	  ,[MarketID]
	  ,[UtilityID]
	  ,[ServiceClassID]
	  ,[ZoneID]
	  ,[ProductTypeID]
	  ,[MinTerm]
	  ,[MaxTerm]
	  ,[Rate]
	  ,[CreatedBy]
	  ,[DateCreated]
	  ,[PriceTier]
	  ,[ProductTerm]
	  ,[ProductBrandID]
	FROM [LibertyPower].[dbo].[ProductMarkupRule] WITH (NOLOCK)
	WHERE [ProductMarkupRuleSetID] = @ProductMarkupRuleSetID                                                                                                                            
	
-- Copyright 2010 Liberty Power
' 
END
GO
