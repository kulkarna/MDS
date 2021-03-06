USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceSetUpdate]    Script Date: 04/11/2013 11:32:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceSetUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceSetUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceSetUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductCrossPriceSetUpdate
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetUpdate]  
	@ProductCrossPriceSetID					int,
	@EffectiveDate							datetime,  
	@ExpirationDate							datetime, 
	@CreatedBy								int = null,
	@DateCreated							DateTime = null
AS


	Update [LibertyPower].[dbo].[ProductCrossPriceSet]
	Set 
		EffectiveDate = @EffectiveDate
		,ExpirationDate = @ExpirationDate
		,CreatedBy = Coalesce(@CreatedBy, CreatedBy)
		,DateCreated = Coalesce(@DateCreated, DateCreated)
	WHERE ProductCrossPriceSetID = @ProductCrossPriceSetID   

	SELECT [ProductCrossPriceSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[CreatedBy]
      ,[DateCreated]
	FROM [LibertyPower].[dbo].[ProductCrossPriceSet]  WITH (NOLOCK)
	WHERE [ProductCrossPriceSetID] = @ProductCrossPriceSetID                                                                                                                                
	
-- Copyright 2010 Liberty Power

' 
END
GO
