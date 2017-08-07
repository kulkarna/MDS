

/*******************************************************************************
* usp_ProductCostRuleSetGetCurrent
*
*******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleSetGetByDate]  
	@Date	datetime
AS
	SELECT  TOP 1 [ProductCostRuleSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
	FROM [LibertyPower].[dbo].[ProductCostRuleSet] WITH (NOLOCK)
	WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, [EffectiveDate])) = @Date	
	ORDER BY UploadedDate Desc    	                                                                                                                              
	
-- Copyright 2010 Liberty Power
