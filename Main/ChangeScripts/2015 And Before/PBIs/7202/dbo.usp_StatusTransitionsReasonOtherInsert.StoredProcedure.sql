USE [Lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_StatusTransitionsReasonOtherInsert]    Script Date: 03/07/2013 07:43:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsReasonOtherInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_StatusTransitionsReasonOtherInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsReasonOtherInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_StatusTransitionsReasonOtherInsert
 * Inserts status transitions other reason
 *
 * History
 *******************************************************************************
 * 2/19/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_StatusTransitionsReasonOtherInsert]
	@ReasonID	int,
	@Reason		varchar(500)
AS
BEGIN
    SET NOCOUNT ON;
	
    INSERT INTO StatusTransitionsReasonOther (ReasonID, Reason)
	VALUES		(@ReasonID, @Reason)

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
