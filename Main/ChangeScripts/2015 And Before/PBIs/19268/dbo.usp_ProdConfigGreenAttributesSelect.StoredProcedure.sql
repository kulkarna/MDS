USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProdConfigGreenAttributesSelect]    Script Date: 10/10/2013 10:19:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigGreenAttributesSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProdConfigGreenAttributesSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigGreenAttributesSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProdConfigGreenAttributesSelect
 * Gets green attributes for product configuration
 * @ProductConfigurationID = -1 returns all records
 *
 * History
 *******************************************************************************
 * 9/17/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigGreenAttributesSelect]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ID, ProductConfigurationID, Percentage, LocationID, RecTypeID
	FROM	Libertypower..ProdConfigGreenAttributes WITH (NOLOCK)
	WHERE	ProductConfigurationID = CASE WHEN @ProductConfigurationID = -1 THEN ProductConfigurationID ELSE @ProductConfigurationID END
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
