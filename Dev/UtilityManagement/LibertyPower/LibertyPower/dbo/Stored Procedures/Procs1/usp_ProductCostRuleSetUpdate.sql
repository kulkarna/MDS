
/*******************************************************************************
 * usp_ProductCostRuleSetUpdate
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetUpdate]  
	@ProductCostRuleSetID		int,
	@EffectiveDate				datetime,  
	@ExpirationDate				DateTime,
	@FileGuid					uniqueidentifier = null,
	@UploadedBy					int = null,
	@UploadedDate				DateTime = null,
	@UploadStatus				int = null
AS
	Update ProductCostRuleSet  
	Set 
		EffectiveDate = @EffectiveDate
		,ExpirationDate = @ExpirationDate
		,FileGuid = Coalesce(@FileGuid, FileGuid) -- if @FileGuid is null then keep original value.
		,UploadedBy = Coalesce(@UploadedBy, UploadedBy)
		,UploadedDate = Coalesce(@UploadedDate, UploadedDate)
		,UploadStatus = Coalesce(@UploadStatus, UploadStatus)
	From ProductCostRuleSet  
	WHERE ProductCostRuleSetID = @ProductCostRuleSetID                                                                                                                                 
	
	
	
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
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetUpdate';

