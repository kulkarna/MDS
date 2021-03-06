USE [Lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_tier_validation]    Script Date: 10/22/2012 10:03:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_tier_validation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_tier_validation]
GO
/****** Object:  StoredProcedure [dbo].[usp_tier_validation]    Script Date: 10/22/2012 10:03:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_tier_validation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[usp_tier_validation] @contract_nbr VARCHAR(25), @check_request_id VARCHAR(12)
AS

--drop table #Contract
--drop table #ContractDetails

--DECLARE @contract_nbr	VARCHAR(25) 
--SET @contract_nbr = ''2012-0029975''

DECLARE @step_status VARCHAR(15)
DECLARE @step_comments VARCHAR(max)

SELECT *
INTO #ContractDetails
FROM libertypower.dbo.ufn_contract_details(@contract_nbr)

DECLARE @total_contract_usage INT

SELECT *
INTO #Contract
FROM LibertyPower..Contract c
WHERE c.Number = @contract_nbr

DECLARE @ContractTierDesc  VARCHAR(100)
SET @ContractTierDesc = ''''
SELECT @ContractTierDesc = d.[Description]
FROM #ContractDetails d
JOIN LibertyPower..DailyPricingPriceTier t ON d.ContractTierID = t.ID
WHERE t.ID <> 0 -- This tier description does not fit well into the comments below.  "No price tier"


SELECT @total_contract_usage = SUM(au.AnnualUsage)
FROM #Contract c
JOIN LibertyPower..Account a ON c.ContractID = a.CurrentContractID
JOIN LibertyPower..AccountUsage au ON a.AccountID = au.AccountID AND au.EffectiveDate = c.StartDate



---------------------------------------------------------------------------------------
-- Approve custom deals.
-- IT106, BR006-FR005
---------------------------------------------------------------------------------------
DECLARE @IsCustom INT
SELECT @IsCustom = IsCustom
FROM LibertyPower..ProductBrand pb
WHERE ProductBrandID = (select top 1 ProductBrandID from #ContractDetails)

IF (@IsCustom = 1)
BEGIN
	PRINT ''Approve. Custom deal''
	SET @step_status = ''APPROVED''
	SET @step_comments = ''Contract '' + @contract_nbr + '' approved, exempt from validation per custom pricing.''
	GOTO step_disposition
END


---------------------------------------------------------------------------------------
-- If its not a custom deal (checked above) and the usage is too large, reject the deal.
-- IT106, BR006-FR019 2200MWh limit
---------------------------------------------------------------------------------------
IF (@total_contract_usage > 2200000)
BEGIN
	PRINT ''Size of contract exceeds maximum allowable for Daily Pricing.''
	SET @step_status = ''REJECTED''
	SET @step_comments = ''Zone and service class verified per utility data, '' 
			+ @ContractTierDesc + '' usage tier selected; '' 
			+ @contract_nbr + '' declined.  Aggregate usage >2200MWh, account(s) ineligible for daily priced product.  Please contact Sales personnel for further assistance.''
	GOTO step_disposition
END


---------------------------------------------------------------------------------------
-- If any service class or zone cannot be identified, set to incomplete
-- IT106, BR006-FR012
---------------------------------------------------------------------------------------

-- If ServiceClass is "default", we will send the contract in to "incomplete"
IF EXISTS (	SELECT	1
			FROM #ContractDetails d
			WHERE d.ServiceClassID = -1
		  )

BEGIN
	PRINT ''Service class of the product is Default, and must be manually reviewed.''
	SET @step_status = ''INCOMPLETE''
	SET @step_comments = ''Service class of the product is Default, and must be manually reviewed; contract '' 
						+ @contract_nbr + '' marked as incomplete.''
	GOTO step_disposition
END


IF EXISTS (	SELECT	1
			FROM LibertyPower..Account a (NOLOCK)
			JOIN #ContractDetails d ON a.AccountID = d.AccountID
			LEFT JOIN LibertyPower..ServiceClassMapping scm ON a.ServiceRateClass = RTRIM(LTRIM(scm.Text)) and a.UtilityID = scm.UtilityID
			LEFT JOIN LibertyPower..ZoneMapping zm ON a.Zone = RTRIM(LTRIM(zm.Text)) and a.UtilityID = zm.UtilityID
			WHERE	(d.ServiceClassID <> -1 AND scm.ServiceClassID IS NULL)
			OR  (d.ZoneID <> -1 AND zm.ZoneID IS NULL)
		  )						
BEGIN
	PRINT ''Service class and/or zone is not valid for the contracted rate.''
	SET @step_status = ''INCOMPLETE''
	--SET @step_comments = ''One or more accounts have a service class or zone which is not valid for the contracted rate.''
	SET @step_comments = ''Zone and/or service class could not be identified.  Contract must be manually reviewed; contract '' 
						+ @contract_nbr + '' incomplete.''
	GOTO step_disposition
END



IF EXISTS (	SELECT	1
			FROM LibertyPower..Account a (NOLOCK)
			JOIN #ContractDetails d ON a.AccountID = d.AccountID
			LEFT JOIN LibertyPower..ServiceClassMapping scm ON a.ServiceRateClass = RTRIM(LTRIM(scm.Text)) and a.UtilityID = scm.UtilityID
			LEFT JOIN LibertyPower..ZoneMapping zm ON a.Zone = RTRIM(LTRIM(zm.Text)) and a.UtilityID = zm.UtilityID
			WHERE	(d.ServiceClassID <> -1 AND d.ServiceClassID <> scm.ServiceClassID)
			OR  (d.ZoneID <> -1 AND d.ZoneID <> zm.ZoneID)
		  )						
BEGIN
	PRINT ''Service class and/or zone is not valid for the contracted rate.''
	SET @step_status = ''REJECTED''
	--SET @step_comments = ''One or more accounts have a service class or zone which is not valid for the contracted rate.''
	SET @step_comments = ''Zone and/or service class did not match the contracted product; contract '' 
						+ @contract_nbr + '' rejected.''
	GOTO step_disposition
END


---------------------------------------------------------------------------------------
-- If the tier is correct for the entire contract, we can approve it.
-- IT106, BR006-FR002
---------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM #ContractDetails WHERE ContractTierID <> ActualTierID)
BEGIN
	PRINT ''Approve. Tier is correct.''
	SET @step_status = ''APPROVED''
	SET @step_comments = ''Zone and service class verified per utility data,''
						+ @ContractTierDesc + '' usage tier confirmed; contract ''
						+ @contract_nbr + '' approved.''
	--select @step_comments, @ContractTierDesc, @contract_nbr
	GOTO step_disposition
END

---------------------------------------------------------------------------------------
-- If the total usage is within the tolerance, we accept the deal as is.
-- IT106, BR006-FR002
---------------------------------------------------------------------------------------
DECLARE @TotalDiff INT
SELECT @TotalDiff = case when @total_contract_usage > MaxKwh then @total_contract_usage - MaxKwh
						 when @total_contract_usage between MinKwh and MaxKwh then 0
						 when @total_contract_usage < MinKwh then @total_contract_usage - MinKwh end
FROM #ContractDetails

DECLARE @UsageTolerance DECIMAL(12,6)

SELECT @UsageTolerance = UsageTolerance
FROM LibertyPower..GlobalPricingOptions

IF (ABS(@TotalDiff) <= (@total_contract_usage * @UsageTolerance))
BEGIN
	PRINT ''Approve. Usage is within tolerance''
	SET @step_status = ''APPROVED''
	SET @step_comments = ''Zone and service class verified per utility data, ''
						+ @ContractTierDesc + '' usage tier selected and difference is within tolerance; contract ''
						+ @contract_nbr + '' approved.  ''
	GOTO step_disposition
END


---------------------------------------------------------------------------------------
-- IT106, BR006-FR006 Mark contracts within Quote Tolerance as Approve
-- IT106, BR006-FR014 If outside of Quote Tolerance, then Reject
---------------------------------------------------------------------------------------

-- We assume that the ChannelType is consistent throughout the accounts on the contract.
DECLARE @ChannelTypeID INT
SELECT @ChannelTypeID = ChannelTypeID
FROM #ContractDetails

DECLARE @QuoteTolerance DECIMAL(12,6)
SELECT @QuoteTolerance = QuoteTolerance
FROM LibertyPower..SalesChannelPricingOptions o
JOIN #Contract c ON o.ChannelID = c.SalesChannelID

DECLARE @RejectComment VARCHAR(500)
DECLARE @ActualTransferRate DECIMAL(18,10)
DECLARE @ContractTransferRate DECIMAL(18,10)
DECLARE @ContractRate DECIMAL(18,10)

-- IT106, BR006-FR014 If outside of Quote Tolerance, then Reject
IF EXISTS(	SELECT 1 
			FROM #ContractDetails 
			WHERE (ActualTransferRate - ContractTransferRate) > 0
			AND   (ActualTransferRate - ContractTransferRate) > @QuoteTolerance
		 )
BEGIN
	SELECT @ActualTransferRate = ActualTransferRate
		 , @ContractTransferRate = ContractTransferRate
	FROM #ContractDetails 
	WHERE (ActualTransferRate - ContractTransferRate) > 0
	AND   (ActualTransferRate - ContractTransferRate) > @QuoteTolerance

	SET @RejectComment = ''ActualTransferRate of '' + CONVERT(varchar(50),@ActualTransferRate)
						+ '' minus ContractTransferRate '' + CONVERT(varchar(50),@ContractTransferRate)
						+ '' exceeds tolerance of channel '' + CONVERT(varchar(50),@QuoteTolerance) + ''.''

	-- IT106, BR006-FR016 Recording comments on accounts.
	-- IT106, BR006-FR017 Reject contract if at least 1 account is rejected.
	PRINT ''REJECT.  Rate Difference above channels quote tolerance.''
	SET @step_status = ''REJECTED''
	--SET @step_comments = ''Actual transfer rate exceeded contracted transfer by an ammount which exceeded the channels quote tolerance.''
	SET @step_comments = ''Zone and service class verified per utility data, ''
						+ @ContractTierDesc + '' usage tier selected and is invalid; contract ''
						+ @contract_nbr + '' declined.  Quote tolerance exceeded, please contact Sales personnel for further assistance. ''
	GOTO step_disposition
END
-- IT106, BR006-FR015
ELSE IF EXISTS(	SELECT 1
				FROM #ContractDetails
				WHERE (ActualTransferRate - ContractTransferRate) > 0
				AND	  (ActualTransferRate - ContractTransferRate) > (ContractRate - ContractTransferRate)
			 )
BEGIN
	SELECT @ActualTransferRate = ActualTransferRate
		 , @ContractTransferRate = ContractTransferRate
		 , @ContractRate = ContractRate
	FROM #ContractDetails 
	WHERE (ActualTransferRate - ContractTransferRate) > 0
	AND	  (ActualTransferRate - ContractTransferRate) > (ContractRate - ContractTransferRate)


	-- IT106, BR006-FR016 Recording comments on accounts.
	-- IT106, BR006-FR017 Reject contract if at least 1 account is rejected.
	SET @step_status = ''REJECTED''
	SET @step_comments = ''ActualTransferRate of '' + CONVERT(varchar(50),@ActualTransferRate)
						+ '' minus ContractTransferRate '' + CONVERT(varchar(50),@ContractTransferRate)
						+ '' exceeds commission on deal '' + CONVERT(varchar(50),@ContractRate - @ContractTransferRate) + ''.''
	GOTO step_disposition
END
ELSE
BEGIN
	UPDATE	acr
	SET		PriceID			= c.ActualPriceID,
			TransferRate	= c.ActualTransferRate
	FROM	Libertypower..AccountContractRate AS acr (nolock)
	INNER JOIN (
				SELECT	acr1.AccountContractID, 
						MIN(acr1.RateStart) AS RateStart, 
						SUM(acr1.Term) as Term, 
						MAX(acr1.RateEnd) as RateEnd, 
						acr1.IsContractedRate
				FROM	Libertypower..AccountContractRate AS acr1 (nolock)
				WHERE	acr1.IsContractedRate = 1
				GROUP	BY 
						acr1.AccountContractID, 
						acr1.IsContractedRate
				HAVING	MIN(acr1.RateStart) < GETDATE() 
				AND		MAX(acr1.RateEnd) >= GETDATE() 					
				) AS b 
	ON		b.AccountContractID = acr.AccountContractID
	AND		b.IsContractedRate = acr.IsContractedRate	                        
	JOIN LibertyPower..AccountContract ac ON acr.AccountContractID = ac.AccountContractID
	JOIN #ContractDetails c ON ac.AccountID = c.AccountID
	WHERE	acr.RateStart < GETDATE() 
	AND		acr.RateEnd >= GETDATE()

	-- These comments are to indicate that the product changed on the account.
	-- There are additional comments below which indicate the Price Validation step was completed.
	INSERT INTO lp_account.dbo.account_comments
	(account_id   , date_comment, process_id     , comment   , username   , chgstamp)
	SELECT a.AccountIDLegacy, getdate()   , ''PRODUCT CORRECTION'', ''Product rate selection was changed to match the true tier of the contract.'', ''SYSTEM'', 0       
	FROM LibertyPower..Account a (nolock)
	JOIN LibertyPower..AccountContract ac (nolock) ON a.AccountID = ac.AccountID
	JOIN LibertyPower..Contract c (nolock) ON ac.ContractID = c.ContractID
	WHERE c.Number = @contract_nbr
	
	SET @step_status = ''APPROVED''
	SET @step_comments = ''Actual transfer rate exceeded contracted transfer rate but is within the channels quote tolerance.''
	GOTO step_disposition
END

select ''1''
RETURN

step_disposition:
select @check_request_id
IF ( @check_request_id = ''RENEWAL'' ) -- Renewal
BEGIN
	EXEC lp_enrollment.dbo.usp_check_account_renewal_approval_reject 
	@p_username = N''System'', @p_check_request_id = ''RENEWAL'', @p_contract_nbr = @contract_nbr
	, @p_account_id = N''NONE'', @p_account_number = N'' '', @p_check_type = N''PRICE VALIDATION''
	, @p_approval_status = @step_status, @p_comment = @step_comments
	
	PRINT(''Contract renewal: '' + @contract_nbr + '''')
END
ELSE
BEGIN
	EXEC lp_enrollment.dbo.usp_check_account_approval_reject 
	@p_username = N''System'', @p_check_request_id = ''ENROLLMENT'', @p_contract_nbr = @contract_nbr
	, @p_account_id = N''NONE'' , @p_account_number = N'' '' , @p_check_type = N''PRICE VALIDATION''
	, @p_approval_status = @step_status , @p_comment = @step_comments
	PRINT(''Contract: '' + @contract_nbr + '''')
END

--DECLARE @AccountsOver INT
--DECLARE @AccountsOK INT
--DECLARE @AccountsUnder INT

--SELECT @AccountsOver  = count(case when @total_contract_usage > MaxKwh then 1 else null end)
--	  ,@AccountsOK    = count(case when @total_contract_usage between MinKwh and MaxKwh then 1 else null end)
--	  ,@AccountsUnder = count(case when @total_contract_usage < MinKwh then 1 else null end)
--FROM #ContractDetails 


--SELECT @AccountsOver, @AccountsOK, @AccountsUnder

--SELECT *
--FROM #ContractDetails


--select distinct RetailMarketCode, UtilityCode, RateClass, count(*) 
--from lp_transactions.dbo.EdiAccount (nolock) where RetailMarketCode in (''NJ'', ''CT'', ''MD'') 
--group by RetailMarketCode, UtilityCode, RateClass order by 1, 2


' 
END
GO
