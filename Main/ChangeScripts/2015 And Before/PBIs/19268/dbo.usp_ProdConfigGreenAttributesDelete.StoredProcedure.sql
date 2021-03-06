USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProdConfigGreenAttributesDelete]    Script Date: 10/10/2013 10:19:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigGreenAttributesDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProdConfigGreenAttributesDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigGreenAttributesDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProdConfigGreenAttributesDelete
 * Deletes green attributes for product configuration
 *
 * History
 *******************************************************************************
 * 9/17/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigGreenAttributesDelete]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;
   
	DELETE
	FROM	Libertypower..ProdConfigGreenAttributes
	WHERE	ProductConfigurationID = @ProductConfigurationID
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
