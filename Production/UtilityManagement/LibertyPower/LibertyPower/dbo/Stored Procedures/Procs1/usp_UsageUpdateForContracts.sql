-- ==================================================
-- Author: Jaime Forero
-- Date:   1/29/2012
-- Comments: No previous history on this SP. Refactored for IT079, new schema
-- ==================================================
-- EXEC LibertyPower.dbo.usp_UsageUpdateForContracts @StatusesToExclude = '911000,999998,999999', @ExcludeRecentlyAttempted = 10, @OnlyContractsInUsageStep = 1, @UsageStepAgeThreshold = 90
CREATE PROCEDURE [dbo].[usp_UsageUpdateForContracts] 
	@StatusesToExclude			VARCHAR(200) = '911000', 
	@ExcludeRecentlyAttempted	INT = 0, 
	@OnlyContractsInUsageStep	INT = 0, 
	@UsageStepAgeThreshold		INT = 60,
	@RecordLimit				INT = 1000000,
	@AccountAgeInMinutes		INT = null,
	@ContractType				VARCHAR(100) = null
AS
BEGIN
	-- For debugging
	--DECLARE @StatusesToExclude			VARCHAR(200)
	--DECLARE @ExcludeRecentlyAttempted	INT
	--DECLARE @OnlyContractsInUsageStep	INT
	--DECLARE @UsageStepAgeThreshold		INT
	--DECLARE @RecordLimit				INT
	--DECLARE @AccountAgeInMinutes		INT
	--DECLARE @ContractType				VARCHAR(100)
	--SET @StatusesToExclude = '911000' 
	--SET @ExcludeRecentlyAttempted = 0
	--SET @OnlyContractsInUsageStep = 0
	--SET @UsageStepAgeThreshold = 60
	--SET @RecordLimit = 1000000
	--SET @AccountAgeInMinutes = null
	--SET @ContractType = null

	set rowcount @RecordLimit
	
	-- Build the set of Contracts to collect usage for.
	--===============================================
	-- IT79 Change
	--SELECT account_number
	--INTO #Accounts
	--FROM lp_account..account
	--WHERE (annual_usage = 0 or annual_usage is null)
	SELECT AccountNumber as account_number
	INTO #Accounts
	FROM LibertyPower..Account (NOLOCK) A
	JOIN LibertyPower..[Contract] (NOLOCK) C	ON A.CurrentContractID  = C.ContractID
	JOIN LibertyPower..AccountUsage (NOLOCK) AU ON A.AccountID			= AU.ACcountID AND AU.EffectiveDate = C.StartDate
	WHERE (AU.AnnualUsage = 0 or AU.AnnualUsage is null)
	--===============================================
	
	print convert(varchar(100),@@rowcount) + ' total Accounts lacking usage.'
	
	-- If specified, filter using the parameters provided.
	
	--===============================================
	-- IT79 Change
	--DELETE FROM #Accounts
	--WHERE account_number NOT IN 
	--(
	--	SELECT account_number
	--	FROM lp_account..account
	--	WHERE 1=1
	--	AND (@AccountAgeInMinutes is null OR date_created >= dateadd(mi,-1 * @AccountAgeInMinutes,getdate()))
	--	AND (@ContractType is null OR contract_type not in (@ContractType))
	--)
	DELETE FROM #Accounts
	WHERE account_number NOT IN 
	(
		SELECT AccountNumber 
		FROM LibertyPower..Account (NOLOCK) A 
			JOIN LibertyPower..[Contract] (NOLOCK) C			 ON A.CurrentContractID  = C.ContractID
			JOIN LibertyPower..ContractType (NOLOCK) CT			 ON C.ContractTypeID	 = CT.ContractTypeID 
			JOIN LibertyPower..ContractTemplateType (NOLOCK) CTT ON C.ContractTemplateID = CTT.ContractTemplateTypeID 
			JOIN LibertyPower..ContractDealType (NOLOCK) CDT	 ON C.ContractDealTypeID = CDT.ContractDealTypeID 
		WHERE 1=1
		AND (@AccountAgeInMinutes is null OR 
			 A.DateCreated >= dateadd(mi,-1 * @AccountAgeInMinutes,getdate()))
		AND (@ContractType is null OR 
			 [Libertypower].[dbo].[ufn_GetLegacyContractType](CT.[Type],CTT.ContractTemplateTypeID,CDT.DealType) NOT IN (@ContractType)
			)
	)
	--===============================================
	
	print convert(varchar(100),@@rowcount) + ' excluded due to provided filters.'

	-- Exclude statuses specified
	
	--===============================================
	-- IT79 Change
	
	--DELETE FROM #Accounts
	--WHERE account_number in 
	--(select account_number from lp_account..account where status in (@StatusesToExclude))
	DELETE FROM #Accounts
	WHERE account_number in 
	(	
		SELECT AccountNumber 
		FROM LibertyPower..Account(NOLOCK) A 
		JOIN LibertyPower..AccountContract (NOLOCK) AC ON A.CurrentContractID  = AC.ContractID AND A.AccountID = AC.AccountID
		JOIN LibertyPower..AccountStatus (NOLOCK)  AST ON AC.AccountContractID = AST.AccountContractID
		WHERE AST.[Status] in (@StatusesToExclude)
	)
	--===============================================
	
	print convert(varchar(100),@@rowcount) + ' excluded due to status.'
	
	-- Exclude account attempted in the past X days.
	DELETE FROM #Accounts
	WHERE account_number in 
	(
		select substring(ErrorMessage,10,charindex('(',ErrorMessage)-11) as AccountWithNoUsage
		from libertypower..AuditUsageUsedLog 
		where 1=1
		and errormessage like '%does not have%' -- Errors due to lack of usage
		and datediff(dd,Created,getdate()) < @ExcludeRecentlyAttempted
	)
	
	print convert(varchar(100),@@rowcount) + ' excluded because it was recently attempted and failed.'
	
	-- If requested, Exclude contracts which are not in the Usage step.
	IF @OnlyContractsInUsageStep = 1
	BEGIN
	
		--===============================================
		-- IT79 Change
		--DELETE FROM #Accounts
		--WHERE account_number NOT IN 
		--(
		--	SELECT a.account_number
		--	FROM lp_enrollment.dbo.check_account c
		--	JOIN lp_account.dbo.account a on c.contract_nbr = a.contract_nbr 
		--	WHERE c.check_type = 'USAGE ACQUIRE'
		--	AND c.approval_status = 'PENDING'
		--	--AND datediff(dd,c.date_created,getdate()) > 1 -- brand new records wouldn't have usage yet.
		--	AND datediff(dd,c.date_created,getdate()) < @UsageStepAgeThreshold
		--)
		DELETE FROM #Accounts
		WHERE account_number NOT IN 
		(
			SELECT A.AccountNumber
			FROM LibertyPower..Account (NOLOCK)   A 
			JOIN LibertyPower..[Contract] (NOLOCK)  C ON A.CurrentContractID = C.ContractID 
			JOIN lp_enrollment.dbo.check_account (NOLOCK) CA ON CA.contract_nbr = C.Number
			WHERE	CA.check_type = 'USAGE ACQUIRE'
			AND		CA.approval_status = 'PENDING'
			AND datediff(dd,CA.date_created,getdate()) < @UsageStepAgeThreshold
		)
		--===============================================
		
		print convert(varchar(100),@@rowcount) + ' excluded because it is not currently in the Usage queue, or it was in there for too long.'
	END	
	 
	 
	
	
	---------------- Start looping through contracts.
	DECLARE @contract_nbr char(12)
	DECLARE @contract_type varchar(25)

	--===============================================
	-- IT79 Change
		
	--DECLARE clr_usage_csr cursor FOR
	--	-- Grab all contracts where the accounts are not Deenrolled, and do not yet have usage.
	--	SELECT contract_nbr, contract_type
	--	FROM lp_account..account
	--	WHERE account_number IN (select account_number from #Accounts)

	DECLARE clr_usage_csr cursor FOR
		-- Grab all contracts where the accounts are not Deenrolled, and do not yet have usage.
		SELECT	C.Number AS contract_nbr,  
				[Libertypower].[dbo].[ufn_GetLegacyContractType](CT.[Type],CTT.ContractTemplateTypeID,CDT.DealType) AS contract_type
		
		FROM LibertyPower..Account (NOLOCK) A 
			JOIN LibertyPower..[Contract] (NOLOCK) C			 ON A.CurrentContractID  = C.ContractID
			JOIN LibertyPower..ContractType (NOLOCK) CT			 ON C.ContractTypeID	 = CT.ContractTypeID 
			JOIN LibertyPower..ContractTemplateType (NOLOCK) CTT ON C.ContractTemplateID = CTT.ContractTemplateTypeID 
			JOIN LibertyPower..ContractDealType (NOLOCK) CDT	 ON C.ContractDealTypeID = CDT.ContractDealTypeID 
		WHERE AccountNumber IN (select account_number from #Accounts)
	--===============================================
	
	OPEN clr_usage_csr
	FETCH NEXT FROM clr_usage_csr INTO @contract_nbr, @contract_type

	WHILE @@fetch_status = 0 
	BEGIN 
		BEGIN TRY
			EXEC lp_account..clr_CalcAnnualUsgByContract 'http://enrollment.libertypowercorp.com:83/AnnualUsageTrigger/CalcAnnualUsgByContract.asmx/CalculateUsage?'
				 ,@contract_nbr, 'New Contract Usage', 0

			INSERT INTO UsageCLRLog
				   (contract_nbr, contract_type)
			SELECT @contract_nbr, @contract_type
		END TRY
		BEGIN CATCH
			INSERT INTO UsageCLRLog
				   (contract_nbr, contract_type, error_msg)
			SELECT @contract_nbr, @contract_type, convert(varchar(500),ERROR_NUMBER())
		END CATCH

		FETCH NEXT FROM clr_usage_csr INTO @contract_nbr, @contract_type
	END 

	CLOSE clr_usage_csr
	DEALLOCATE clr_usage_csr 
END





            


















