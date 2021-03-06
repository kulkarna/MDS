USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceSetDelete]    Script Date: 08/28/2012 16:41:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceSetDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceSetDelete]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceSetDelete]    Script Date: 08/28/2012 16:41:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceSetDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductCrossPriceSetDelete
 *
 * Deletes cross price set for specified ID
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetDelete]  
	@ProductCrossPriceSetID	int
AS

DELETE
FROM	Libertypower..ProductCrossPrice
WHERE	ProductCrossPriceSetID = @ProductCrossPriceSetID
	
-- Copyright 2010 Liberty Power
' 
END
GO
