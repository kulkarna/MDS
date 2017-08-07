USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UsageGetMostRecentUsageDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UsageGetMostRecentUsageDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_UsageGetMostRecentUsageDate
 * Gets the most recent usage
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_UsageGetMostRecentUsageDate] 
	@UtilityCode				VARCHAR(50), 
	@AccountNumber			  	VARCHAR(50) 
AS
BEGIN
SET NOCOUNT ON;

DECLARE @EdiDate datetime;
DECLARE @ScraperDate datetime;
DECLARE @UsageFileDate datetime;
DECLARE  @Account VARCHAR(50)

SET @EdiDate = CAST('1/1/1900' AS DateTime)
SET @ScraperDate = CAST('1/1/1900' AS DateTime)
SET @UsageFileDate = CAST('1/1/1900' AS DateTime)

SET @Account = @AccountNumber

SET @UsageFileDate =(SELECT TOP 1  u.ToDate FROM lp_transactions..FileUsage u LEFT JOIN libertypower..Account a ON u.FileAccountID = a.AccountID  WHERE a.AccountNumber =  @Account ORDER BY u.ToDate DESC );

SET @EdiDate =(  SELECT TOP 1  EndDate
    FROM lp_transactions..EdiUsage (nolock) t1 inner join lp_transactions.dbo.EdiAccount (nolock) t2 on t1.ediaccountid = t2.id
    WHERE AccountNumber = @AccountNumber and UtilityCode = @UtilityCode
    ORDER BY EndDate DESC)

IF @UtilityCode = 'AMEREN'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  u.EndDate FROM lp_transactions..AmerenUsage u WITH (NOLOCK) LEFT JOIN libertypower..Account a ON u.AccountID = a.AccountID  WHERE a.AccountNumber =  @Account ORDER BY u.EndDate DESC );
END

IF @UtilityCode = 'BGE'
BEGIN
   SET @ScraperDate  = (SELECT TOP 1  u.EndDate FROM lp_transactions..BgeUsage u WITH (NOLOCK) WHERE AccountNumber =  @Account ORDER BY u.EndDate DESC );
END

IF @UtilityCode = 'CENHUD'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..CenhudUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'CMP'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..CmpUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'COMED'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..ComedUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'CONED'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  ToDate FROM lp_transactions..ConedUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'NIMO'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..NimoUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'NYSEG'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..NysegUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'PECO'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  ToDate FROM lp_transactions..PecoUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @UtilityCode = 'RGE'
BEGIN
    SET @ScraperDate  = (SELECT TOP 1  EndDate FROM lp_transactions..RgeUsage WITH (NOLOCK) WHERE AccountNumber =  @AccountNumber);
END

IF @ScraperDate IS NULL  SET @ScraperDate = CAST('1/1/1900' AS DateTime);
IF @EdiDate IS NULL  SET @EdiDate = CAST('1/1/1980' AS DateTime);
IF @UsageFileDate IS NULL  SET @UsageFileDate = CAST('1/1/1900' AS DateTime);

DECLARE @MOST_RECENT dateTime;
IF @ScraperDate > @EdiDate 
BEGIN
    SET @MOST_RECENT = @ScraperDate 
END
ELSE 
BEGIN
    SET @MOST_RECENT = @EdiDate
END

IF @MOST_RECENT < @UsageFileDate 
BEGIN
    SET @MOST_RECENT = @UsageFileDate
END

SELECT @MOST_RECENT as MostRecentUsage

SET NOCOUNT OFF;
END





            



















GO
