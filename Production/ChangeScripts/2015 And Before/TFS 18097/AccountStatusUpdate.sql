
USE [Libertypower]
GO

/* Drop trigger for Insert Operations */
/****** Object:  Trigger [zAuditAccountStatusUpdate]    Script Date: 09/25/2013 14:36:22 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[zAuditAccountStatusUpdate]'))
DROP TRIGGER [dbo].[zAuditAccountStatusUpdate]
GO

/****** Object:  Trigger [AfterUpdateAccountRenewalStatus]    Script Date: 09/25/2013 19:29:11 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[AfterUpdateAccountRenewalStatus]'))
DROP TRIGGER [dbo].[AfterUpdateAccountRenewalStatus]
GO

/****** Object:  Trigger [AfterUpdateCheckDeenrollment]    Script Date: 09/25/2013 19:29:34 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[AfterUpdateCheckDeenrollment]'))
DROP TRIGGER [dbo].[AfterUpdateCheckDeenrollment]
GO

/****** Object:  Trigger [AfterUpdateInsertWelcomeLetterIntoQueue]    Script Date: 09/25/2013 19:29:51 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[AfterUpdateInsertWelcomeLetterIntoQueue]'))
DROP TRIGGER [dbo].[AfterUpdateInsertWelcomeLetterIntoQueue]
GO

/****** Object:  Trigger [AfterUpdateRenewalBillingNotification]    Script Date: 09/25/2013 19:30:06 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[AfterUpdateRenewalBillingNotification]'))
DROP TRIGGER [dbo].[AfterUpdateRenewalBillingNotification]
GO

/****** Object:  Trigger [AfterUpdateUsage]    Script Date: 09/25/2013 19:30:23 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[AfterUpdateUsage]'))
DROP TRIGGER [dbo].[AfterUpdateUsage]
GO


/* Create e new trigger for Insert Operations */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: José Muñoz SWCS
-- Create date	: 09/26/2013
-- Description	: AccountStatus operation after Update row
-- =============================================
CREATE TRIGGER dbo.AccountStatusUpdate
   ON  dbo.AccountStatus
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	DECLARE @ColumnID						INT
			,@Columns						NVARCHAR(max)
			,@ObjectID						INT
			,@ColumnName					NVARCHAR(max)
			,@LastColumnID					INT
			,@ColumnsUpdated				VARCHAR(max)
			,@strQuery						VARCHAR(max)
			,@AccountNumber					VARCHAR(30)	
			,@AccountID						CHAR(15)
			,@Message						VARCHAR(300)
			,@p_SubmittedUsageReqStatusID	INT 
			,@p_PendingUsageReqStatusID		INT 
			,@p_TexasRetailMktId			INT
			,@contract_nbr					VARCHAR(12)
			,@Loop							INT
			,@dt							DATETIME
			,@RC							INT
			,@w_contract_nbr				CHAR(12)
			,@w_account_id					CHAR(12)
			,@w_username					NCHAR(100)
			,@call_reason_code				VARCHAR(5)
			,@comment						VARCHAR(MAX)
			-- ADD Ticket 18316
			,@account_number				VARCHAR(30)
			,@transaction_date				DATETIME
			,@date_submit					DATETIME
			,@utility_id					CHAR(15)
			-- ADD Ticket 18316
			
	SET @dt					= GETDATE()

	IF UPDATE([Status]) OR UPDATE(SubStatus)
	BEGIN
		/* Check Deenrollment BEGIN */		
		SELECT  @AccountNumber = AA.AccountIdLegacy, @AccountID =  AA.AccountID FROM
			(SELECT A.AccountID, 
			 LibertyPower.dbo.ufn_GetLegacyDateDeenrollment ([Status], [SubStatus], ASERVICE.EndDate )AS date_deenrollment,
			A.AccountIdLegacy
			FROM inserted I
			JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON I.AccountContractID = AC.AccountContractID
			JOIN Libertypower..Account			A WITH (NOLOCK) ON A.AccountID = AC.AccountID
			LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
			WHERE ([status]				= '911000'	and SubStatus = '10') 
			OR 	  ([status]				= '11000'	and SubStatus = '50')	
			) AA
		WHERE AA.date_deenrollment = '1900-01-01'
		
		IF @@ROWCOUNT > 0
		BEGIN
			ROLLBACK
			SET @Message	=	'The Account number ' + LTRIM(RTRIM(@AccountNumber)) + ' (' + LTRIM(RTRIM(@AccountID)) + ') is in De-Enrollement Done status or Pending De-enrollment Confirmed status and the De-Enrollment date is invalid.' 
			SET NOCOUNT OFF;
			RAISERROR 50000 @Message
		END
		/* Check Deenrollment END */
		
		/* AfterUpdateUsage BEGIN */		
		SELECT @p_TexasRetailMktId			= ID FROM Libertypower.dbo.Market WITH (NOLOCK) WHERE UPPER(MarketCode) = 'TX';
		SELECT @p_SubmittedUsageReqStatusID	= URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS WITH (NOLOCK) WHERE LTRIM(RTRIM(LOWER([Status]))) = 'submitted' ;
		SELECT @p_PendingUsageReqStatusID	= URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS WITH (NOLOCK) WHERE LTRIM(RTRIM(LOWER([Status]))) = 'pending' ;
		
		UPDATE Libertypower.dbo.AccountUsage
		SET UsageReqStatusID = @p_SubmittedUsageReqStatusID
		FROM Libertypower.dbo.AccountUsage AU WITH (NOLOCK) 
		JOIN Libertypower.dbo.AccountContract AC WITH (NOLOCK) ON AU.AccountID = AC.AccountID
		JOIN Inserted I WITH (NOLOCK) ON AC.AccountContractID	= I.AccountContractID
		JOIN Libertypower.dbo.Account A	WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
		JOIN Libertypower.dbo.Utility U  WITH (NOLOCK) ON A.UtilityID = U.ID
		WHERE I.[Status]			IN ('05000','06000') 
		AND I.SubStatus				= '20' 
		AND AU.UsageReqStatusID		= @p_PendingUsageReqStatusID 
		AND U.MarketID				= @p_TexasRetailMktId;
		/* AfterUpdateUsage END*/

		/* AfterUpdateRenewalBillingNotification BEGIN */
		INSERT INTO  lp_account..account_renewal_billing_notification_info
		SELECT  AA.AccountNumber
				,ACR.LegacyProductID
				,ACR.RateID
				,ACR.Rate
				,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END AS contract_eff_start_date
				,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END AS date_end
				,'PENDING'
		FROM Libertypower..Account AA WITH (NOLOCK)
		INNER JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK)
		ON AC.AccountID				= AA.AccountID
		AND AC.ContractID			= AA.CurrentContractID
		INNER JOIN Inserted	I
		ON I.AccountContractID		= AC.AccountContractID
		INNER JOIN Libertypower..AccountContractRate ACR WITH (NOLOCK)
		ON ACR.AccountContractID	= AC.AccountContractID
		INNER JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	
		ON ACR2.AccountContractID	=  AC.AccountContractID --AND ACR2.IsContractedRate = 1
		LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
				   FROM LibertyPower.dbo.AccountContractRate ACRR WITH (NOLOCK)
				   WHERE ACRR.IsContractedRate = 0 
				   GROUP BY ACRR.AccountContractID
				  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
		 ON AC_DefaultRate.AccountContractRateID	= ACRR2.AccountContractRateID 
		WHERE  I.[Status]			= '07000' 
		AND I.[SubStatus]			= '10'
		AND AA.AccountNumber NOT IN (SELECT account_number	
									FROM lp_account..account_renewal_billing_notification_info WITH (NOLOCK))
		/* AfterUpdateRenewalBillingNotification END */

		/*[AfterUpdateInsertWelcomeLetterIntoQueue BEGIN */
		INSERT INTO lp_enrollment.dbo.welcome_letter_queue (account_id,account_number,date_created)
		SELECT A.AccountIdLegacy, A.AccountNumber, GETDATE()
		FROM Inserted I
		JOIN Libertypower.dbo.AccountContract AC WITH (NOLOCK) 
		ON I.AccountContractID	= AC.AccountContractID
		JOIN Libertypower.dbo.Account A	WITH (NOLOCK) 
		ON AC.AccountID			= A.AccountID
		WHERE I.[Status]		IN ('03000','04000') 
		AND I.SubStatus			= '20'
		/* AfterUpdateInsertWelcomeLetterIntoQueue END */

		/* AfterUpdateAccountRenewalStatus  BEGIN */
		CREATE TABLE #curLost (	Row						INT IDENTITY(1,1) PRIMARY KEY
								,contract_nbr			VARCHAR(15)
								,account_id				CHAR(15)
								,username				VARCHAR(60)
								,account_number			VARCHAR(30)
								,date_submit			DATETIME
								,utility_id				CHAR(15))
		
		INSERT INTO #curLost
		SELECT CC.Number, AA.AccountIDLegacy, US.UserName,AA.AccountNumber, CC.SubmitDate, UT.UtilityCode
		FROM Libertypower..Account AA WITH (NOLOCK)
		INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
		ON AC.ContractID				= AA.CurrentRenewalContractID
		AND AC.AccountID				= AA.AccountId
		INNER JOIN Libertypower..[Contract] CC WITH (NOLOCK)
		ON CC.ContractID				= AC.ContractID
		INNER JOIN Libertypower..Utility UT WITH (NOLOCK)
		ON UT.ID						= AA.UtilityID
		LEFT JOIN LibertyPower.dbo.[User] US WITH (NOLOCK) 
		ON US.UserID					= CC.CreatedBy
		INNER JOIN Libertypower..AccountStatus ST WITH (NOLOCK)
		ON ST.AccountContractId			= AC.AccountContractID
		WHERE AA.AccountIDLegacy IN (SELECT	A.AccountIdLegacy
									FROM	Inserted I
									JOIN	LibertyPower.dbo.AccountContract AC WITH (NOLOCK) ON AC.AccountContractID = I.AccountContractID 
									JOIN	LibertyPower.dbo.Account		 A  WITH (NOLOCK) ON A.AccountID			 = AC.AccountID
									WHERE	(I.[Status] = '11000'  AND I.[SubStatus] = '50')
									OR		(I.[Status] = '911000' AND I.[SubStatus] = '10')
									OR		(I.[Status] = '999998' AND I.[SubStatus] = '10') -- ticket 21859 Added so that usage rejections can also cancel renewals.
									)
		AND NOT	(ST.[status] = '07000' AND ST.substatus = '90') -- Renewal cancelled

		SET @Loop = 1
	
		WHILE @Loop <= (SELECT MAX(Row) FROM #curLost WITH (NOLOCK))
		BEGIN

			SELECT @w_contract_nbr		= contract_nbr
				,@w_account_id			= account_id
				,@w_username			= username
				,@account_number		= account_number
				,@date_submit			= date_submit
				,@utility_id			= utility_id
			FROM #curLost WITH (NOLOCK)
			WHERE Row =  @Loop 
			
			IF (SELECT TOP 1 [Status] FROM inserted I
				JOIN	LibertyPower.dbo.AccountContract AC WITH (NOLOCK) ON	AC.AccountContractID = I.AccountContractID 
				JOIN	LibertyPower.dbo.Account		 A  WITH (NOLOCK) ON	A.AccountID			 = AC.AccountID	
			    WHERE A.AccountIdLegacy = @w_account_id) 
			    <> 
			    (SELECT TOP 1 [Status] FROM Deleted D
			     JOIN	LibertyPower.dbo.AccountContract AC WITH (NOLOCK) ON AC.AccountContractID = D.AccountContractID 
				 JOIN	LibertyPower.dbo.Account		 A  WITH (NOLOCK) ON A.AccountID		  = AC.AccountID
			     WHERE A.AccountIdLegacy = @w_account_id)
			BEGIN
				-- if drop is in retention and...
				IF EXISTS (	SELECT TOP 1	call_reason_code
					FROM			lp_enrollment..retention_header WITH (NOLOCK)
					WHERE			account_id		= @w_account_id 
					AND				call_status		= 'O' )
					-- if it is in the renewal queue and is not closed, lose it
					AND EXISTS (SELECT TOP 1	call_reason_code
					FROM			lp_contract_renewal..renewal_header WITH (NOLOCK)
					WHERE			contract_nbr	= @w_contract_nbr 
					AND				(call_status	= 'O' OR call_status = 'A'))
				BEGIN
					-- get the reason code and comment for the drop from retention
					SELECT TOP 1	@call_reason_code = b.call_reason_code, @comment = b.comment
					FROM			lp_enrollment..retention_header a WITH (NOLOCK) 
					INNER JOIN lp_enrollment..retention_comment b WITH (NOLOCK) 
					ON a.call_request_id = b.call_request_id
					WHERE			a.account_id	= @w_account_id 
					AND				a.call_status	= 'O' 
					ORDER BY		a.date_created	DESC

					-- update renewal queue to a loss
					EXEC	lp_contract_renewal..usp_renewal_detail_upd @w_username, @w_contract_nbr, 'L', @call_reason_code, @w_username, 'NONE', @dt, '', @comment, '0', ''
				END

				/* ADD TICKET 18316 BEGIN */			
				SELECT TOP 1 @transaction_date	= isnull(t.transaction_date, '19000101')
				FROM integration.dbo.EDI_814_transaction t WITH (NOLOCK)
				--INNER JOIN integration.dbo.utility u		-- COMMENTS TICKET 19914
				--ON t.utility_id	= u.utility_id
				INNER JOIN libertypower.dbo.utility u	WITH (NOLOCK)	-- ADD TICKET 19914
				ON t.utility_id	= u.[id]
				INNER JOIN integration.dbo.EDI_814_transaction_result tr WITH (NOLOCK)
				ON t.EDI_814_transaction_id = tr.EDI_814_transaction_id 
				WHERE t.account_number			= @account_number
				AND u.UtilityCode				= @utility_id
				AND tr.lp_transaction_id	IN (8, 6, 14) --  (8)Drop Request (6)Drop Acceptance (14)Usage Reject
				ORDER BY t.transaction_date DESC
				
				IF (@date_submit < @transaction_date)
				BEGIN			
					INSERT INTO	lp_account..account_status_history
					SELECT		@w_account_id, '07000', '90', GETDATE(), @w_username, 
								'RENEWAL', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', GETDATE() 
					
					UPDATE Libertypower..AccountStatus
					SET [status]			= '07000'
						,[substatus]		= '90'
					FROM Libertypower..AccountStatus AST WITH (NOLOCK)
					INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
					ON AC.AccountContractID		= AST.AccountContractID
					INNER JOIN Libertypower..Account AA WITH (NOLOCK)
					ON AA.CurrentRenewalContractID	= AC.ContractID
					AND AA.AccountID				= AC.AccountID
					WHERE AA.AccountIDLegacy		= @w_account_id
					
				END
				/* ADD TICKET 18316 END */			
			
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process @w_account_id, @w_contract_nbr, null, null, 'RENEWAL CANCELLED',  @w_username

			END

			SET @Loop = @Loop + 1
		END
		/* AfterUpdateAccountRenewalStatus  END */
		DROP TABLE #curLost
	END

	/* Insert information in the zAutdit table */			
	SET @ObjectID					= (SELECT id FROM sysobjects WITH (NOLOCK) WHERE name='AccountStatus')
	SET @LastColumnID				= (SELECT MAX(colid) FROM syscolumns WITH (NOLOCK) WHERE id=@ObjectID)
	SET @ColumnID					= 1
	
	WHILE @ColumnID <= @LastColumnID 
	BEGIN
		
		IF (SUBSTRING(COLUMNS_UPDATED(),(@ColumnID - 1) / 8 + 1, 1)) &
		POWER(2, (@ColumnID - 1) % 8) = POWER(2, (@ColumnID - 1) % 8)
		BEGIN
			SET @Columns = ISNULL(@Columns + ',', '') + COL_NAME(@ObjectID, @ColumnID)
		END
		SET @ColumnID = @ColumnID + 1
	END
		
	SET @ColumnsUpdated = @Columns
	
	IF @ColumnsUpdated  IS NULL
		SET @ColumnsUpdated = ''

	INSERT INTO [dbo].[zAuditAccountStatus] (
		[AccountStatusID] 
		,[AccountContractID]
		,[Status] 
		,[SubStatus]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		a.[AccountStatusID] 
		,a.[AccountContractID]
		,a.[Status] 
		,a.[SubStatus]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[AccountStatusID],0) <> ISNULL(b.[AccountStatusID],0) THEN 'AccountStatusID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AccountContractID],0) <> ISNULL(b.[AccountContractID],0) THEN 'AccountContractID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Status],'') <> ISNULL(b.[Status],'') THEN 'Status' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SubStatus],'') <> ISNULL(b.[SubStatus],'') THEN 'SubStatus' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> ISNULL(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> ISNULL(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> ISNULL(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> ISNULL(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	ON b.[AccountStatusID]	= a.[AccountStatusID]

	SET NOCOUNT OFF;
END
GO
