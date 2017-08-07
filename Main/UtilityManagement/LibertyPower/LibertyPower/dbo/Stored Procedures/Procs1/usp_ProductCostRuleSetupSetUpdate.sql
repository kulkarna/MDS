
/*******************************************************************************
 * usp_ProductCostRuleSetupSetUpdate
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetupSetUpdate]  
	@ProductCostRuleSetupSetID		int,
	@FileGuid					uniqueidentifier = null,
	@UploadedBy					int = null,
	@UploadedDate				DateTime = null,
	@UploadStatus				int = null
AS
	Update ProductCostRuleSetupSet  
	Set 
		FileGuid = Coalesce(@FileGuid, FileGuid) -- if @FileGuid is null then keep original value.
		,UploadedBy = Coalesce(@UploadedBy, UploadedBy)
		,UploadedDate = Coalesce(@UploadedDate, UploadedDate)
		,UploadStatus = Coalesce(@UploadStatus, UploadStatus)
	From ProductCostRuleSetupSet  
	WHERE ProductCostRuleSetupSetID = @ProductCostRuleSetupSetID                                                                                                                                 
	
	
	
	SELECT [ProductCostRuleSetupSetID]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
	FROM [LibertyPower].[dbo].[ProductCostRuleSetupSet] 
	WHERE ProductCostRuleSetupSetID = @ProductCostRuleSetupSetID  
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetupSetUpdate';

