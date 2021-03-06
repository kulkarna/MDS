USE [Lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_StatusTransitionsAccountServiceUpdate]    Script Date: 03/07/2013 07:43:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsAccountServiceUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_StatusTransitionsAccountServiceUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_StatusTransitionsAccountServiceUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_StatusTransitionsAccountServiceUpdate
 * Updates/inserts account service record
 *
 * History
 *******************************************************************************
 * 2/19/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_StatusTransitionsAccountServiceUpdate]
	@AccountIdLegacy	varchar(20),
	@Status				varchar(20),
	@StartDate			datetime,
	@EndDate			datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@AccountServiceID	int
    
    SET	@StartDate = CASE WHEN @StartDate = ''19000101'' THEN NULL ELSE @StartDate END
    SET	@EndDate = CASE WHEN @EndDate = ''19000101'' THEN NULL ELSE @EndDate END
    
    SELECT	@AccountServiceID = ISNULL(MAX(AccountServiceID), 0)
    FROM	Libertypower..AccountService WITH (NOLOCK)
    WHERE	account_id = @AccountIdLegacy
    
    -- if cancelling enrollment set end date to be start date
    IF @Status IN (''999998'', ''999999'', ''12000'')
		BEGIN
			UPDATE	Libertypower..AccountService
			SET		EndDate = StartDate
			WHERE	AccountServiceID = @AccountServiceID
		END
    
    -- if changing to enrolled insert new record
    IF @Status IN (''905000'', ''906000'', ''13000'')
		BEGIN
			INSERT INTO	Libertypower..AccountService (account_id, StartDate, EndDate, DateCreated)
			VALUES		(@AccountIdLegacy, @StartDate, @EndDate, GETDATE())
		END
	
	-- if changing to deenrolled set end date
    IF @Status IN (''911000'', ''11000'')
		BEGIN
			UPDATE	Libertypower..AccountService
			SET		EndDate = @EndDate
			WHERE	AccountServiceID = @AccountServiceID
		END		

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
