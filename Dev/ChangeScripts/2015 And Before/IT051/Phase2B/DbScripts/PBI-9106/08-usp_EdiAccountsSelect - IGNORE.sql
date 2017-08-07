USE [lp_transactions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_EdiAccountsSelect
 * Gets all the accounts imported after a certain date/time
 * usp_EdiAccountsSelect '2013-03-16 02::01.557'
 * History
 *******************************************************************************
 * 5/6/2013 - Cghazal
 * Created.
 usp_EdiAccountsSelect '9/25/2013'
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EdiAccountsSelect]
	@ProcessTime AS DATETIME
AS
BEGIN

    SET NOCOUNT ON;
    
	SELECT	DISTINCT a.AccountNumber, a.UtilityCode
	FROM	lp_transactions..EdiAccount a WITH (NOLOCK)
	WHERE	a.TimeStampInsert >= @ProcessTime

    SET NOCOUNT OFF;
END

