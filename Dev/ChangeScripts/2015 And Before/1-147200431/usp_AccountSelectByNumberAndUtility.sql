USE [Libertypower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountSelectByNumberAndUtility]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_AccountSelectByNumberAndUtility]
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
 *******************************************************************************
 * 6/18/2013  Gail Mangaroo
 * Created.
 *******************************************************************************
 */
 
CREATE PROCEDURE [dbo].[usp_AccountSelectByNumberAndUtility] 
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
			ON a.UtilityID = a.UtilityID
	WHERE a.AccountNumber = @AccountNumber 
		AND (u.UtilityCode = @UtilityCode OR @UtilityCode IS NULL)

	SET NOCOUNT OFF;
		
END
-- Copyright 2009 Liberty Power

