USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleInsert]    Script Date: 03/13/2013 16:07:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductMarkupRuleInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductMarkupRuleInsert
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added product brand field  
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleInsert]  
	@ProductMarkupRuleSetID int
	,@ChannelTypeID			int
	,@ChannelGroupID		int
	,@SegmentID				int
	,@MarketID				int
	,@UtilityID				int
	,@ServiceClassID		int
	,@ZoneID				int
	,@ProductTypeID			int
	,@MinTerm				int
	,@MaxTerm				int
	,@Rate					decimal(18,10)
	,@CreatedBy				int
	,@PriceTier				tinyint
	,@ProductTerm			int				= NULL
	,@ProductBrandID		int				= -1
AS

INSERT INTO [LibertyPower].[dbo].[ProductMarkupRule]
           ([ProductMarkupRuleSetID]
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
			,[ProductBrandID])
     VALUES
           (@ProductMarkupRuleSetID
			,@ChannelTypeID
			,@ChannelGroupID
			,@SegmentID		
			,@MarketID		
			,@UtilityID		
			,@ServiceClassID	
			,@ZoneID		
			,@ProductTypeID		
			,@MinTerm
			,@MaxTerm
			,@Rate	
			,@CreatedBy		
			,getDate()
			,@PriceTier
			,@ProductTerm
			,@ProductBrandID)

SELECT	SCOPE_IDENTITY() AS ProductMarkupRuleID                                                                                                                        
	
-- Copyright 2010 Liberty Power
' 
END
GO
