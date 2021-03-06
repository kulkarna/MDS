USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductGreenRuleSetDelete]    Script Date: 03/14/2013 16:41:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductGreenRuleSetDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductGreenRuleSetDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductGreenRuleSetDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductGreenRuleSetDelete
 * Delete green rule records and set by set ID
 *
 * History
 *******************************************************************************
 * 3/14/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductGreenRuleSetDelete]
	@ProductGreenRuleSetID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	DELETE
	FROM	LibertyPower..ProductGreenRule
	WHERE	ProductGreenRuleSetID = @ProductGreenRuleSetID
	
	DELETE
	FROM	LibertyPower..ProductGreenRuleSet
	WHERE	ProductGreenRuleSetID = @ProductGreenRuleSetID	

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
