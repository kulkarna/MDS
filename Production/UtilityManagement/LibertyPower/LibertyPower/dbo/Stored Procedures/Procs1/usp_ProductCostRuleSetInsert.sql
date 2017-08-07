

/*******************************************************************************
 * usp_ProductCostRuleSetInsert
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetInsert]  
	@EffectiveDate				DateTime,   
	@ExpirationDate				DateTime,
	@FileGuid					uniqueidentifier,
	@UploadedBy					int,
	@UploadStatus				int

AS

	Declare @ProductCostRuleSetID int

	INSERT INTO ProductCostRuleSet
	(EffectiveDate, ExpirationDate, FileGuid, UploadedBy, UploadedDate, UploadStatus)
	VALUES 
	(@EffectiveDate, @ExpirationDate, @FileGuid, @UploadedBy, getdate(), @UploadStatus)

	set @ProductCostRuleSetID = @@Identity


	SELECT [ProductCostRuleSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
	FROM [LibertyPower].[dbo].[ProductCostRuleSet]
	WHERE ProductCostRuleSetID = @ProductCostRuleSetID                                                                                                                                 
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetInsert';

