USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelMultiTermSelect]    Script Date: 09/13/2012 08:27:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SalesChannelMultiTermSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SalesChannelMultiTermSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelMultiTermSelect]    Script Date: 09/13/2012 08:27:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SalesChannelMultiTermSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_SalesChannelMultiTermSelect
 * Selects multi-term product access records for channel
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelMultiTermSelect]
	@ChannelID	int
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	t.ID, t.ChannelID, t.UtilityID, u.UtilityCode 
	FROM	Libertypower..SalesChannelMultiTerm t WITH (NOLOCK) 
			INNER JOIN Libertypower..Utility u WITH (NOLOCK) 
			ON t.UtilityID = u.ID
	WHERE	ChannelID	= @ChannelID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


' 
END
GO
