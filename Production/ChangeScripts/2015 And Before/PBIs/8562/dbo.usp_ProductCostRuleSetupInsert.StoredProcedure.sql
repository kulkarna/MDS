USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCostRuleSetupInsert]    Script Date: 04/12/2013 12:26:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCostRuleSetupInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCostRuleSetupInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCostRuleSetupInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_ProductCostRuleSetupInsert
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleSetupInsert]  
		@Segment					int,
		@ProductType				int,
		@Market						int,
		@Utility					int,
		@Zone						int,
		@ServiceClass				int,
		@MaxRelativeStartMonth	    int,
		@MaxTerm					int,
		@LowCostRate				Decimal(18,10),
		@HighCostRate				Decimal(18,10),
		@InsertedBy		       		int,
		@PorRate		       		Decimal(18,10),
		@GrtRate		       		Decimal(18,10),
		@SutRate		       		Decimal(18,10),
		@ProductCostRuleSetupSetID  int,
		@ServiceClassDisplayName	varchar(50),
		@PriceTier					tinyint,
		@ProductBrandID				int	= 0

AS

	Declare @ProductCostRuleSetupID int

	INSERT INTO ProductCostRuleSetup
	( [Segment]
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
      ,[ProductBrandID])
	VALUES 
	(	@Segment,
		@ProductType,
		@Market,
		@Utility,
		@Zone,
		@ServiceClass,
		@MaxRelativeStartMonth,
		@MaxTerm,
		@LowCostRate,
		@HighCostRate,
		GETDATE(),
		@InsertedBy,
		@PorRate,
		@GrtRate,
		@SutRate,
		@ProductCostRuleSetupSetID,
		@ServiceClassDisplayName,
		@PriceTier,
		@ProductBrandID )

	set @ProductCostRuleSetupID = SCOPE_IDENTITY()


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
	WHERE ID = @ProductCostRuleSetupID                                                                                                                                 
	
-- Copyright 2010 Liberty Power

' 
END
GO
