USE [Lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_StatusTransitionsReasonInsert]    Script Date: 03/07/2013 07:43:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsReasonInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_StatusTransitionsReasonInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsReasonInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_StatusTransitionsReasonInsert
 * Inserts status transitions reason
 *
 * History
 *******************************************************************************
 * 2/19/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_StatusTransitionsReasonInsert]
	@AccountIdLegacy		varchar(20),
	@ReasonCodeID			int,
	@StatusTransitionsID	int,
	@DateCreated			datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@AccountID	int
    
    SELECT	@AccountID = ISNULL(AccountID, 0)
    FROM	Libertypower..Account WITH (NOLOCK)
    WHERE	AccountIdLegacy = @AccountIdLegacy
	
    INSERT INTO StatusTransitionsReason (AccountID, ReasonCodeID, StatusTransitionsID, DateCreated)
	VALUES		(@AccountID, @ReasonCodeID, @StatusTransitionsID, @DateCreated)
	
	SELECT	SCOPE_IDENTITY() AS ID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
