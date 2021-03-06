USE [Lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_StatusTransitionsSelect]    Script Date: 03/07/2013 07:43:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_StatusTransitionsSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_StatusTransitionsSelect
 * Gets status transitions for status and sub staus
 *
 * History
 *******************************************************************************
 * 2/15/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_StatusTransitionsSelect]
	@Status		varchar(15),
	@SubStatus	varchar(15)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, OldStatus, OldSubStatus, NewStatus, NewSubStatus, 
			RequiresStartDate, RequiresEndDate, DateCreated, 
			(NewStatus + ''-'' + status_descp) AS NewStatusDesc, 
			(NewSubStatus + ''-'' + sub_status_descp) AS NewSubStatusDesc,
			ActiveFrom, ActiveTo
	FROM	lp_enrollment..StatusTransitions t WITH (NOLOCK)
			INNER JOIN lp_account..enrollment_status s WITH (NOLOCK)
			ON t.NewStatus = s.status
			INNER JOIN lp_account..enrollment_sub_status ss WITH (NOLOCK)
			ON t.NewStatus = ss.status AND t.NewSubStatus = ss.sub_status		
	WHERE	OldStatus		= @Status
	AND		OldSubStatus	= @SubStatus
	AND		GETDATE() BETWEEN ActiveFrom AND ActiveTo

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
