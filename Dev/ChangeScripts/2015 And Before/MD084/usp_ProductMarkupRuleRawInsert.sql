USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleRawInsert]    Script Date: 09/13/2012 14:12:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleRawInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductMarkupRuleRawInsert]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductMarkupRuleRawInsert]    Script Date: 09/13/2012 14:12:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductMarkupRuleRawInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * [usp_ProductMarkupRuleRawInsert]
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleRawInsert]  
	@ProductMarkupRuleSetID 	int
	,@ChannelType				varchar(50)
	,@Market					varchar(50)
	,@Utility					varchar(50)
	,@ChannelGroup				varchar(50)
	,@Segment					varchar(50)
	,@Product					varchar(50)
	,@Zone						varchar(50)
	,@UtilityServiceClass		varchar(50)
	,@MinTerm					int
	,@MaxTerm					int
	,@Rate						decimal(18,10)
	,@CreatedBy					int
	,@PriceTier					tinyint
	,@ProductTerm				int
AS

INSERT INTO [LibertyPower].[dbo].[ProductMarkupRuleRaw]
           ([ProductMarkupRuleSetID]
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
			,[ProductTerm])
     VALUES
           (@ProductMarkupRuleSetID 	
			,@ChannelType				
			,@Market					
			,@Utility					
			,@ChannelGroup				
			,@Segment		
			,@Product					
			,@Zone						
			,@UtilityServiceClass		
			,@MinTerm					
			,@MaxTerm					
			,@Rate						
			,@CreatedBy					
			,getdate()
			,@PriceTier
			,@ProductTerm)

SELECT	@@IDENTITY AS ProductMarkupRuleRawID
                                                                                                                    	
-- Copyright 2010 Liberty Power
' 
END
GO
