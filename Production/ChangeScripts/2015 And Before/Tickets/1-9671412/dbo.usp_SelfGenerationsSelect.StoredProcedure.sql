USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_SelfGenerationsSelect]    Script Date: 11/05/2012 11:58:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SelfGenerationsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SelfGenerationsSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SelfGenerationsSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_SelfGenerationsSelect
 * Gets self generation records
 *
 * History
 *******************************************************************************
 * 11/5/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SelfGenerationsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, Name
    FROM	SelfGeneration WITH (NOLOCK)
    ORDER BY ID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
