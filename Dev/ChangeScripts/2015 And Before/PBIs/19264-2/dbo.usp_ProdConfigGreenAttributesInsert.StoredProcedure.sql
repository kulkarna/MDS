USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProdConfigGreenAttributesInsert]    Script Date: 11/08/2013 15:56:22 ******/
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
	@PercentageID			int,
	@LocationID				int,
	@RecTypeID				int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@GreenLocationRecTypeID	int
    
    SELECT	@GreenLocationRecTypeID = GreenLocationRecTypeID
    FROM	Libertypower..GreenLocationRecType WITH (NOLOCK)	
    WHERE	LocationID				= @LocationID
    AND		RecTypeID				= @RecTypeID
	
	IF @GreenLocationRecTypeID IS NOT NULL
		BEGIN
			INSERT INTO ProductConfigGreenAttributes (ProductConfigurationID, PercentageID, GreenLocationRecTypeID)
			VALUES		(@ProductConfigurationID, @PercentageID, @GreenLocationRecTypeID)
		END
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
