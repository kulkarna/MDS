-- =============================================
-- Author:		Eric Hernandez
-- Create date: 3/26/2012
-- Description:	To approve TPVs
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetTPVRateMatches]

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
FROM [LibertyPower].[dbo].[TPVFileData]
WHERE VerificationNumber IN ( SELECT contract_nbr FROM lp_enrollment..check_account WHERE check_type = 'TPV' and approval_status in  ('PENDING','INCOMPLETE'))

--drop table #TPVFileData
--drop table #Results
--select * from #Results
-- 1 - Find good and bad contracts ------------------------------------------------------------------------------------ 

--Get Matches with TPV file Data and the database
SELECT 
      TpvContractNumber = ltrim(rtrim(tpv.VerificationNumber))
    , TpvAccountNumber = tpv.AccountNumber
    , ContractAccount = a.account_number
    , AccountMatch = CASE WHEN a.account_number = tpv.AccountNumber THEN 'YES' ELSE 'NO' END
    , TpvRate = tpv.Rate
    , ContractRate = a.rate 
    , RateMatch = CASE WHEN tpv.Rate = a.rate THEN 'YES' ELSE 'NO' END 
    , TpvTerm = tpv.Term
    , ContractTerm = a.Term_Months
    , TermMatch = CASE WHEN PATINDEX('%' + CAST(a.Term_Months as VARCHAR) + '%', tpv.Term) > 0 THEN 'YES' ELSE 'NO' END
    , TpvDate = tpv.ContractDate 
    , ContractDate = a.contract_eff_start_date
    , DateMatch = CASE WHEN ISDATE(TPV.ContractDate) = 1 THEN CASE WHEN convert(datetime,TPV.ContractDate) = a.contract_eff_start_date THEN 'YES' ELSE 'NO' END	
                       ELSE 'NO' END	
    , TpvServiceStreet = tpv.ServiceAddress
    , AccountServiceStreet = ta.ServiceStreet
    , ServiceStreetMatch = CASE WHEN tpv.ServiceAddress = ta.ServiceStreet THEN 'YES' ELSE 'NO' END
    , TpvCity = tpv.ServiceCity
    , AccountCity = ta.ServiceCity
    , CityMatch = CASE WHEN tpv.ServiceCity = ta.ServiceCity THEN 'YES' ELSE 'NO' END
    , TpvState = tpv.ServiceState
    , AccountState = ta.ServiceState
    , StateMatch = CASE WHEN tpv.ServiceState = ta.ServiceState THEN 'YES' ELSE 'NO' END
    INTO #Results
FROM #TPVFileData tpv 
LEFT JOIN lp_account..account a (nolock) on ltrim(rtrim(tpv.VerificationNumber)) = a.contract_nbr AND a.account_number = tpv.AccountNumber
LEFT JOIN lp_account..TblAccounts ta on ta.AccountNumber = a.Account_Number

--Gets contracts where something mismatch
SELECT DISTINCT TpvContractNumber 
INTO #BadContracts
FROM #Results 
WHERE AccountMatch = 'NO' 
	OR RateMatch = 'NO' 
	OR TermMatch = 'NO' 
	OR DateMatch = 'NO'

--Gets contracts where everything is good
SELECT DISTINCT TpvContractNumber
INTO #TPVAllGoodContracts
FROM #Results
WHERE TpvContractNumber NOT IN ( SELECT TpvContractNumber FROM #BadContracts )

-- 2 - Disposition TPV ---------------------------------------------------------------------------------------------------

--Declare cursor variables	
DECLARE @tmp_contractNumber AS VARCHAR(50)
DECLARE @tmp_contractType AS INT
DECLARE @tmp_disposition AS VARCHAR(4)


--Create and open cursor
DECLARE tpv_cursor CURSOR FOR
	SELECT DISTINCT 'GOOD', good.TpvContractNumber, ContractDealTypeID
	FROM #TPVAllGoodContracts good
	JOIN LibertyPower..Contract c ON good.TpvContractNumber = c.Number
	UNION
	SELECT DISTINCT 'BAD', bad.TpvContractNumber, ContractDealTypeID
	FROM #BadContracts bad
	JOIN LibertyPower..Contract c ON bad.TpvContractNumber = c.Number
	JOIN lp_enrollment..check_account ca ON c.Number = ca.contract_nbr and check_type = 'TPV' and approval_status = 'PENDING' -- Do not re-flag Incompletes as Incomplete.
	
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

END
