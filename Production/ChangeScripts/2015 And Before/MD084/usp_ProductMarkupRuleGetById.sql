USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleGetById]    Script Date: 09/13/2012 14:08:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleGetById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductMarkupRuleGetById]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleGetById]    Script Date: 09/13/2012 14:08:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleGetById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductMarkupRuleGetById
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleGetById]  
	@ProductMarkupRuleID					int
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
	FROM [LibertyPower].[dbo].[ProductMarkupRule] WITH (NOLOCK)
	WHERE [ProductMarkupRuleID] = @ProductMarkupRuleID                                                                                                                            
	
-- Copyright 2010 Liberty Power
' 
END
GO
