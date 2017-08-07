USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductConfigurationPricesInsert]    Script Date: 09/17/2012 17:20:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductConfigurationPricesInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductConfigurationPricesInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductConfigurationPricesInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductConfigurationPricesInsert
 * Inserts product confoguration and price mapping record
 *
 * History
 *******************************************************************************
 * 9/17/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationPricesInsert]
	@ProductConfigurationID	int,
	@PriceID				bigint
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	bigint
    
    INSERT INTO	ProductConfigurationPrices (ProductConfigurationID, PriceID)
    VALUES		(@ProductConfigurationID, @PriceID)
    
    SET	@ID = SCOPE_IDENTITY()
    
    SELECT	ID, ProductConfigurationID, PriceID
    FROM	ProductConfigurationPrices WITH (NOLOCK)
    WHERE	ID = @ID
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
' 
END
GO
