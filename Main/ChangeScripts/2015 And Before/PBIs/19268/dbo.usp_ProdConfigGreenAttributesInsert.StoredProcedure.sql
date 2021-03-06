USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProdConfigGreenAttributesInsert]    Script Date: 10/10/2013 10:19:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigGreenAttributesInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProdConfigGreenAttributesInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigGreenAttributesInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProdConfigGreenAttributesInsert
 * Inserts green attributes for product configuration
 *
 * History
 *******************************************************************************
 * 9/17/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigGreenAttributesInsert]
	@ProductConfigurationID	int,
	@Percentage				decimal(5,2),
	@LocationID				int,
	@RecTypeID				int
AS
BEGIN
    SET NOCOUNT ON;
   
	INSERT INTO ProdConfigGreenAttributes (ProductConfigurationID, Percentage, LocationID, RecTypeID)
	VALUES		(@ProductConfigurationID, @Percentage, @LocationID, @RecTypeID)
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
