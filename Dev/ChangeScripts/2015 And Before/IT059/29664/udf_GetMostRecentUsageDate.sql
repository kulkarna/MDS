USE [OfferEngineDB]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetMostRecentUsageDate]    Script Date: 01/07/2014 16:53:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetMostRecentUsageDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetMostRecentUsageDate]
GO

USE [OfferEngineDB]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetMostRecentUsageDate]    Script Date: 01/07/2014 16:53:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_GetMostRecentUsageDate]
(
	-- Add the parameters for the function here
	@UtilityCode    VARCHAR(50),   
	@AccountNumber      VARCHAR(50)   
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	
	DECLARE @EdiDate datetime;  
	DECLARE @ScraperDate datetime;  
	DECLARE @UsageFileDate datetime;  
	DECLARE  @Account VARCHAR(50)  
	  
	SET @EdiDate = CAST('1/1/1900' AS DateTime)  
	SET @ScraperDate = CAST('1/1/1900' AS DateTime)  
	SET @UsageFileDate = CAST('1/1/1900' AS DateTime)  
	  
	SET @Account = @AccountNumber  
	  
	SET @UsageFileDate =(
		SELECT TOP 1  u.ToDate 
		FROM lp_transactions..FileUsage u (nolock)
		LEFT JOIN libertypower..Account a (nolock) ON u.FileAccountID = a.AccountID  
		WHERE a.AccountNumber =  @Account ORDER BY u.ToDate DESC 
	);  
	  
	SET @EdiDate =(  
		SELECT TOP 1  EndDate  
		FROM lp_transactions..EdiUsage (nolock) t1 
		inner join lp_transactions.dbo.EdiAccount (nolock) t2 on t1.ediaccountid = t2.id  
		WHERE AccountNumber = @AccountNumber and UtilityCode = @UtilityCode  
		ORDER BY EndDate DESC
	)  
	  
	IF @UtilityCode = 'AMEREN'  
	BEGIN  
		SET @ScraperDate  = (
			SELECT TOP 1  u.EndDate 
			FROM lp_transactions..AmerenUsage u WITH (NOLOCK) 
			LEFT JOIN libertypower..Account a (nolock) ON u.AccountID = a.AccountID  
			WHERE a.AccountNumber =  @Account 
			ORDER BY u.EndDate DESC 
		);  
	END  
	  
	IF @UtilityCode = 'BGE'  
	BEGIN  
	   SET @ScraperDate  = (
			SELECT TOP 1  u.EndDate 
			FROM lp_transactions..BgeUsage u WITH (NOLOCK) 
			WHERE AccountNumber =  @Account 
			ORDER BY u.EndDate DESC 
	);  
	END  
	  
	IF @UtilityCode = 'CENHUD'  
	BEGIN  
		SET @ScraperDate  = 
		(
			SELECT TOP 1  EndDate 
			FROM lp_transactions..CenhudUsage WITH (NOLOCK) 
			WHERE AccountNumber =  @AccountNumber
		);  
	END  
	  
	IF @UtilityCode = 'CMP'  
	BEGIN  
		SET @ScraperDate  = 
		(
			SELECT TOP 1  EndDate 
			FROM lp_transactions..CmpUsage WITH (NOLOCK) 
			WHERE AccountNumber =  @AccountNumber
		);  
	END  
	  
	IF @UtilityCode = 'COMED'  
	BEGIN  
		SET @ScraperDate  = 
		(
			SELECT TOP 1  EndDate 
			FROM lp_transactions..ComedUsage WITH (NOLOCK) 
			WHERE AccountNumber =  @AccountNumber
		);  
	END  
	  
	IF @UtilityCode = 'CONED'  
	BEGIN  
		SET @ScraperDate  = 
		(
			SELECT TOP 1  ToDate 
			FROM lp_transactions..ConedUsage WITH (NOLOCK) 
			WHERE AccountNumber =  @AccountNumber
		);  
	END  
	  
	IF @UtilityCode = 'NIMO'  
	BEGIN  
		SET @ScraperDate  = 
		(
			SELECT TOP 1  EndDate 
			FROM lp_transactions..NimoUsage WITH (NOLOCK) 
			WHERE AccountNumber =  @AccountNumber
		);  
	END  
	  
	IF @UtilityCode = 'NYSEG'  
	BEGIN  
		SET @ScraperDate  = 
		(
			SELECT TOP 1  EndDate 
			FROM lp_transactions..NysegUsage WITH (NOLOCK) 
			WHERE AccountNumber =  @AccountNumber
		);  
	END  
	  
	IF @UtilityCode = 'PECO'  
	BEGIN  
		SET @ScraperDate  = 
		(
			SELECT TOP 1  ToDate 
			FROM lp_transactions..PecoUsage WITH (NOLOCK) 
			WHERE AccountNumber =  @AccountNumber
		);  
	END  
	  
	IF @UtilityCode = 'RGE'  
	BEGIN  
		SET @ScraperDate  = 
		(
			SELECT TOP 1  EndDate 
			FROM lp_transactions..RgeUsage WITH (NOLOCK) 
			WHERE AccountNumber =  @AccountNumber
		);  
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
	  
	RETURN @MOST_RECENT
  

END

GO


