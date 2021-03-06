USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GreenPercentagesSelect]    Script Date: 11/08/2013 15:56:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GreenPercentagesSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GreenPercentagesSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GreenPercentagesSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_GreenPercentagesSelect
 * Gets green percentages
 *
 * History
 *******************************************************************************
 * 9/17/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GreenPercentagesSelect]

AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ID, [Percent]
	FROM	LibertyPower..GreenPercentage WITH (NOLOCK)
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
