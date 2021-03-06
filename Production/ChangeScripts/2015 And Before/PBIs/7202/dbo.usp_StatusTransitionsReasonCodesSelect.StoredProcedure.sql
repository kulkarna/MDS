USE [Lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_StatusTransitionsReasonCodesSelect]    Script Date: 03/07/2013 07:43:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsReasonCodesSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_StatusTransitionsReasonCodesSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsReasonCodesSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_StatusTransitionsReasonCodesSelect
 * Gets status transitions reason codes
 *
 * History
 *******************************************************************************
 * 2/19/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_StatusTransitionsReasonCodesSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, Reason
	FROM	StatusTransitionsReasonCode WITH (NOLOCK)

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
