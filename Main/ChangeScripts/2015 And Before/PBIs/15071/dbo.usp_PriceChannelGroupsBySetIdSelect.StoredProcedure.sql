USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PriceChannelGroupsBySetIdSelect]    Script Date: 07/12/2013 15:14:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceChannelGroupsBySetIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PriceChannelGroupsBySetIdSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceChannelGroupsBySetIdSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_PriceChannelGroupsBySetIdSelect
 * Gets channel groups for specified product cross price set id
 *
 * History
 *******************************************************************************
 * 7/10/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceChannelGroupsBySetIdSelect]
	@ProductCrossPriceSetID	int
AS
BEGIN
    SET NOCOUNT ON;
	
	SELECT	DISTINCT ChannelGroupID, UtilityID
	FROM	Libertypower..Price WITH (NOLOCK)
	WHERE	ProductCrossPriceSetID = @ProductCrossPriceSetID
	ORDER BY ChannelGroupID, UtilityID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
