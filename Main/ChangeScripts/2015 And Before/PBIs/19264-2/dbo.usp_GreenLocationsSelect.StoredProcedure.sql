USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GreenLocationsSelect]    Script Date: 11/08/2013 15:56:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GreenLocationsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GreenLocationsSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GreenLocationsSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_GreenLocationsSelect
 * Gets green locations
 *
 * History
 *******************************************************************************
 * 9/17/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GreenLocationsSelect]

AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ID, Location
	FROM	LibertyPower..GreenLocation WITH (NOLOCK)
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
