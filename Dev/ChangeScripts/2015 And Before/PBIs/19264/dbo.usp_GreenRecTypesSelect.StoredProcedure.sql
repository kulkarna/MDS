USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GreenRecTypesSelect]    Script Date: 09/20/2013 11:35:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GreenRecTypesSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GreenRecTypesSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GreenRecTypesSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_GreenRecTypesSelect
 * Gets green REC types
 *
 * History
 *******************************************************************************
 * 9/17/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GreenRecTypesSelect]

AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ID, LocationID, RecType
	FROM	LibertyPower..GreenRecType WITH (NOLOCK)
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
