USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleRawGetById]    Script Date: 09/13/2012 14:10:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleRawGetById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductMarkupRuleRawGetById]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleRawGetById]    Script Date: 09/13/2012 14:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleRawGetById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * [usp_ProductMarkupRuleRawGetById]
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleRawGetById]  
	@ProductMarkupRuleRawID					int
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
	FROM [LibertyPower].[dbo].[ProductMarkupRuleRaw] WITH (NOLOCK)
	WHERE [ProductMarkupRuleRawID] = @ProductMarkupRuleRawID                                                                                                                           
	
-- Copyright 2010 Liberty Power
' 
END
GO
