USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceStageClearOutdated]    Script Date: 01/28/2013 16:42:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceStageClearOutdated]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceStageClearOutdated]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceStageClearOutdated]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_ProductCrossPriceStageClearOutdated
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceStageClearOutdated]  
	@MaxCreatedDate DateTime
AS	

TRUNCATE TABLE libertypower..ProductCrossPrice_stage
	
-- Copyright 2010 Liberty Power
' 
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'VirtualFolder_Path' , N'SCHEMA',N'dbo', N'PROCEDURE',N'usp_ProductCrossPriceStageClearOutdated', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'DailyPricing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'usp_ProductCrossPriceStageClearOutdated'
GO
