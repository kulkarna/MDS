USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCostRuleSetupGetBySetId]    Script Date: 04/12/2013 12:26:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCostRuleSetupGetBySetId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCostRuleSetupGetBySetId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCostRuleSetupGetBySetId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductCostRuleSetupGetBySetId
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleSetupGetBySetId]  
	@ProductCostRuleSetupSetID					int
AS
	SELECT [ID]
      ,[Segment]
      ,[ProductType]
      ,[Market]
      ,[Utility]
      ,[Zone]
      ,[ServiceClass]
      ,[MaxRelativeStartMonth]
      ,[MaxTerm]
      ,[LowCostRate]
      ,[HighCostRate]
      ,[DateInserted]
      ,[InsertedBy]
      ,[PorRate]
      ,[GrtRate]
      ,[SutRate]
      ,[ProductCostRuleSetupSetID]
      ,[ServiceClassDisplayName]
      ,[PriceTier]
      ,[ProductBrandID]
	FROM [LibertyPower].[dbo].[ProductCostRuleSetup] WITH (NOLOCK)
	WHERE ProductCostRuleSetupSetID = @ProductCostRuleSetupSetID                                                                                                                                 
	
-- Copyright 2010 Liberty Power

' 
END
GO
