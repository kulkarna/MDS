USE [ISTA]
GO
/****** Object:  StoredProcedure [dbo].[usp_process_enrollment_transactions]    Script Date: 09/18/2013 11:28:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************  
-- ProcessStatus can have the following statuses    
-- '0 - Processed Successfully'  
-- '0 - Historical Data.  Do not process.'  
-- '1 - Error:  ' + error  
-- '2 - No Logic To Handle This Transaction'  
--  
--  These are the transaction categories.  The category dictates how the transaction will be handled.  
-- @LP_TransactionID = 0 Transactions which do not cause any change.  
-- @LP_TransactionID = 1 De-enrollment  
-- @LP_TransactionID = 2 Enrollment  
-- @LP_TransactionID = 3 Change  
----------------------
--Rafael Vasques 03/13/2013 
--SR# 1-74136594
-----------------------
********************************************************************************
- Modify	: 09/26/2013   - José Muñoz  SWCS
- TFS Bug	: 19880
-			: Update the stored procedure: 
			- replace the view "lp_account..Account" to the legacy tables 
			- Replace four cursors to loop using temporary tables.
			- Update the script to update the account number, add the utility in the script.
********************************************************************************/  
  
ALTER Procedure [dbo].[usp_process_enrollment_transactions]  
AS  
BEGIN  

	SET NOCOUNT ON;	
	
	DECLARE @Account_ID					CHAR(12)  
		,@Account_Number				VARCHAR(30)  
		,@Request_Account_Number		VARCHAR(30)  
		,@Date_Flow_Start				DATETIME  
		,@Date_Deenrollment				DATETIME  
		,@RequestID						INT  
		,@Utility						VARCHAR(20)  
		,@LP_TransactionID				INT  
		,@Request_Or_Response_Flag		CHAR(1)  
		,@ChargeBack_Flag				TINYINT  
		,@Retention_Flag				TINYINT  
		,@Requires_Fix_Flag				TINYINT  
		,@Enrollment_Submission_Requeue TINYINT  
		,@LP_Reason_Code				VARCHAR(5)  
		,@RequestDate					DATETIME  
		,@TransactionDate				DATETIME  
		,@ProcessStatus					VARCHAR(50)  
		,@StatusReason					VARCHAR(100)  
		,@StatusCode					VARCHAR(100)  
		,@OldStatus						VARCHAR(15)  
		,@NewStatus						VARCHAR(15)  
		,@NewSubStatus					VARCHAR(15)  
		,@PowerMoveIndicator			VARCHAR(50)  
		,@SourceID						INT
		,@ChangeDESCription				VARCHAR(20)  
		,@ChangeReason					VARCHAR(20)  
		,@ServiceActionCode				VARCHAR(10)  
		,@w_msg_id						CHAR(8)  
		,@w_msg_DESC					VARCHAR(255)  
		,@return_value					INT
		,@w_error						CHAR(1)  
		,@w_DESCp						VARCHAR(250)  
		,@w_DESCp_add					VARCHAR(100)  
		,@p_result_ind					CHAR(1)  
		,@w_trans_id					BIGINT
		,@w_trans_id_output				BIGINT
		,@w_trans_date_id				CHAR(8)  
		,@w_phone						VARCHAR(20)  
  		,@old_number					VARCHAR(30)
  		,@new_number					VARCHAR(30)  
		,@tempdate						DATETIME
		,@SQLString						NVARCHAR(MAX)
		,@ParmDefinition				NVARCHAR(MAX)
		,@ProcessDate					DATETIME
		,@loop1							INT	-- ADD TFS BUG 19880 
		,@loop2							INT	-- ADD TFS BUG 19880 
		,@loop3							INT	-- ADD TFS BUG 19880 
		,@loop4							INT	-- ADD TFS BUG 19880 
		,@UtilityID						INT				-- ADD TFS BUG 19880 
		
	SET @ProcessDate = GETDATE()

	CREATE TABLE #CTR (RequestID			INT
				,UserID						INT
				,CustID						INT
				,PremID						INT
				,TransactionType			VARCHAR(10)
				,ActionCode					VARCHAR(4)
				,TransactionDate			DATETIME
				,Direction					BIT
				,RequestDate				DATETIME
				,ServiceActionCode			VARCHAR(10)
				,ServiceAction				VARCHAR(10)
				,StatusCode					VARCHAR(100)
				,StatusReason				VARCHAR(100)
				,SourceID					INT
				,TransactionNumber			VARCHAR(100)
				,ReferenceSourceID			INT
				,ReferenceNumber			VARCHAR(100)
				,OriginalSourceID			INT
				,ESIID						VARCHAR(100)
				,ResponseKey				INT
				,AlertID					INT
				,ProcessFlag				SMALLINT
				,ProcessDate				DATETIME
				,EventCleared				BIT
				,EventValidated				BIT
				,DelayedEventValidated		BIT
				,ConditionalEventValidated	BIT
				,TransactionTypeID			INT		
				,ProcessStatus				VARCHAR(50)
				,CreateDate					DATETIME)


	CREATE TABLE #number_change_cursor (Row			INT IDENTITY PRIMARY KEY
										,old		VARCHAR(30)
										,new		VARCHAR(30)
										,UtilityID	INT)

	CREATE TABLE #change_transaction_cursor (Row				INT IDENTITY PRIMARY KEY
											,ChangeDESCription	VARCHAR(100)
											,ChangeReason		VARCHAR(100))		
			
	CREATE TABLE #number_change_transaction_cursor ( Row				INT IDENTITY PRIMARY KEY
													,previousesiid		VARCHAR(30)
													,esiid				VARCHAR(30)
													,UtilityID			INT)

	INSERT INTO #CTR
	SELECT ctr.*
	FROM ISTA.dbo.CustomerTransactionRequest ctr WITH (NOLOCK)
	LEFT JOIN ISTA.dbo.tbl_814_Header h WITH (NOLOCK) ON ctr.SourceID = h.[814_key]
	WHERE ctr.transactiontype = 814 and ctr.direction = 1
	and (ProcessStatus like '2%' OR ProcessStatus is null)
	and not (ctr.transactiontypeid = 42 and ProcessStatus='2 - No Logic To Handle This Transaction')
	AND (h.ActionCode = 'C' OR (h.referencenbr like '%manual%' OR h.referencenbr like '%powermove%' OR h.referencenbr like '%polr%'))

	CREATE TABLE #temp (LP_TransactionID INT, RequestID INT, ProcessStatus VARCHAR(50), Date_Deenrollment DATETIME, Date_Flow_Start DATETIME)  
  
	CREATE TABLE #transaction_cursor (	Row								INT IDENTITY PRIMARY KEY
										,Account_ID						CHAR(15)
										,ESIID							VARCHAR(100)
										,date_flow_start				DATETIME
										,date_deenrollment				DATETIME
										,[status]						VARCHAR(10)
										,utility_id						VARCHAR(15)
										,RequestID						INT
										,RequestDate					DATETIME
										,TransactionDate				DATETIME
										,StatusReason					VARCHAR(100)
										,StatusCode						VARCHAR(100)
										,LP_TransactionID				INT
										,Request_Or_Response_Flag		CHAR(1)
										,ChargeBack						SMALLINT	
										,[Retention]					SMALLINT	
										,Requires_Fix					SMALLINT	
										,Enrollment_Submission_Requeue	SMALLINT	
										,Reason_Code					VARCHAR(200)
										,PowerMoveIndicator				VARCHAR(100)
										,SourceID						INT
										,ServiceActionCode				VARCHAR(10))  
  
	INSERT INTO #transaction_cursor (Account_ID,ESIID,date_flow_start,date_deenrollment,[status]
									,utility_id,RequestID,RequestDate,TransactionDate,StatusReason
									,StatusCode,LP_TransactionID,Request_Or_Response_Flag,ChargeBack
									,[Retention],Requires_Fix,Enrollment_Submission_Requeue,Reason_Code
									,PowerMoveIndicator,SourceID,ServiceActionCode)  
	SELECT  AA.AccountIdLegacy, ctr.ESIID
		,LibertyPower.dbo.ufn_GetLegacyFlowStartDate(ST.[Status], ST.[SubStatus], ASERVICE.StartDate ) AS date_flow_start	
		,LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (ST.[Status], ST.[SubStatus], ASERVICE.EndDate ) AS date_deenrollment	
		,ST.[Status], UT.UtilityCode   
		,ctr.RequestID, ctr.RequestDate, ctr.TransactionDate, ctr.StatusReason, ctr.StatusCode  
		,m.LP_TransactionID, m.Request_Or_Response_Flag  
		,rp.ChargeBack, rp.[Retention], rp.Requires_Fix, rp.Enrollment_Submission_Requeue, rp.Reason_Code  
		,h.referencenbr AS PowerMoveIndicator, ctr.SourceID, ctr.ServiceActionCode  
	FROM #CTR ctr  
	LEFT JOIN Libertypower..Account AA WITH (NOLOCK)
	ON AA.AccountNumber						= ctr.ESIID
	LEFT JOIN Libertypower..AccountContract AC WITH (NOLOCK)
	ON AC.ContractID						= AA.CurrentContractID 
	AND AC.AccountID						= AA.AccountID 
	LEFT JOIN Libertypower..AccountStatus ST WITH (NOLOCK)
	ON ST.AccountContractID					= AC.AccountContractID 
	LEFT JOIN Libertypower..Utility UT WITH (NOLOCK)
	ON UT.ID								= AA.UtilityID 
	LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) 
	ON ASERVICE.AccountID					= AA.AccountID
	LEFT JOIN LibertyPower.dbo.Market MA WITH (NOLOCK)			
	ON MA.ID								= AA.RetailMktID
	LEFT JOIN ISTA.dbo.tbl_814_Header (NOLOCK) h ON ctr.SourceID = h.[814_key]  
	LEFT JOIN ISTA.dbo.tbl_814_Service (NOLOCK) s ON ctr.SourceID = s.[814_key]  
	LEFT JOIN lp_enrollment.dbo.load_rqst_fld_CONVERT (NOLOCK) r ON LTRIM(RTRIM(REPLACE(r.field_value,' ',''))) = LTRIM(RTRIM(REPLACE(ISNULL(ctr.StatusReason, ctr.StatusCode),' ','')))  
	LEFT JOIN lp_enrollment.dbo.reason_code_properties (NOLOCK) rp ON r.field_value_conv = rp.reason_code  
	LEFT JOIN ISTA.dbo.lp_transaction_mapping (NOLOCK) m   
	ON  m.TransactionTypeID = ctr.TransactionTypeID   
	AND (m.ServiceActionCode = CASE WHEN ctr.ServiceActionCode in (SELECT ServiceActionCode FROM ISTA.dbo.lp_transaction_mapping WITH(NOLOCK) WHERE TransactionTypeID = ctr.TransactionTypeID)  
		 THEN ctr.ServiceActionCode  
		 ELSE 'ALL' END)  
	AND (m.StatusCode        = CASE WHEN ctr.StatusCode in (SELECT StatusCode FROM ISTA.dbo.lp_transaction_mapping WHERE TransactionTypeID = ctr.TransactionTypeID)  
		 THEN ctr.StatusCode  
		 ELSE 'ALL' END)  
	WHERE (s.ServiceType2 <> 'HU' OR MA.MarketCode = 'NY')  
	AND	(LP_TransactionID = 2 
		AND (h.referencenbr like '%manual%' OR h.referencenbr like '%powermove%' OR h.referencenbr like '%polr%')  
		OR  m.LP_TransactionID = 3)  
	ORDER BY ctr.RequestID  
  
	SET @loop1 = 1
	
	WHILE @loop1 <= (SELECT MAX(Row) from #transaction_cursor WITH (NOLOCK))
	BEGIN

		------------------ BEGIN LOOP  
		SELECT 	@Account_ID								= Account_ID
				,@Account_Number						= ESIID
				,@Date_Flow_Start						= Date_Flow_Start
				,@Date_Deenrollment						= Date_Deenrollment
				,@OldStatus								= [status]
				,@Utility								= utility_id
				,@RequestID								= RequestID
				,@RequestDate							= RequestDate
				,@TransactionDate						= TransactionDate
				,@StatusReason							= StatusReason
				,@StatusCode							= StatusCode
				,@LP_TransactionID						= LP_TransactionID
				,@Request_Or_Response_Flag				= Request_Or_Response_Flag
				,@ChargeBack_Flag						= ChargeBack
				,@Retention_Flag						= [Retention]
				,@Requires_Fix_Flag						= Requires_Fix
				,@Enrollment_Submission_Requeue			= Enrollment_Submission_Requeue
				,@LP_Reason_Code						= Reason_Code
				,@PowerMoveIndicator					= PowerMoveIndicator
				,@SourceID								= SourceID
				,@ServiceActionCode						= ServiceActionCode
		FROM #transaction_cursor WITH (NOLOCK)
		WHERE Row										= @loop1
					
		SELECT @RequestDate		= ISNULL(@RequestDate,@TransactionDate)  
			,@ProcessStatus		= '2 - No Logic To Handle This Transaction'  
		
		SELECT @StatusCode = field_value_conv FROM lp_enrollment.dbo.load_rqst_fld_CONVERT  WITH (NOLOCK) 
		WHERE LTRIM(RTRIM(REPLACE(field_value,' ',''))) = LTRIM(RTRIM(REPLACE(ISNULL(@StatusReason, @StatusCode),' ','')))  
		
		SET @StatusCode =  ISNULL(@StatusCode,'NONE')  
		
		----------------------------- ENROLLMENT TRANSACTIONS ------------------------------  
		--SELECT * FROM lp_enrollment..load_set_number_accepted  
		IF @LP_TransactionID = 2 AND (@PowerMoveIndicator LIKE '%manual%' OR @PowerMoveIndicator LIKE '%powermove%')  
		BEGIN   
			INSERT INTO lp_enrollment..load_set_number_accepted  
			SELECT DISTINCT   
				'CONSOLIDATED EDISON OF NEW YORK(006982359)' AS utility   
				, @Account_Number AS util_account   
				--, H.crName + '(' + H.CrDuns + ')' AS esco, NULL AS esco_acct  
				, 'LIBERTYPOWER HOLDINGS LLC(784087293)' AS esco, NULL AS esco_acct  
				, REPLACE(ISNULL(n_addr.EntityName,n_phone.EntityName),'^^^^PS','') AS name  
				, ISNULL(ISNULL(n_addr.Address1,n_phone.Address1),'') + ' ' + ISNULL(ISNULL(n_addr.Address2,n_phone.Address2),'') + '|'   
						  + ISNULL(n_addr.City,n_phone.City) + '|' + ISNULL(n_addr.State,n_phone.State) + '|' + ISNULL(n_addr.PostalCode, n_phone.PostalCode) + '|' + '|'   
				 + ISNULL(n_phone.ContactPhoneNbr1,'') AS serv_addr  
				, NULL AS bill_addr  
				, @TransactionDate AS transmission_date  
				, NULL AS trns_type, NULL AS trns_purp, NULL AS reason, NULL AS servtype  
				, @RequestDate AS trans_eff_date   
				, NULL AS billing_party, NULL AS billing_type  
				, NULL AS read_cycle, m.MeterCycle AS meter_cycle, NULL AS marketer_rate  
				, ra.rate_class AS utility_rate_class, m.LoadProfile AS load_profile, NULL AS meter, NULL AS meter_ticket_number  
				, NULL AS blank1, NULL AS blank2, NULL AS blank3  
				, NULL AS human_needs_cust, s.LBMPZone AS nyiso_area, NULL AS taxed_residential, NULL AS tax_status, NULL AS life_support_cust  
				, NULL AS budget_billing, NULL AS partial_participation  
				, NULL AS comments, NULL AS cubs_rate, NULL AS fee_approved, NULL AS utility_sub_class, NULL AS meter_type  
				, NULL AS old_information  
				, 'MANUAL - POWERMOVE' AS power_move  
				, NULL AS tracking_number  
				, ' ' AS process_status  
				, s.ESPCommodityPrice  
			FROM tbl_814_Header h   WITH(NOLOCK)
			INNER JOIN tbl_814_Service s WITH(NOLOCK) on h.[814_key] = s.[814_key]  
			LEFT JOIN tbl_814_Service_Meter m WITH(NOLOCK) on s.Service_key = m.Service_key  
			LEFT JOIN tbl_814_Name n_addr WITH(NOLOCK) on h.[814_key] = n_addr.[814_key] and n_addr.contactcode is NULL  
			LEFT JOIN tbl_814_Name n_phone WITH(NOLOCK) on h.[814_key] = n_phone.[814_key] and n_phone.contactcode = 'TE'  
			LEFT JOIN lp_common..common_utility u WITH(NOLOCK) on h.tdspduns = u.duns_number  
			LEFT JOIN lp_risk..risk_accounts_listing ra WITH(NOLOCK) on s.esiid = ra.account_number  
			WHERE h.[814_key] = @SourceID and h.crDuns = '784087293'  

			SET @ProcessStatus = '0 - Processed Successfully ' + CONVERT(VARCHAR(50),@ProcessDate)  
		END  
		
		IF @LP_TransactionID = 2 AND (@PowerMoveIndicator LIKE '%POLR%')  
		BEGIN   
			INSERT INTO lp_enrollment..load_set_number_accepted  
			SELECT DISTINCT   
				--u.utility_id + '(' + u.duns_number + ')' AS utility   
				u.duns_number AS utility   
				, @Account_Number AS util_account   
				--, H.crName + '(' + H.CrDuns + ')' AS esco, NULL AS esco_acct  
				, 'LPT  LLC (6116339131000)' AS esco, NULL AS esco_acct  
				, REPLACE(ISNULL(n_addr.EntityName,n_phone.EntityName),'^^^^PS','') AS name  
				, ISNULL(ISNULL(n_addr.Address1,n_phone.Address1),'') + ' ' + ISNULL(ISNULL(n_addr.Address2,n_phone.Address2),'') + '|'   
						  + ISNULL(n_addr.City,n_phone.City) + '|' + ISNULL(n_addr.State,n_phone.State) + '|' + ISNULL(n_addr.PostalCode, n_phone.PostalCode) + '|' + '|'   
				 + ISNULL(n_phone.ContactPhoneNbr1,'') AS serv_addr  
				, NULL AS bill_addr  
				, @TransactionDate AS transmission_date  
				, NULL AS trns_type, NULL AS trns_purp, NULL AS reason, NULL AS servtype  
				, @RequestDate AS trans_eff_date   
				, NULL AS billing_party, NULL AS billing_type  
				, NULL AS read_cycle, m.MeterCycle AS meter_cycle, NULL AS marketer_rate  
				, ra.rate_class AS utility_rate_class, m.LoadProfile AS load_profile, NULL AS meter, NULL AS meter_ticket_number  
				, NULL AS blank1, NULL AS blank2, NULL AS blank3  
				, NULL AS human_needs_cust, s.LBMPZone AS nyiso_area, NULL AS taxed_residential, NULL AS tax_status, NULL AS life_support_cust  
				, NULL AS budget_billing, NULL AS partial_participation  
				, NULL AS comments, NULL AS cubs_rate, NULL AS fee_approved, NULL AS utility_sub_class, NULL AS meter_type  
				, NULL AS old_information  
				, 'MANUAL - POLR' AS power_move  
				, NULL AS tracking_number  
				, ' ' AS process_status  
				, s.ESPCommodityPrice  
			FROM tbl_814_Header h WITH (NOLOCK)   
			INNER JOIN tbl_814_Service s WITH (NOLOCK) ON h.[814_key] = s.[814_key]  
			LEFT JOIN tbl_814_Service_Meter m WITH (NOLOCK) ON s.Service_key = m.Service_key  
			LEFT JOIN tbl_814_Name n_addr WITH (NOLOCK) ON h.[814_key] = n_addr.[814_key] and n_addr.contactcode is NULL  
			LEFT JOIN tbl_814_Name n_phone WITH (NOLOCK) ON h.[814_key] = n_phone.[814_key] and n_phone.contactcode = 'TE'  
			LEFT JOIN lp_common..common_utility u WITH (NOLOCK) ON h.tdspduns = u.duns_number  
			LEFT JOIN lp_risk..risk_accounts_listing ra WITH (NOLOCK) ON s.esiid = ra.account_number  
			WHERE h.[814_key] = @SourceID   

			SET @ProcessStatus = '0 - Processed Successfully ' + CONVERT(VARCHAR(50),@ProcessDate)  
		END  
		
		------------------------------- CHANGE TRANSACTIONS --------------------------------  
		------------------------------------------------------------------------------------  
		-- Change Accept for Enrollment Date   7 Request, U Reject, WQ Accept  
		IF @LP_TransactionID = 3  
		BEGIN  

			TRUNCATE TABLE #change_transaction_cursor

			INSERT INTO #change_transaction_cursor (ChangeDESCription, ChangeReason)
			SELECT c.ChangeDESCription, c.ChangeReason  
			FROM ISTA..tbl_814_Service s WITH (NOLOCK) 
			LEFT JOIN ISTA..tbl_814_Service_Account_Change c WITH (NOLOCK) 
			ON s.service_key = c.service_key  
			WHERE s.[814_Key] = @SourceID  

			SET @loop2 = 1
			
			WHILE @loop2 <= (SELECT MAX(Row) FROM #change_transaction_cursor WITH (NOLOCK))
			BEGIN
			
				SELECT @ChangeDESCription				= ChangeDESCription
					,@ChangeReason						= ChangeReason
				FROM #change_transaction_cursor WITH (NOLOCK)
				WHERE Row								= @loop2
				ORDER BY Row
			
				IF (@ChangeDESCription = 'REFRP' OR @ChangeReason = 'REFRP')  
				BEGIN  
					--SELECT @w_phone = ContactPhone FROM lp_account.dbo.tblAccounts WITH (NOLOCK) WHERE Account_ID = @Account_ID  

					SELECT @w_phone			= C.phone
					FROM LibertyPower.dbo.Contact C WITH (NOLOCK)
					INNER JOIN LibertyPower.dbo.CustomerContact CC WITH (NOLOCK)	
					ON C.ContactID			= CC.ContactID
					INNER JOIN LibertyPower.dbo.Account  AA WITH (NOLOCK)			
					ON CC.CustomerID = AA.CustomerID
					WHERE AA.AccountIdLegacy  = @Account_ID 

					EXEC @return_value = lp_enrollment.dbo.usp_retention_header_ins 'SYSTEM', @w_phone, @Account_ID, ' ', 0, 0, 'L', '020', 'NONE', '19000101','BATCH',' ',' ',' ','N'  

					IF @return_value = 0  
						SET @ProcessStatus = '0 - Processed Successfully ' + CONVERT(VARCHAR(50),@ProcessDate)  
					ELSE  
						SET @ProcessStatus = '1 - Error:  ' + @w_DESCp + ' ' + CONVERT(VARCHAR(50),@ProcessDate)  
				END  

				-- Period Start Date Change  
				IF (@ChangeDESCription = 'DTM150' OR @ChangeReason = 'DTM150')   
				BEGIN  
					SELECT @tempdate = case when LTRIM(RTRIM(EsiidStartDate))<>'' then EsiidStartDate else SpecialReadSwitchDate end  
					FROM tbl_814_Service s WITH(NOLOCK) WHERE  s.[814_Key] = @SourceID   
					
					IF LTRIM(RTRIM(@tempdate))<>'' and @tempdate is not NULL  
					BEGIN  
						--UPDATE lp_account..account SET date_flow_start = @tempdate WHERE Account_ID = @Account_ID  commented TFS BUG 19880 

						UPDATE Libertypower..AccountService  
						SET StartDate			= @tempdate  
						WHERE AccountServiceID	= (	SELECT TOP 1 AccountServiceID FROM Libertypower..AccountService WITH (NOLOCK)
													WHERE account_id = @Account_ID   
													ORDER BY StartDate DESC,EndDate DESC,AccountServiceID DESC)  

						--Begin Rafael Vasques 03/13/2013 SR# 1-74136594
						UPDATE LibertyPower..AccountContractRate  
						SET RateStart			= @tempdate 
						FROM LibertyPower..AccountContractRate ACR WITH (NOLOCK)  
						INNER JOIN LibertyPower..AccountContract AC WITH (NOLOCK)  
						ON AC.AccountContractID    = ACR.AccountContractID   
						INNER JOIN LibertyPower..Account AA WITH (NOLOCK)  
						ON AA.AccountID				= AC.AccountID   
						AND AA.CurrentContractID	= AC.ContractID   
						INNER JOIN LibertyPower..Contract CC WITH (NOLOCK)  
						ON CC.ContractID			= AC.ContractID   
						WHERE AA.AccountIdLegacy    = @Account_ID   
						AND ACR.IsContractedRate	= 1   
						--End
						SET @ProcessStatus = '0 - Processed Successfully ' + CONVERT(VARCHAR(50),@ProcessDate)  
					END  
				END  
				
				-- Period End Date Change  
				IF (@ChangeDESCription = 'DTM151' OR @ChangeReason = 'DTM151')   
				BEGIN  
					SELECT @tempdate = EsiidEndDate 
					FROM tbl_814_Service s WITH(NOLOCK) 
					WHERE  s.[814_Key] = @SourceID   
					
					IF LTRIM(RTRIM(@tempdate)) <>'' and @tempdate is not NULL  
					BEGIN  
						--UPDATE lp_account..account SET date_deenrollment = @tempdate WHERE Account_ID = @Account_ID  commented ticket number #

						UPDATE Libertypower..AccountService  
						SET EndDate				= @tempdate  
						WHERE AccountServiceID	= (	SELECT TOP 1 AccountServiceID 
													FROM Libertypower..AccountService WITH(NOLOCK) 
													WHERE account_id = @Account_ID   
													ORDER BY StartDate DESC,EndDate DESC,AccountServiceID DESC)  

						SET @ProcessStatus = '0 - Processed Successfully ' + CONVERT(VARCHAR(50),@ProcessDate)  
					END  
				END  
				
				SET @loop2 = @loop2 + 1
				
			END --@loop2 <= (SELECT MAX(Row) FROM #change_transaction_cursor)

			---- Account Number Changes  
			
			TRUNCATE TABLE #number_change_transaction_cursor
			
			INSERT INTO #number_change_transaction_cursor (previousesiid, esiid, UtilityID)
			SELECT DISTINCT previousesiid, esiid, u.ID AS UtilityID
			FROM tbl_814_Service s WITH (NOLOCK) 
			INNER JOIN ISTA..tbl_814_Header h WITH (NOLOCK) on s.[814_key] = h.[814_key]
			INNER JOIN LibertyPower..Utility u WITH (NOLOCK) on h.tdspduns = u.dunsnumber
			WHERE s.[814_Key] = @SourceID  
			AND s.previousesiid IS NOT NULL AND s.esiid IS NOT NULL  
			ORDER BY previousesiid

			SET @loop3 = 1

			WHILE @loop3 <= (SELECT MAX(Row) FROM #number_change_transaction_cursor WITH (NOLOCK))
			BEGIN  
			
				SELECT @old_number					= previousesiid 
					,@new_number					= esiid
					,@UtilityID						= UtilityID 
				FROM #number_change_transaction_cursor WITH (NOLOCK)
				WHERE Row							= @loop3
			
				IF EXISTS(SELECT * FROM LibertyPower..Account WITH (NOLOCK) WHERE accountnumber = @old_number AND UtilityID = @UtilityID)  
				AND NOT EXISTS (SELECT * FROM LibertyPower..Account WITH (NOLOCK) WHERE accountnumber = @new_number AND UtilityID = @UtilityID)  
				BEGIN  
					INSERT INTO lp_account.dbo.account_number_history  
					(account_id, transaction_date, old_account_number, new_account_number, date_created)  
					SELECT accountidLegacy, @ProcessDate, @old_number, @new_number, @ProcessDate  
					FROM LibertyPower.dbo.account WITH (NOLOCK)
					WHERE accountnumber		= @old_number  
					AND UtilityID			= @UtilityID
					 
					INSERT INTO lp_account.dbo.account_comments  
					(account_id   , date_comment, process_id     , comment   , username   , chgstamp)  
					SELECT accountidLegacy, @ProcessDate   , 'SYSTEM', 'Utility notification of account number change FROM '+ @old_number +' to '+ @new_number +'.', 'SYSTEM', 0         
					FROM LibertyPower.dbo.account  WITH (NOLOCK)
					WHERE accountnumber		= @old_number  
					AND UtilityID			= @UtilityID 
					
					UPDATE LibertyPower.dbo.account  
					SET accountnumber		= @new_number  
					WHERE accountnumber		= @old_number     
					AND UtilityID			= @UtilityID
					 
					IF @@rowcount = 0  
						SET @ProcessStatus = '0 - Processed Successfully ' + CONVERT(VARCHAR(50),@ProcessDate)  
					ELSE  
						SET @ProcessStatus = '1 - Error:  No records affected ' + CONVERT(VARCHAR(50),@ProcessDate)  
				END  
				
				SET @loop3 = @loop3 + 1
			END  

		END  

		INSERT INTO #temp  
		SELECT @LP_TransactionID, @RequestID, @ProcessStatus, @Date_Deenrollment, @Date_Flow_Start  

		SET @loop1 = @loop1 + 1
		
	END -- (SELECT MAX(Row) from #transaction_cursor)

 	
	-- We do the updating at the end instead of doing it in each loop.  
	UPDATE ISTA.dbo.CustomerTransactionRequest   
	SET ProcessStatus = t.ProcessStatus  
	FROM ISTA.dbo.CustomerTransactionRequest ctr  WITH (NOLOCK)
	JOIN #temp t WITH (NOLOCK) ON ctr.RequestID = t.RequestID  
	  
	-- MD086 Post Deployment change.   
	-- Jaime Forero  
	-- CODE REPLACED:  
	--update lp_account.dbo.account_contact  
	--set phone = REPLACE(REPLACE(REPLACE(REPLACE(w.phone,'-',''),' ',''),')',''),'(','')  
	--FROM lp_account.dbo.account a   
	--join lp_account.dbo.account_contact d ON d.account_id = a.account_id AND d.contact_link = a.customer_contact_link   
	--join lp_risk..web_account w ON a.account_number = w.account_number  
	--WHERE contract_type in ('POLR','POWER MOVE') and (len(d.phone) < 10 or d.phone is null)  
	  
	-- This will update the phone numbers for some PowerMove accounts which do not have a phone number.  
	--update C  
	--set phone = REPLACE(REPLACE(REPLACE(REPLACE(w.phone,'-',''),' ',''),')',''),'(','')  
	--FROM lp_account.dbo.account a   
	--join LibertyPower.dbo.Contact C ON C.ContactID = a.customer_contact_link --AND C.contact_link = a.customer_contact_link   
	--join lp_risk..web_account w ON a.account_number = w.account_number  
	--WHERE contract_type in ('POLR','POWER MOVE') and (len(C.phone) < 10 or C.phone is null)  

	/* Commented TFS BUG 19880
	UPDATE LibertyPower.dbo.Contact  
	SET  phone = REPLACE(REPLACE(REPLACE(REPLACE(w.phone,'-',''),' ',''),')',''),'(','')  
	FROM LibertyPower.dbo.Contact C WITH (NOLOCK)
	INNER JOIN lp_account.dbo.account A WITH (NOLOCK)  
	ON A.customer_contact_link		= C.ContactID 
	INNER JOIN lp_risk..web_account W WITH (NOLOCK)  
	ON W.account_number				= A.account_number
	WHERE contract_type in ('POLR','POWER MOVE') and (len(C.phone) < 10 or C.phone is null)  
	*/
	
	/* New code TFS BUG 19880 Begin */
	UPDATE LibertyPower.dbo.Contact  
	SET  phone = REPLACE(REPLACE(REPLACE(REPLACE(w.phone,'-',''),' ',''),')',''),'(','')  
	FROM LibertyPower.dbo.Contact C WITH (NOLOCK)
	INNER JOIN Libertypower..Customer CU WITH (NOLOCK)
	ON C.ContactID					= CU.ContactID 
	INNER JOIN Libertypower.dbo.Account A WITH (NOLOCK)  
	ON A.CustomerID					= CU.CustomerID
	INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
	ON AC.ContractID				= A.CurrentContractID 
	AND AC.AccountID				= A.AccountID 
	INNER JOIN Libertypower..[Contract] CC WITH (NOLOCK) 
	ON CC.ContractID				= AC.ContractID 
	INNER JOIN LibertyPower.dbo.ContractType CT WITH (NOLOCK) 
	ON CT.ContractTypeID			= CC.ContractTypeID 
	INNER JOIN lp_risk..web_account W WITH (NOLOCK)  
	ON W.account_number				= A.AccountNumber
	WHERE CT.[Type]  IN ('POLR','POWER MOVE', 'EDI') AND (LEN(C.phone) < 10 or C.phone is null)  
	AND A.UtilityID					= 18 -- Only CONED Accounts 
	/* New code TFS BUG 19880 End */
	
	-- END OF MD086 Change  
	  
	  
	--------------- California accountnumber change  
	SELECT *  
	INTO #header  
	FROM ista..tbl_814_header  WITH (NOLOCK)
	WHERE tdspduns in (SELECT dunsnumber FROM libertypower..utility WITH (NOLOCK) WHERE MarketID = 2) -- California  
	  
	SELECT s.*  
	INTO #service  
	FROM ista..tbl_814_service s  WITH (NOLOCK)
	join #header h WITH (NOLOCK) ON s.[814_key] = h.[814_key]  
	  
	TRUNCATE TABLE #number_change_cursor
											
	INSERT INTO #number_change_cursor (old, new)
	SELECT s2.esiid AS old, s.esiid AS new  
	FROM #header h WITH (NOLOCK) 
	JOIN #service s WITH (NOLOCK) ON s.[814_key] = h.[814_key]  
	JOIN #header h2 WITH (NOLOCK) ON h2.transactionnbr = h.referencenbr  
	JOIN #service s2 WITH (NOLOCK) ON s2.[814_key] = h2.[814_key] and s.esiid <> s2.esiid -- indicates account number change  
	JOIN Libertypower..Account a WITH (NOLOCK) ON a.AccountNumber = s2.esiid
	
	SET @loop4 = 1
	  
	WHILE @loop4 <= (SELECT MAX(Row) FROM #number_change_cursor WITH (NOLOCK))
	BEGIN  
	
		SELECT @old_number			= old
				,@new_number		= new 
				,@UtilityID			= UtilityID
		FROM #number_change_cursor	WITH (NOLOCK)
		WHERE Row					= @loop4
	
		INSERT INTO lp_account.dbo.account_number_history  
		(account_id, transaction_date, old_account_number, new_account_number, date_created)  
		SELECT AccountIdLegacy, @ProcessDate, @old_number, @new_number, @ProcessDate  
		FROM Libertypower.dbo.Account  WITH (NOLOCK) 
		WHERE AccountNumber		= @old_number  
		AND UtilityID			= @UtilityID
		
		INSERT INTO lp_account.dbo.account_comments  
		(account_id   , date_comment, process_id     , comment   , username   , chgstamp)  
		SELECT AccountIdLegacy, @ProcessDate   , 'MANUAL UPDATE', 'Utility notification of account number change FROM '+ @old_number +' to '+ @new_number +'.', 'SYSTEM', 0         
		FROM Libertypower.dbo.Account  WITH (NOLOCK) 
		WHERE AccountNumber 	= @old_number  
		AND UtilityID			= @UtilityID
		
		UPDATE LibertyPower..account  
		SET accountnumber		= @new_number  
		WHERE accountnumber		= @old_number    
		AND UtilityID			= @UtilityID 
	  
		SET @loop4 = @loop4 + 1
	  
	END  
	
	DROP TABLE #number_change_cursor
	DROP TABLE #change_transaction_cursor	  
	DROP TABLE #number_change_transaction_cursor	
	DROP TABLE #transaction_cursor	
	DROP TABLE #temp  
		
	SET NOCOUNT OFF;	
END