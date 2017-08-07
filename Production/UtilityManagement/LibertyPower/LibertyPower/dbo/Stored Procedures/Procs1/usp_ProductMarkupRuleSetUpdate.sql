

/*******************************************************************************
 * usp_ProductMarkupRuleSetUpdate
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductMarkupRuleSetUpdate]  
	@ProductMarkupRuleSetID		int,
	@EffectiveDate				datetime,  
	@FileGuid					uniqueidentifier = null,
	@UploadedBy					int = null,
	@UploadedDate				DateTime = null,
	@UploadStatus				int = null
AS
	Update ProductMarkupRuleSet  
	
	Set 
		EffectiveDate = @EffectiveDate
		,FileGuid = Coalesce(@FileGuid, FileGuid) -- if @FileGuid is null then keep original value.
		,UploadedBy = Coalesce(@UploadedBy, UploadedBy)
		,UploadedDate = Coalesce(@UploadedDate, UploadedDate)
		,UploadStatus = Coalesce(@UploadStatus, UploadStatus)
	From ProductMarkupRuleSet  
	WHERE ProductMarkupRuleSetID = @ProductMarkupRuleSetID                                                                                                                                 
	
	
	
	SELECT [ProductMarkupRuleSetID]
      ,[EffectiveDate]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
	FROM [LibertyPower].[dbo].[ProductMarkupRuleSet] 
	WHERE ProductMarkupRuleSetID = @ProductMarkupRuleSetID                                                                                                                           
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductMarkupRuleSetUpdate';

