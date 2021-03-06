USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceSetGetByDate]    Script Date: 03/12/2013 16:21:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceSetGetByDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceSetGetByDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceSetGetByDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_ProductCrossPriceSetGetByDate
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetGetByDate]  
	@EffectiveDate			DateTime
AS
	SELECT TOP 1 [ProductCrossPriceSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[DateCreated]
      ,[CreatedBy]
	FROM [LibertyPower].[dbo].[ProductCrossPriceSet]  WITH (NOLOCK)
	WHERE @EffectiveDate BETWEEN [EffectiveDate] AND [ExpirationDate]
	ORDER BY [ProductCrossPriceSetID] DESC

	
-- Copyright 2010 Liberty Power

' 
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'VirtualFolder_Path' , N'SCHEMA',N'dbo', N'PROCEDURE',N'usp_ProductCrossPriceSetGetByDate', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'DailyPricing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'usp_ProductCrossPriceSetGetByDate'
GO
