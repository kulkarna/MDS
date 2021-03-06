USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_merge_by_account_TEST_JMUNOZ]    Script Date: 10/09/2013 16:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Hugo Ramos
-- Create date: 8/5/2010
-- Description:	Merge contracts by account
-- based on [usp_contract_merge]
-- =============================================
-- Modified: Guy Gelin 06/27/2013
-- Updated insert statement to accomodate null customerid values
-- SR# : 1-134761177
-- =============================================
-- Modified: José Muñoz 10/10/2013
-- TFS 22609
-- Remove cursors for the procedeure and 
-- Replace the view "lp_account..Account" for the legacy tables.
-- =============================================

ALTER PROCEDURE [dbo].[usp_contract_merge_by_account]

@p_contract_nbr_retain		char(12),
@p_account_nbr_merge_list	varchar(1000),
@p_utility_nbr_merge_list	varchar(1000)

AS
BEGIN 

	SET NOCOUNT ON

	BEGIN TRY
	
		DECLARE	@w_account_nbr								char(30),
				@w_contract_nbr								char(30),
				@w_contract_nbr_check_account				char(12),
				@w_contract_nbr_err_list					varchar(1000),
				@w_account_id								char(30),
				@w_error									char(01),
				@w_msg_id                                   char(08),
				@w_descp                                    varchar(250),
				@ProcessDate								DATETIME,
				@ContractIdRetain							INT,
				@ContractId									INT,
				@DateEnd									DATETIME,
				@Loop0										INT,
				@Loop1										INT,
				@Loop2										INT

		DECLARE @Contracts				TABLE (	contract_nbr char(20))
		DECLARE @Accounts				TABLE (	account_id char(30))
		DECLARE @Utilities				TABLE (	utility_id char(20))
		CREATE TABLE #ContractsLoop		(Row INT IDENTITY (1,1) PRIMARY KEY, contract_nbr char(20))
		CREATE TABLE #AccountsLoop		(Row INT IDENTITY (1,1) PRIMARY KEY, account_id char(30))
		CREATE TABLE #CurLoop			(Row INT IDENTITY (1,1) PRIMARY KEY, value varchar(100))

		SELECT @w_error										= 'N'
				,@w_msg_id									= '00000001'
				,@w_descp									= ' '
				,@w_contract_nbr_err_list					= ''
				,@ProcessDate								= GETDATE()

		-----------------------------------------------------------------------
		--  BEGIN CHECK ACCOUNT STEP VERIFICATION  ----------------------------
		-----------------------------------------------------------------------

		INSERT @Utilities (utility_id)
			SELECT DISTINCT value FROM lp_account.dbo.ufn_split_delimited_string (@p_utility_nbr_merge_list, ',')

		INSERT INTO #CurLoop (value)
		SELECT value FROM lp_account.dbo.ufn_split_delimited_string (@p_account_nbr_merge_list, ',')
		
		SET @Loop0 = 1
		
		-- loop through contract numbers in array
		WHILE @Loop0 <= (SELECT MAX(Row) FROM #CurLoop WITH (NOLOCK)) 
		BEGIN 
		
			SELECT @w_account_nbr =  Value
			FROM #CurLoop WITH (NOLOCK)
			WHERE Row			= @Loop0
			
			INSERT INTO @Accounts (account_id) 
			SELECT TOP 1 AccountIdLegacy FROM Libertypower..Account WITH (NOLOCK) 
			WHERE AccountNumber				= @w_account_nbr 
			AND UtilityId					IN (SELECT ID FROM LibertyPower..Utility UT WITH (NOLOCK)
												WHERE UT.UtilityCode  IN ( SELECT DISTINCT utility_id FROM @Utilities))
			AND CurrentContractID			IS NOT NULL											
			
			-- determine if contract is in a check account step
			SELECT	@w_contract_nbr_check_account	= contract_nbr
			FROM	lp_enrollment..check_account CA WITH (NOLOCK)
			WHERE	CA.contract_nbr					= (SELECT TOP 1 NUMBER
														FROM Libertypower..Contract CC WITH (NOLOCK)
														INNER JOIN Libertypower..Account AA WITH (NOLOCK)
														ON AA.CurrentContractID		= CC.ContractID
														WHERE AA.AccountNumber		= @w_account_nbr 
														AND AA.UtilityID			IN (SELECT ID FROM LibertyPower..Utility UT WITH (NOLOCK)
																						WHERE UT.UtilityCode  IN ( SELECT DISTINCT utility_id FROM @Utilities))
														AND AA.CurrentContractID	IS NOT NULL)
			AND		LTRIM(RTRIM(CA.approval_status)) NOT IN ('APPROVED', 'REJECTED')
			
			-- if so, then add to contract number string
			IF	@@ROWCOUNT > 0
			BEGIN
				SET	@w_contract_nbr_err_list = 
				CASE WHEN LEN(@w_contract_nbr_err_list) = 0 THEN @w_contract_nbr_check_account 
				ELSE @w_contract_nbr_err_list + ', ' + @w_contract_nbr_check_account END
			END

			SET @Loop0 = @Loop0 + 1
			
		END

		-- if contract number(s) were found to be in a check account step,
		-- cancel merge and return error message
		IF	LEN(@w_contract_nbr_err_list)					> 0
		BEGIN
			SELECT	@w_error								= 'E'
					,@w_msg_id								= '00000003'
			RAISERROR 50000 'Contract number(s) were found to be in a check account step'
		END
		-----------------------------------------------------------------------
		--  END CHECK ACCOUNT STEP VERIFICATION  ------------------------------
		-----------------------------------------------------------------------

		-----------------------------------------------------------------------
		--  BEGIN CONTRACT DATA UPDATES  --------------------------------------
		-----------------------------------------------------------------------
		BEGIN TRAN UpdateContractData

		--  LOOP TO UPDATE ACCOUNT DATA  --------------------------------------
		INSERT INTO #AccountsLoop (account_id)
		SELECT account_id FROM @Accounts
		
		SET @Loop1 = 1
		
		WHILE @Loop1 <= (SELECT MAX(Row) FROM #AccountsLoop WITH (NOLOCK)) 
		BEGIN 
		
			SELECT @w_account_id = account_id
			FROM #AccountsLoop WITH (NOLOCK)
			WHERE Row			= @Loop1 
			
			
			-- check if accounts are in renewal process
			IF EXISTS(	SELECT	NULL
						FROM Libertypower..Account WITH (NOLOCK) 
						WHERE	AccountIdLegacy				= @w_account_id 
						AND CurrentRenewalContractID		IS NOT NULL)					
			BEGIN
				SELECT	@w_error								= 'E'
						,@w_msg_id								= '00000002'
				RAISERROR 50000 'Contract in the renewal process.'
			END

			/* New Insert using legacy tables */
			INSERT INTO	lp_account..account_history
						(account_id, account_number, account_type, status, sub_status, customer_id, entity_id, 
						contract_nbr, contract_type, retail_mkt_id, utility_id, product_id, rate_id, rate, 
						account_name_link, customer_name_link, customer_address_link, customer_contact_link, 
						billing_address_link, billing_contact_link, owner_name_link, service_address_link, 
						business_type, business_activity, additional_id_nbr_type, additional_id_nbr, 
						contract_eff_start_date, term_months, date_end, date_deal, date_created, date_submit, 
						sales_channel_role, username, sales_rep, origin, annual_usage, date_flow_start, 
						date_por_enrollment, date_deenrollment, date_reenrollment, tax_status, tax_rate, 
						credit_score, credit_agency, por_option, billing_type, chgstamp, date_inserted)
			SELECT A.AccountIdLegacy
				,A.AccountNumber	
				,CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END
				,[Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus)
				,[Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(ACS.[Status], ACS.SubStatus)
				,A.CustomerIdLegacy
				,A.EntityID
				,C.Number
				,[Libertypower].[dbo].[ufn_GetLegacyContractType] ( CT.[Type] , CTT.ContractTemplateTypeID, CDT.DealType)
				,M.MarketCode
				,U.UtilityCode
				,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END
				,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID ELSE AC_DefaultRate.RateID END
				,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate ELSE AC_DefaultRate.Rate END
				,ISNULL(AddConNam.account_name_link,0)
				,ISNULL(AddConNam.customer_name_link,0)
				,ISNULL(AddConNam.customer_address_link,0)
				,ISNULL(AddConNam.customer_contact_link,0)
				,ISNULL(AddConNam.billing_address_link,0)
				,ISNULL(AddConNam.billing_contact_link,0)
				,ISNULL(AddConNam.owner_name_link,0)	
				,ISNULL(AddConNam.service_address_link,0)
				,LEFT(UPPER(isnull(BT.[Type],'NONE')),35)
				,LEFT(UPPER(isnull(BA.Activity,'NONE')),35)
				,LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbrType(CUST.Duns, CUST.EmployerId, CUST.TaxId, CUST.SsnEncrypted )
				,LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbr(CUST.Duns, CUST.EmployerId, CUST.TaxId, CUST.SsnEncrypted )
				,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END 
				,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term		ELSE AC_DefaultRate.Term	  END 
				,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END 
				,C.SignedDate			
				,A.DateCreated			
				,C.SubmitDate			
				,'SALES CHANNEL/' + SC.ChannelName 
				,USER1.UserName			
				,C.SalesRep		
				,A.Origin		
				,ISNULL(USAGE.AnnualUsage, (SELECT TOP 1 ISNULL(AnnualUsage, 0) FROM LibertyPower..AccountUsage WITH (NOLOCK) WHERE AccountID = A.AccountID ORDER BY EffectiveDate DESC))
				,LibertyPower.dbo.ufn_GetLegacyFlowStartDate(ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate )
				,AC.SendEnrollmentDate
				,LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (ACS.[Status], ACS.[SubStatus], ASERVICE.EndDate )
				,CAST('1900-01-01 00:00:00' AS DATETIME)
				,UPPER(TAX.[Status])
				,CAST(0 AS INT)
				,CAST(0 AS INT)
				,CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END
				,CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END
				,BILLTYPE.[Type]
				,CAST(0 AS INT)	
				,@ProcessDate
			FROM LibertyPower.dbo.Account A WITH (NOLOCK)
			JOIN LibertyPower.dbo.AccountDetail DETAIL	 WITH (NOLOCK)	ON DETAIL.AccountID = A.AccountID
			JOIN LibertyPower.dbo.[Contract] C	WITH (NOLOCK)				ON A.CurrentContractID = C.ContractID
			JOIN LibertyPower.dbo.AccountContract AC	WITH (NOLOCK)		ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
			JOIN LibertyPower.dbo.AccountContractCommission ACC	WITH (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID
			JOIN LibertyPower.dbo.AccountStatus ACS	WITH (NOLOCK)			ON AC.AccountContractID = ACS.AccountContractID
			JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
			LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
					   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
					   WHERE ACRR.IsContractedRate = 0 
					   GROUP BY ACRR.AccountContractID
					  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
			LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
			 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
			JOIN LibertyPower.dbo.ContractType CT			WITH (NOLOCK)	ON C.ContractTypeID = CT.ContractTypeID
			JOIN LibertyPower.dbo.Customer CUST				WITH (NOLOCK)	ON A.CustomerID = CUST.CustomerID
			JOIN LibertyPower.dbo.ContractTemplateType CTT	WITH (NOLOCK)	ON C.ContractTemplateID= CTT.ContractTemplateTypeID
			JOIN LibertyPower.dbo.AccountType AT			WITH (NOLOCK)	ON A.AccountTypeID = AT.ID
			JOIN LibertyPower.dbo.Utility U			WITH (NOLOCK)			ON A.UtilityID = U.ID
			JOIN LibertyPower.dbo.Market M			WITH (NOLOCK)			ON A.RetailMktID = M.ID
			LEFT JOIN lp_account.dbo.[vw_AccountAddressNameContactIds] AddConNam ON A.AccountID = AddConNam.AccountID -- this way boosts 100ms less
			LEFT JOIN LibertyPower.dbo.BusinessType BT		WITH (NOLOCK)		ON CUST.BusinessTypeID = BT.BusinessTypeID
			LEFT JOIN LibertyPower.dbo.BusinessActivity BA	WITH (NOLOCK)		ON CUST.BusinessActivityID = BA.BusinessActivityID
			LEFT JOIN LibertyPower.dbo.SalesChannel SC		WITH (NOLOCK)		ON C.SalesChannelID = SC.ChannelID
			LEFT JOIN LibertyPower.dbo.TaxStatus TAX		WITH (NOLOCK)		ON A.TaxStatusID = TAX.TaxStatusID
			LEFT JOIN LibertyPower.dbo.CreditAgency CA		WITH (NOLOCK)		ON CUST.CreditAgencyID = CA.CreditAgencyID	
			LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE	WITH (NOLOCK)		ON A.BillingTypeID = BILLTYPE.BillingTypeID
			LEFT JOIN LibertyPower.dbo.MeterType MT			WITH (NOLOCK)		ON A.MeterTypeID = MT.ID 
			LEFT JOIN LibertyPower.dbo.ContractDealType CDT		WITH (NOLOCK)	ON C.ContractDealTypeID = CDT.ContractDealTypeID
			LEFT JOIN LibertyPower.dbo.AccountUsage USAGE	WITH (NOLOCK)		ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate
			LEFT JOIN LibertyPower.dbo.UsageReqStatus URS	WITH (NOLOCK)		ON USAGE.UsageReqStatusID = URS.UsageReqStatusID
			LEFT JOIN LibertyPower.dbo.[User] ManagerUser  WITH (NOLOCK)	ON C.SalesManagerID = ManagerUser.UserID
			LEFT JOIN LibertyPower.dbo.[User] USER1		WITH (NOLOCK)		ON C.CreatedBy = USER1.UserID
			LEFT JOIN LibertyPower.dbo.[User] USER2		WITH (NOLOCK)		ON A.ModifiedBy = USER2.UserID
			LEFT JOIN LibertyPower.dbo.[User] USER3		WITH (NOLOCK)		ON A.CreatedBy = USER3.UserID
			LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
			WHERE A.AccountIdLegacy = @w_account_id

		   IF NOT EXISTS (	SELECT	account_id
							FROM	lp_account..account_comments WITH (NOLOCK)
							WHERE	account_id					= @w_account_id
							AND		process_id					= 'CONTRACT MERGE')
			BEGIN
				INSERT INTO	lp_account..account_comments		
				SELECT		@w_account_id, GETDATE(), 'CONTRACT MERGE', 'Merging with Contract ' + @p_contract_nbr_retain, (SELECT username FROM lp_account..account WHERE account_id = @w_account_id), 0
			END

			SET @Loop1		= @Loop1 + 1
			
		END

		----  LOOP TO UPDATE CONTRACT DATA  --------------------------------------
		INSERT INTO #ContractsLoop (contract_nbr)
		SELECT DISTINCT NUMBER
		FROM Libertypower..Contract CC WITH (NOLOCK)
		INNER JOIN Libertypower..Account AA WITH (NOLOCK)
		ON AA.CurrentContractID		= CC.ContractID
		WHERE AA.AccountIDLegacy	IN (SELECT account_id FROM @Accounts) 
		AND AA.UtilityID			IN (SELECT ID FROM LibertyPower..Utility UT WITH (NOLOCK)
										WHERE UT.UtilityCode  IN ( SELECT DISTINCT utility_id FROM @Utilities))
		AND AA.CurrentContractId	IS NOT NULL

		SET @Loop2 = 1
		
		-- loop through contract numbers in array
		WHILE @Loop2 <= (SELECT MAX(Row) FROM #ContractsLoop WITH (NOLOCK))
		BEGIN 
		
			SELECT @w_contract_nbr = contract_nbr
			FROM #ContractsLoop WITH (NOLOCK)
			WHERE Row				= @Loop2	
			
			-- insert into look-up table
			IF NOT EXISTS (	SELECT	NULL
							FROM	lp_account..contract_merge WITH (NOLOCK)
							WHERE	contract_nbr_retain = @p_contract_nbr_retain 
							AND		contract_nbr_merge	= @w_contract_nbr)
			BEGIN
				INSERT INTO	lp_account..contract_merge	(contract_nbr_retain, contract_nbr_merge)
				VALUES (@p_contract_nbr_retain, @w_contract_nbr)
			END

			SELECT @ContractIdRetain = ContractID 
			FROM Libertypower..Contract WITH (NOLOCK)
			WHERE Number			= @p_contract_nbr_retain
			
			SELECT @ContractId		= ContractID 
			FROM Libertypower..Contract WITH (NOLOCK)
			WHERE Number			= @w_contract_nbr
			
			SET @DateEnd = (SELECT TOP 1 ACR.RateEnd  
			FROM Libertypower..AccountContractRate ACR WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
			ON ACR.AccountContractID		= AC.AccountContractID 
			INNER JOIN Libertypower..Account AA WITH (NOLOCK)
			ON AA.AccountID					= AC.AccountID
			AND AA.CurrentContractID		= AC.ContractID
			INNER JOIN Libertypower..[Contract] CC WITH (NOLOCK)
			ON AC.ContractID				= CC.ContractID 
			WHERE CC.NUMBER					= @p_contract_nbr_retain)

			
			IF @ContractIdRetain  IS NOT NULL
			BEGIN
				-- update contract numbers and end dates
				
				UPDATE	libertypower..Account
				SET		CurrentContractID 	= @ContractIdRetain
				WHERE	CurrentContractID	= @ContractId
				AND		AccountIdLegacy IN (SELECT account_id FROM @Accounts)
				
				UPDATE LibertyPower.dbo.AccountContractRate
				SET RateEnd			= @DateEnd
				WHERE AccountContractRateID in (SELECT AAA.AccountContractRateID
				FROM (SELECT AA.AccountID, MAX(ACR.AccountContractRateID) AS AccountContractRateID
						FROM Libertypower..AccountContractRate ACR WITH (NOLOCK)
						INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
						ON ACR.AccountContractID		= AC.AccountContractID 
						INNER JOIN Libertypower..Account AA WITH (NOLOCK)
						ON AA.AccountID					= AC.AccountID
						AND AA.CurrentContractID		= AC.ContractID
						INNER JOIN Libertypower..[Contract] CC WITH (NOLOCK)
						ON AC.ContractID				= CC.ContractID 
						WHERE CC.NUMBER					= @p_contract_nbr_retain
						GROUP BY AA.AccountID) AS AAA)

				EXECUTE [lp_documents].[dbo].[usp_document_history_copy_by_contract]    @w_contract_nbr  ,@p_contract_nbr_retain ,'SYSTEM'

			END
			ELSE
			BEGIN
				SELECT	@w_error								= 'E'
						,@w_msg_id								= '00000002'
				RAISERROR 50000 'Contract not found'
			END

			SET @Loop2 = @Loop2 + 1
			
		END

		COMMIT TRAN UpdateContractData
		-----------------------------------------------------------------------
		--  END CONTRACT DATA UPDATES  ----------------------------------------
		-----------------------------------------------------------------------
		DROP TABLE #ContractsLoop 
		DROP TABLE #AccountsLoop 
		 
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN UpdateContractData

		SET @w_error								= 'E'
		
		IF @w_msg_id	not in ('00000003', '00000001')
			SET @w_msg_id							= '00000002'
			
		EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp output, 'ENROLLMENT'
		
	END CATCH

	SELECT	error										= @w_error,
			msg_id										= @w_msg_id,
			descp										= 
			CASE WHEN @w_msg_id = '00000001' THEN (@w_descp + ' Contract(s): ' + @w_contract_nbr_err_list) 
			WHEN @w_msg_id = '00000003' THEN @w_descp + ' Account: ' + @w_account_id ELSE @w_descp END

	SET NOCOUNT OFF

END
