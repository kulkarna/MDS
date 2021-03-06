USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelMultiTermByUtilityDelete]    Script Date: 09/13/2012 08:25:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SalesChannelMultiTermByUtilityDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SalesChannelMultiTermByUtilityDelete]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelMultiTermByUtilityDelete]    Script Date: 09/13/2012 08:25:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SalesChannelMultiTermByUtilityDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_SalesChannelMultiTermByUtilityDelete
 * Deletes multi-term product access records for utility
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelMultiTermByUtilityDelete]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;

	DELETE FROM	Libertypower..SalesChannelMultiTerm
	WHERE	UtilityID = @UtilityID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


' 
END
GO
