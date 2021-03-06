USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelMultiTermInsert]    Script Date: 09/13/2012 08:26:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SalesChannelMultiTermInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SalesChannelMultiTermInsert]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelMultiTermInsert]    Script Date: 09/13/2012 08:26:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SalesChannelMultiTermInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_SalesChannelMultiTermInsert
 * Inserts multi-term product access record for channel and utility
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelMultiTermInsert]
	@ChannelID	int,
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS	(	
						SELECT	1 
						FROM	Libertypower..SalesChannelMultiTerm WITH (NOLOCK) 
						WHERE	ChannelID	= @ChannelID
						AND		UtilityID	= @UtilityID
					)
		BEGIN
			INSERT INTO	Libertypower..SalesChannelMultiTerm (ChannelID, UtilityID)
			VALUES		(@ChannelID, @UtilityID)
		END

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


' 
END
GO
