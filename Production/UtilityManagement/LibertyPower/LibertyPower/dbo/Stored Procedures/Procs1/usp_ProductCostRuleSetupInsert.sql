

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

