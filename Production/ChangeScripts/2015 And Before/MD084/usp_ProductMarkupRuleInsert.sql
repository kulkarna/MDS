USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleInsert]    Script Date: 09/13/2012 14:10:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductMarkupRuleInsert]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleInsert]    Script Date: 09/13/2012 14:10:13 ******/
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
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleInsert]  
	@ProductMarkupRuleSetID 	int
	,@ChannelTypeID			int
	,@ChannelGroupID		int
	,@SegmentID				int
	,@MarketID				int
	,@UtilityID				int
	,@ServiceClassID		int
	,@ZoneID				int
	,@ProductTypeID				int
	,@MinTerm				int
	,@MaxTerm				int
	,@Rate					decimal(18,10)
	,@CreatedBy				int
	,@PriceTier				tinyint
	,@ProductTerm				int	
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
			,[ProductTerm])
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
			,@ProductTerm)

SELECT	@@IDENTITY AS ProductMarkupRuleID                                                                                                                        
	
-- Copyright 2010 Liberty Power
' 
END
GO
