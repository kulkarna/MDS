/*
* ***************************************************
* Author:		Eric Hernandez
* Create date: 3/26/2012
* Description:	To approve TPVs
* ***************************************************
* Modified	: 06/15/2012	JoseMunoz - SWCS
* Ticket	: 1-17803325
* Description:	libertypower..usp_GetTPVRateMatches (optimizations)
* ***************************************************


EXEC [libertypower].[dbo].[usp_GetTPVRateMatches_jmunoz]

*/

CREATE PROCEDURE [dbo].[usp_GetTPVRateMatches_jmunoz]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Only get contracts that are currently pending.
	SELECT *
		, ContractDate = CASE WHEN ISDATE(EstDateEffect) = 1 THEN EstDateEffect
							  ELSE substring(EstDateEffect,4,4) + substring(EstDateEffect,1,2) + '01' END
	INTO #TPVFileData
	FROM [LibertyPower].[dbo].[TPVFileData] WITH (NOLOCK)
	WHERE VerificationNumber IN (	SELECT contract_nbr FROM lp_enrollment..check_account WITH (NOLOCK)
									WHERE check_type = 'TPV' and approval_status in  ('PENDING','INCOMPLETE'))

	--drop table #TPVFileData
	--drop table #Results
	--select * from #Results
	-- 1 - Find good and bad contracts ------------------------------------------------------------------------------------ 

	--Get Matches with TPV file Data and the database
	SELECT 
		  TpvContractNumber			= LTRIM(RTRIM(tpv.VerificationNumber))
		, TpvAccountNumber			= tpv.AccountNumber
		, ContractAccount			= a.AccountNumber
		, AccountMatch				= CASE WHEN a.AccountNumber = tpv.AccountNumber THEN 'YES' ELSE 'NO' END
		, TpvRate					= tpv.Rate
		, ContractRate				= ACR.Rate 
		, RateMatch					= CASE WHEN tpv.Rate = ACR.Rate THEN 'YES' ELSE 'NO' END 
		, TpvTerm					= tpv.Term
		, ContractTerm				= ACR.Term
		, TermMatch					= CASE WHEN PATINDEX('%' + CAST(ACR.Term as VARCHAR) + '%', tpv.Term) > 0 THEN 'YES' ELSE 'NO' END
		, TpvDate					= tpv.ContractDate 
		, ContractDate				= CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateStart  ELSE AC_DefaultRate.RateStart END 
		, DateMatch					= CASE WHEN ISDATE(TPV.ContractDate) = 1 THEN CASE WHEN convert(datetime,TPV.ContractDate) = (CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR.RateStart  ELSE AC_DefaultRate.RateStart END) THEN 'YES' ELSE 'NO' END	
										ELSE 'NO' END	
		, TpvServiceStreet			= tpv.ServiceAddress
		, AccountServiceStreet		= W.[Address]
		, ServiceStreetMatch		= CASE WHEN tpv.ServiceAddress = W.[Address] THEN 'YES' ELSE 'NO' END
		, TpvCity					= tpv.ServiceCity
		, AccountCity				= W.City
		, CityMatch					= CASE WHEN tpv.ServiceCity = W.City THEN 'YES' ELSE 'NO' END
		, TpvState					= tpv.ServiceState
		, AccountState				= W.[State]
		, StateMatch				= CASE WHEN tpv.ServiceState = W.[State] THEN 'YES' ELSE 'NO' END
		INTO #Results
	FROM #TPVFileData tpv WITH (NOLOCK) 
	LEFT JOIN Libertypower..[Contract] CO WITH (NOLOCK) 
	ON CO.Number					= LTRIM(RTRIM(tpv.VerificationNumber))
	LEFT JOIN Libertypower..Account a WITH (NOLOCK) 
	ON a.CurrentContractID			= CO.ContractID
	LEFT JOIN Libertypower..AccountContract AC WITH (NOLOCK)
	ON AC.ContractId				= CO.ContractID
	AND AC.AccountId				= a.AccountID
	INNER JOIN Libertypower..AccountContractRate ACR WITH (NOLOCK)
	ON ACR.AccountContractID		= AC.AccountContractID
	AND ACR.IsContractedRate		= 1
	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
		   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
	       WHERE ACRR.IsContractedRate		= 0 
	       GROUP BY ACRR.AccountContractID
          ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID	
	LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
	ON ACRR2.AccountContractRateID	= AC_DefaultRate.AccountContractRateID 
	LEFT JOIN lp_account.dbo.account_address W WITH (NOLOCK) 
	ON W.AccountAddressID			= A.ServiceAddressID
	
	--Gets contracts where something mismatch
	CREATE TABLE #BadContracts (TpvContractNumber	VARCHAR(250))
	CREATE INDEX IDX_TpvContractNumber ON #BadContracts (TpvContractNumber)
	
	INSERT INTO #BadContracts
	SELECT DISTINCT TpvContractNumber 
	FROM #Results WITH (NOLOCK)
	WHERE AccountMatch = 'NO' 
		OR RateMatch = 'NO' 
		OR TermMatch = 'NO' 
		OR DateMatch = 'NO'

	--Gets contracts where everything is good
	CREATE TABLE #TPVAllGoodContracts (TpvContractNumber	VARCHAR(250))
	CREATE INDEX IDX_TpvContractNumber ON #TPVAllGoodContracts (TpvContractNumber)
	
	INSERT INTO #TPVAllGoodContracts
	SELECT DISTINCT TpvContractNumber
	FROM #Results WITH (NOLOCK)
	WHERE TpvContractNumber NOT IN ( SELECT TpvContractNumber FROM #BadContracts WITH (NOLOCK))

	-- 2 - Disposition TPV ---------------------------------------------------------------------------------------------------

	SELECT * FROM #TPVFileData
	SELECT * FROM #Results
	SELECT * FROM #BadContracts
	SELECT * FROM #TPVAllGoodContracts
	
	RETURN 1

	--Declare cursor variables	
	DECLARE @tmp_contractNumber			VARCHAR(50)
		,@tmp_contractType				INT
		,@tmp_disposition				VARCHAR(4)


	--Create and open cursor
	DECLARE tpv_cursor CURSOR FAST_FORWARD FOR
	SELECT DISTINCT 'GOOD', good.TpvContractNumber, ContractDealTypeID
	FROM #TPVAllGoodContracts good WITH (NOLOCK)
	JOIN LibertyPower..Contract c WITH (NOLOCK)
	ON c.Number					= good.TpvContractNumber
	UNION
	SELECT DISTINCT 'BAD', bad.TpvContractNumber, ContractDealTypeID
	FROM #BadContracts bad WITH (NOLOCK)
	JOIN LibertyPower..Contract c WITH (NOLOCK)
	ON c.Number					= bad.TpvContractNumber
	JOIN lp_enrollment..check_account ca WITH (NOLOCK)
	ON c.Number					= ca.contract_nbr 
	AND check_type				= 'TPV' 
	AND approval_status			= 'PENDING' -- Do not re-flag Incompletes as Incomplete.
	
	OPEN tpv_cursor

	--Puts first row into variables
	FETCH NEXT FROM tpv_cursor
	INTO @tmp_disposition, @tmp_contractNumber, @tmp_contractType

	--Loops through rows, executing the correct procedure based on contract type
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF ( @tmp_disposition = 'BAD')
		BEGIN
			IF ( @tmp_contractType = 2 ) -- Renewal
			BEGIN
				EXEC lp_enrollment.dbo.usp_check_account_renewal_approval_reject 
				@p_username = N'System', @p_check_request_id = 'RENEWAL', @p_contract_nbr = @tmp_contractNumber
				, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'TPV'
				, @p_approval_status = N'INCOMPLETE', @p_comment = N'Could not be approved by system.'
				
				PRINT('Contract renewal: ' + @tmp_contractNumber + '')
			END
			ELSE
			BEGIN
				EXEC lp_enrollment.dbo.usp_check_account_approval_reject 
				@p_username = N'System', @p_check_request_id = 'ENROLLMENT', @p_contract_nbr = @tmp_contractNumber
				, @p_account_id = N'NONE' , @p_account_number = N' ' , @p_check_type = N'TPV'
				, @p_approval_status = N'INCOMPLETE' , @p_comment = N'Could not be approved by system.'
				PRINT('Contract: ' + @tmp_contractNumber + '')
			END
		END
		ELSE IF ( @tmp_disposition = 'GOOD')
		BEGIN
			IF ( @tmp_contractType = 2 ) -- Renewal
			BEGIN
				EXEC lp_enrollment.dbo.usp_check_account_renewal_approval_reject 
				@p_username = N'System', @p_check_request_id = 'RENEWAL', @p_contract_nbr = @tmp_contractNumber
				, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'TPV'
				, @p_approval_status = N'APPROVED', @p_comment = N'Approved by system'
				
				PRINT('Contract renewal: ' + @tmp_contractNumber + '')
			END
			ELSE
			BEGIN
				EXEC lp_enrollment.dbo.usp_check_account_approval_reject 
				@p_username = N'System', @p_check_request_id = 'ENROLLMENT', @p_contract_nbr = @tmp_contractNumber
				, @p_account_id = N'NONE' , @p_account_number = N' ' , @p_check_type = N'TPV'
				, @p_approval_status = N'APPROVED' , @p_comment = N'Appoved by system'
				PRINT('Contract: ' + @tmp_contractNumber + '')
			END
		END

		FETCH NEXT FROM tpv_cursor
		INTO @tmp_disposition, @tmp_contractNumber, @tmp_contractType
	END
	
	CLOSE tpv_cursor
	DEALLOCATE tpv_cursor

	SET NOCOUNT OFF; 
END
