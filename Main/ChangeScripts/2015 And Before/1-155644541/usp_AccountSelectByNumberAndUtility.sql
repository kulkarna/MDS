USE [Libertypower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AccountSelectByNumberAndUtility
 * Get account record by number and utility
 *
 * History
 1-155644541: update the bug where ON a.UtilityID = a.UtilityID: it should be ON u.ID = a.UtilityID
 *******************************************************************************
 * 6/18/2013  Gail Mangaroo
 * Created.
 *******************************************************************************
 */
 
ALTER PROCEDURE [dbo].[usp_AccountSelectByNumberAndUtility] 
(
	@AccountNumber	varchar(50),
	@UtilityCode	varchar(50) = null 
)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT * 
	FROM Libertypower..Account a WITH (NOLOCK)
		LEFT JOIN Libertypower..Utility u WITH (NOLOCK)
			ON u.ID = a.UtilityID
	WHERE a.AccountNumber = @AccountNumber 
		AND (u.UtilityCode = @UtilityCode OR @UtilityCode IS NULL)

	SET NOCOUNT OFF;
		
END
-- Copyright 2009 Liberty Power

