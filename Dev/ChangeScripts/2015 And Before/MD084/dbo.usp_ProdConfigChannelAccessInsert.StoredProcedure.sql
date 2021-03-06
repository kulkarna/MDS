USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProdConfigChannelAccessInsert]    Script Date: 09/26/2012 13:58:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigChannelAccessInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProdConfigChannelAccessInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProdConfigChannelAccessInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_ProdConfigChannelAccessInsert
 * Inserts multi-term product access record for channel and prod config
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigChannelAccessInsert]
	@ProductConfigurationID	int,
	@ChannelID				int
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS	(	
						SELECT	1 
						FROM	Libertypower..ProdConfigChannelAccess WITH (NOLOCK) 
						WHERE	ProductConfigurationID	= @ProductConfigurationID
						AND		ChannelID				= @ChannelID
					)
		BEGIN
			INSERT INTO	Libertypower..ProdConfigChannelAccess (ProductConfigurationID, ChannelID)
			VALUES		(@ProductConfigurationID, @ChannelID)
		END

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


' 
END
GO
