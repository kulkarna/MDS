USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceBulkLoad]    Script Date: 01/28/2013 17:17:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceBulkLoad]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceBulkLoad]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceBulkLoad]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_ProductCrossPriceBulkLoad
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceBulkLoad]  
	@PriceSetId int
AS

--1) Load/copy data from stage table to production table
insert into libertypower..ProductCrossPrice
Select * from libertypower..ProductCrossPrice_stage (NoLock)
Where [ProductCrossPriceSetID] = @PriceSetId

--2) Delete data copied data from stage table
TRUNCATE TABLE libertypower..ProductCrossPrice_stage
	
-- Copyright 2010 Liberty Power
' 
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'VirtualFolder_Path' , N'SCHEMA',N'dbo', N'PROCEDURE',N'usp_ProductCrossPriceBulkLoad', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'DailyPricing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'usp_ProductCrossPriceBulkLoad'
GO
