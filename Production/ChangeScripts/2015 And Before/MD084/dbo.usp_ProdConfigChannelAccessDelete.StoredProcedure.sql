USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProdConfigChannelAccessDelete]    Script Date: 09/26/2012 13:58:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigChannelAccessDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProdConfigChannelAccessDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigChannelAccessDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_ProdConfigChannelAccessDelete
 * Deletes multi-term product access records for prod config
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigChannelAccessDelete]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;

	DELETE FROM	Libertypower..ProdConfigChannelAccess
	WHERE	ProductConfigurationID = @ProductConfigurationID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


' 
END
GO
