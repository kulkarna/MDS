USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GreenRecTypesSelect]    Script Date: 11/08/2013 15:56:22 ******/
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
   
	SELECT	g.ID, g.RecType, l.ID AS LocationID
	FROM	LibertyPower..GreenRecType g WITH (NOLOCK)
			INNER JOIN GreenLocationRecType t WITH (NOLOCK) ON g.ID = t.RecTypeID
			INNER JOIN GreenLocation l WITH (NOLOCK) ON l.ID = t.LocationID	
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
