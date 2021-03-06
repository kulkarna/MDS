USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceSetIdForArchivingSelect]    Script Date: 08/28/2012 16:39:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceSetIdForArchivingSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceSetIdForArchivingSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceSetIdForArchivingSelect]    Script Date: 08/28/2012 16:39:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceSetIdForArchivingSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductCrossPriceSetIdForArchivingSelect
 *
 * Gets product cross price set ids that are ready for archiving
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetIdForArchivingSelect]  
	
AS

SELECT	DISTINCT ProductCrossPriceSetID
FROM	Libertypower..ProductCrossPrice WITH (NOLOCK)
WHERE	CostRateExpirationDate < GETDATE()
	
-- Copyright 2010 Liberty Power
' 
END
GO
