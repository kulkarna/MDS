USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleRawGetBySetId]    Script Date: 03/13/2013 16:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleRawGetBySetId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductMarkupRuleRawGetBySetId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleRawGetBySetId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * [usp_ProductMarkupRuleRawGetBySetId]
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added product brand field  
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleRawGetBySetId]  
	@ProductMarkupRuleSetID				int
AS
	SELECT  [ProductMarkupRuleRawID]
      ,[ProductMarkupRuleSetID]
      ,[ChannelType]
      ,[MarketCode]
      ,[UtilityCode]
      ,[ChannelGroup]
      ,[Segment]
      ,[Product]
      ,[Zone]
      ,[UtilityServiceClass]
      ,[minTerm]
      ,[maxTerm]
      ,[Rate]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[PriceTier]
      ,[ProductTerm]
      ,[ProductBrandID]
	FROM [LibertyPower].[dbo].[ProductMarkupRuleRaw] WITH (NOLOCK)
	WHERE [ProductMarkupRuleSetID] = @ProductMarkupRuleSetID                                                                                                                           
	
-- Copyright 2010 Liberty Power
' 
END
GO
