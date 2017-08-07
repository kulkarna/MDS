CREATE TABLE [dbo].[AccountStatus] (
    [AccountStatusID]   INT          IDENTITY (1, 1) NOT NULL,
    [AccountContractID] INT          NOT NULL,
    [Status]            VARCHAR (15) NOT NULL,
    [SubStatus]         VARCHAR (15) NOT NULL,
    [Modified]          DATETIME     CONSTRAINT [DF_AccountStatus_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]        INT          CONSTRAINT [DF_AccountStatus_ModifiedBy] DEFAULT ((0)) NOT NULL,
    [DateCreated]       DATETIME     CONSTRAINT [DF_AccountStatus_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         INT          NOT NULL,
    CONSTRAINT [PK_AccountStatus] PRIMARY KEY CLUSTERED ([AccountStatusID] ASC),
    CONSTRAINT [FK_AccountStatus_AccountContract] FOREIGN KEY ([AccountContractID]) REFERENCES [dbo].[AccountContract] ([AccountContractID]),
    CONSTRAINT [FK_AccountStatus_UserCreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_AccountStatus_UserModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_AccountStatus_AccountContractID_I]
    ON [dbo].[AccountStatus]([AccountContractID] ASC)
    INCLUDE([Status], [SubStatus]);


GO
CREATE NONCLUSTERED INDEX [IDX_Status]
    ON [dbo].[AccountStatus]([Status] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IDX_SubStatus]
    ON [dbo].[AccountStatus]([SubStatus] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [accountStatus_cover1]
    ON [dbo].[AccountStatus]([Status] ASC, [SubStatus] ASC, [AccountContractID] ASC, [AccountStatusID] ASC);


GO
-- =============================================
-- Author:		Jaime Forero
-- Create date: 10/21/2011
-- Description:	Replacement for trigger: tr_account_renewal_billing_notification_info_ins in the renewal table
-- Old comments from the trigger:
	-- =============================================
	-- Author:		Rick Deigsler
	-- Create date: 4/10/2007
	-- Description:	Insert billing info into account_renewal_billing_notification_info
	--				to be sent to billing.
-- ================================================
CREATE TRIGGER [dbo].[AfterUpdateRenewalBillingNotification]
   ON  [dbo].[AccountStatus]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @w_account_number			varchar(30)
	DECLARE @w_product_id				char(20)
	DECLARE @w_rate_id					int
	DECLARE @w_rate						float
	DECLARE @w_contract_eff_start_date	datetime
	DECLARE @w_date_end					datetime

	IF UPDATE([Status]) OR UPDATE([SubStatus])
	BEGIN
		-- lost ---------------------
		DECLARE curNotify CURSOR FOR
		
			SELECT  a.account_number, 
			a.product_id, 
			a.rate_id, 
			a.rate, 
			a.contract_eff_start_date, 
			a.date_end
			FROM INSERTED I
			JOIN LibertyPower.dbo.AccountContract AC ON I.AccountContractID = AC.AccountContractID
			JOIN lp_account..account a on AC.AccountID = a.AccountID
			WHERE  (I.[Status] = '07000' AND I.[SubStatus] = '10')
			AND a.account_number NOT IN
					( SELECT account_number	FROM lp_account..account_renewal_billing_notification_info WITH (NOLOCK) )
					
		OPEN curNotify 
		
		FETCH NEXT FROM curNotify INTO @w_account_number, @w_product_id, @w_rate_id, @w_rate, @w_contract_eff_start_date, @w_date_end
		WHILE (@@FETCH_STATUS <> -1) 
			BEGIN 
				INSERT INTO  lp_account..account_renewal_billing_notification_info
				SELECT  @w_account_number, @w_product_id, @w_rate_id, @w_rate, 
						@w_contract_eff_start_date, @w_date_end, 'PENDING'

				FETCH NEXT FROM curNotify INTO @w_account_number, @w_product_id, @w_rate_id, @w_rate, @w_contract_eff_start_date, @w_date_end
			END

		CLOSE curNotify 
		DEALLOCATE curNotify 
	END

END


GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table AuditAccountStatus
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountStatusUpdate]
	ON  [dbo].[AccountStatus]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @ColumnID				INT
			,@Columns				NVARCHAR(max)
			,@ObjectID				INT
			,@ColumnName			NVARCHAR(max)
			,@LastColumnID			INT
			,@ColumnsUpdated		VARCHAR(max)
			,@strQuery				VARCHAR(max)
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='AccountStatus')
	SET @LastColumnID				= (SELECT MAX(colid) FROM syscolumns with (nolock) WHERE id=@ObjectID)
	SET @ColumnID					= 1
	
	WHILE @ColumnID <= @LastColumnID 
	BEGIN
		
		IF (SUBSTRING(COLUMNS_UPDATED(),(@ColumnID - 1) / 8 + 1, 1)) &
		POWER(2, (@ColumnID - 1) % 8) = POWER(2, (@ColumnID - 1) % 8)
		begin
			SET @Columns = ISNULL(@Columns + ',', '') + COL_NAME(@ObjectID, @ColumnID)
		end
		set @ColumnID = @ColumnID + 1
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
-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/16/2011
-- Description:	This trigger replaces part of trigger tr_annual_usage_update

-- =============================================
CREATE TRIGGER [dbo].[AfterUpdateUsage]
   ON  [dbo].[AccountStatus]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @p_SubmittedUsageReqStatusID INT; 
	DECLARE @p_PendingUsageReqStatusID INT; 
	DECLARE @p_TexasRetailMktId INT; 
	DECLARE @contract_nbr VARCHAR(12)

	SELECT @p_TexasRetailMktId = ID FROM Libertypower.dbo.Market WHERE UPPER(MarketCode) = 'TX';
	
	SELECT @p_SubmittedUsageReqStatusID  =  URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS WHERE LTRIM(RTRIM(LOWER([Status]))) = 'submitted' ;
	SELECT @p_PendingUsageReqStatusID  =  URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS WHERE LTRIM(RTRIM(LOWER([Status]))) = 'pending' ;
	
	
	IF UPDATE([Status]) OR UPDATE(SubStatus)
	BEGIN
		UPDATE Libertypower.dbo.AccountUsage
		SET UsageReqStatusID = @p_SubmittedUsageReqStatusID
		FROM Libertypower.dbo.AccountUsage AU
		JOIN Libertypower.dbo.AccountContract AC ON AU.AccountID = AC.AccountID
		JOIN Inserted I ON AC.AccountContractID	= I.AccountContractID
		JOIN Account A	ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
		JOIN Utility U  ON A.UtilityID = U.ID
		WHERE I.[Status] in ('05000','06000') and I.SubStatus = '20' 
		AND AU.UsageReqStatusID = @p_PendingUsageReqStatusID 
		AND U.MarketID = @p_TexasRetailMktId
		;
	END

   
END

GO
-- =============================================
-- Author:		Jaime Forero
-- Create date: 6/28/2011
-- Description:	This trigger replaces functionality of legacy trigger: [insert_welcome_letter_into_queue]
-- Old description:
--			Author:		Eric Hernandez
--			Create date: 11-16-2006
--			Description:	Any time the an account status goes to the "Welcome Letter" status, the account number will be put into the welcome letter queue table.
--			9/3/2011 : Trigger was turned off in production
-- 
-- =============================================
CREATE TRIGGER [dbo].[AfterUpdateInsertWelcomeLetterIntoQueue]
   ON  dbo.AccountStatus
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	IF UPDATE([status]) OR UPDATE(SubStatus)
	BEGIN
		INSERT INTO lp_enrollment.dbo.welcome_letter_queue (account_id,account_number,date_created)
		SELECT A.AccountIdLegacy, A.AccountNumber, GETDATE()
		FROM Inserted I
		JOIN AccountContract AC ON I.AccountContractID	= AC.AccountContractID
		JOIN Account A			ON AC.AccountID			= A.AccountID
		WHERE I.[Status] in ('03000','04000') and I.SubStatus in ('20')
	END
END

GO
-- =============================================
-- Author:		Jaime Forero
-- Create date: 06/28/2011
-- Description:	trigger replacing [tr_account_renewal_status_upd]
-- OLD Comments:
	-- Author:		Rick Deigsler
	-- Create date: 3/22/2007

	-- Modified: 6/12/2007
	-- Add code to update renewal queue

	-- Description:	Change status and sub_status of renewal
	--				if account lost		(11000 50)(911000 10)
	--				or account saved	(05000 30)(06000 30)(905000 10)(906000 10)	
	--				update renewal queue to a loss if exists
	-- =============================================
	-- Modified 5/12/2009 Gail Mangaroo
	-- Added call to usp_comm_trans_detail_ins_auto
	-- =============================================
	-- Modified 9/29/2010 Jose Munoz
	-- Ticket : 18316
	--			- Renewal contracts being deleted by system post deal entry due to pending drop.
	--
	-- =============================================
	-- Modified 12/1/2010 Gail Mangaroo 
	-- Replaced commission call with call to lp_Commissions..usp_transaction_request_enrollment_process.
-- =============================================
CREATE TRIGGER [dbo].[AfterUpdateAccountRenewalStatus]
   ON  [dbo].[AccountStatus]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	DECLARE	@w_contract_nbr		char(12),
			@w_account_id		char(12),
			@w_username			nchar(100),
			@call_reason_code	varchar(5),
			@comment			varchar(MAX)
			-- ADD Ticket 18316
			,@account_number	VARCHAR(30)
			,@transaction_date	DATETIME
			,@date_submit		DATETIME
			,@utility_id		CHAR(15)
			-- ADD Ticket 18316
			
	IF UPDATE([Status]) OR UPDATE([SubStatus])
	BEGIN
		-- lost ---------------------
		DECLARE curLost CURSOR FOR
		SELECT	ar.contract_nbr, ar.account_id, ar.username ,ar.account_number, ar.date_submit, ar.utility_id  -- ADD Ticket 18316
		FROM	lp_account.dbo.account_renewal ar
		WHERE	ar.account_id 
		IN		(	SELECT	A.AccountIdLegacy
					FROM	Inserted I
					JOIN	LibertyPower.dbo.AccountContract AC ON	AC.AccountContractID = I.AccountContractID 
					JOIN	LibertyPower.dbo.Account		 A  ON	A.AccountID			 = AC.AccountID
					WHERE	([Status] = '11000'	 AND [SubStatus] = '50')
					OR		([Status] = '911000' AND [SubStatus] = '10')
					OR		([Status] = '999998' AND [SubStatus] = '10') -- ticket 21859 Added so that usage rejections can also cancel renewals.
					)
		AND NOT	(status = '07000' AND sub_status = '90') -- Renewal cancelled

		OPEN curLost 

		FETCH NEXT FROM curLost INTO @w_contract_nbr, @w_account_id, @w_username
		,@account_number, @date_submit, @utility_id -- ADD Ticket 18316

		WHILE (@@FETCH_STATUS <> -1) 
		BEGIN 
			-- If status or sub_status values have actually changed on update
			
			IF (SELECT TOP 1 [Status] FROM inserted I
				JOIN	LibertyPower.dbo.AccountContract AC ON	AC.AccountContractID = I.AccountContractID 
				JOIN	LibertyPower.dbo.Account		 A  ON	A.AccountID			 = AC.AccountID	
			    WHERE A.AccountIdLegacy = @w_account_id) 
			    <> 
			    (SELECT TOP 1 [Status] FROM Deleted D
			     JOIN	LibertyPower.dbo.AccountContract AC ON	AC.AccountContractID = D.AccountContractID 
				 JOIN	LibertyPower.dbo.Account		 A  ON	A.AccountID			 = AC.AccountID
			     WHERE A.AccountIdLegacy = @w_account_id)
			BEGIN
				-- if drop is in retention and...
				IF EXISTS (	SELECT TOP 1	call_reason_code
					FROM			lp_enrollment..retention_header WITH (NOLOCK)
					WHERE			account_id	= @w_account_id 
					AND				call_status		= 'O' )
					-- if it is in the renewal queue and is not closed, lose it
					AND EXISTS (SELECT TOP 1	call_reason_code
					FROM			lp_contract_renewal..renewal_header WITH (NOLOCK)
					WHERE			contract_nbr	= @w_contract_nbr 
					AND				(call_status	= 'O' OR call_status = 'A'))
				BEGIN
					DECLARE @dt		datetime
					SET		@dt		= GETDATE()

					-- get the reason code and comment for the drop from retention
					SELECT TOP 1	@call_reason_code = b.call_reason_code, @comment = b.comment
					FROM			lp_enrollment..retention_header a WITH (NOLOCK) INNER JOIN lp_enrollment..retention_comment b WITH (NOLOCK) ON a.call_request_id = b.call_request_id
					WHERE			a.account_id	= @w_account_id 
					AND				a.call_status	= 'O' 
					ORDER BY		a.date_created	DESC

					-- update renewal queue to a loss
					EXEC	lp_contract_renewal..usp_renewal_detail_upd @w_username, @w_contract_nbr, 'L', @call_reason_code, @w_username, 'NONE', @dt, '', @comment, '0', ''
				END

				/* ADD TICKET 18316 BEGIN */			
				SELECT TOP 1 @transaction_date	= isnull(t.transaction_date, '19000101')
				FROM integration.dbo.EDI_814_transaction t
				--INNER JOIN integration.dbo.utility u		-- COMMENTS TICKET 19914
				--ON t.utility_id	= u.utility_id
				INNER JOIN libertypower.dbo.utility u		-- ADD TICKET 19914
				ON t.utility_id	= u.[id]
				INNER JOIN integration.dbo.EDI_814_transaction_result tr 
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
					
					UPDATE	lp_account..account_renewal
					SET		status = '07000', sub_status = '90'
					WHERE	account_id = @w_account_id
				END
				/* ADD TICKET 18316 END */			
				
				DECLARE @RC int
			
				EXECUTE lp_commissions..usp_transaction_request_enrollment_process @w_account_id, @w_contract_nbr, null, null, 'RENEWAL CANCELLED',  @w_username

			END
			FETCH NEXT FROM curLost INTO @w_contract_nbr, @w_account_id, @w_username
			,@account_number, @date_submit, @utility_id -- ADD Ticket 18316
		END

		CLOSE curLost 
		DEALLOCATE curLost 
	END
	
END

GO
-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/15/2011
-- Description:	Part replacement for legacy trigger: tr_account_upd_ins
--			    The trigger had 2 operations, one was not linked to account status and was moved to the account table
--				The same logic is in the INSTEAD OF TRIGGER of the lp_account..account table and they both need to do the same

-- =============================================
CREATE TRIGGER [dbo].[AfterUpdateCheckDeenrollment]
   ON  [dbo].[AccountStatus]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE  @AccountNumber			VARCHAR(30)
			,@AccountID					CHAR(15)
			,@Message					VARCHAR(300)
    -- Insert statements for trigger here
-- check deenrollment date
	IF UPDATE([Status]) OR UPDATE(SubStatus)
	BEGIN
		SELECT  @AccountNumber = AA.AccountNumber
				, @AccountID =  AA.AccountID 
		FROM
			(SELECT A.AccountID, 
			 LibertyPower.dbo.ufn_GetLegacyDateDeenrollment ([Status], [SubStatus], ASERVICE.EndDate )AS date_deenrollment,
			A.AccountIdLegacy,
			A.AccountNumber 
			FROM inserted I
			JOIN Libertypower..AccountContract AC ON I.AccountContractID = AC.AccountContractID
			JOIN Libertypower..Account			A ON A.AccountID = AC.AccountID
			LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
			
			WHERE ([status]				= '911000'	and SubStatus = '10') 
			or 	  ([status]				= '11000'	and SubStatus = '50')	
			) AA
		WHERE AA.date_deenrollment = '1900-01-01'
		;
		IF @@ROWCOUNT > 0
		BEGIN
			ROLLBACK
			SET @Message	=	'The Account number ' + LTRIM(RTRIM(@AccountNumber)) + ' (' + LTRIM(RTRIM(@AccountID)) + ') is in De-Enrollement Done status or Pending De-enrollment Confirmed status and the De-Enrollment date is invalid.' 
			SET NOCOUNT OFF;
			RAISERROR 26001 @Message
		END
	END  
END

GO
-- =============================================================
-- Author		: Jaime Forero
-- Create date	: 12/01/2011
-- Description	: Insert audit row into audit table AuditAccountStatus
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountStatusInsert]
	ON  [dbo].[AccountStatus]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	

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
		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,'' -- [ColumnsUpdated]
		,''
	FROM inserted a
	
	SET NOCOUNT OFF;
END

GO
-- =============================================================
-- Author		: Jaime Forero
-- Create date	: 12/01/2011
-- Description	: Insert audit row into audit table AuditAccountStatus
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountStatusDelete]
	ON  [dbo].[AccountStatus]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
	

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
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,'' -- [ColumnsUpdated]
		,''
	FROM deleted a
	
	SET NOCOUNT OFF;
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Account', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountStatus';

