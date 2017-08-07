CREATE TABLE [dbo].[AccountUsage] (
    [AccountUsageID]   INT      IDENTITY (1, 1) NOT NULL,
    [AccountID]        INT      NOT NULL,
    [AnnualUsage]      INT      NULL,
    [UsageReqStatusID] INT      NOT NULL,
    [EffectiveDate]    DATETIME CONSTRAINT [DF_AccountUsage_EffectiveDate] DEFAULT (getdate()) NOT NULL,
    [Modified]         DATETIME CONSTRAINT [DF_AccountUsage_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]       INT      NULL,
    [DateCreated]      DATETIME CONSTRAINT [DF_AccountUsage_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        INT      NULL,
    CONSTRAINT [PK_AccountUsage] PRIMARY KEY NONCLUSTERED ([AccountUsageID] ASC),
    CONSTRAINT [FK_AccountUsage_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_AccountUsage_UsageReqStatus] FOREIGN KEY ([UsageReqStatusID]) REFERENCES [dbo].[UsageReqStatus] ([UsageReqStatusID]),
    CONSTRAINT [FK_AccountUsage_UserCreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_AccountUsage_UserModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_AccountID_EffectiveDate]
    ON [dbo].[AccountUsage]([AccountID] ASC, [EffectiveDate] ASC);


GO

-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/04/2011
-- Description	: Insert audit row into audit table AuditAccountUsage
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountUsageInsert]
	ON  [dbo].[AccountUsage]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccountUsage] (
		[AccountUsageID]
		,[AccountID]
		,[AnnualUsage]
		,[UsageReqStatusID]
		,[EffectiveDate]
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
		[AccountUsageID]
		,[AccountID]
		,[AnnualUsage]
		,[UsageReqStatusID]
		,[EffectiveDate]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM inserted
	
	SET NOCOUNT OFF;
END


GO

-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/04/2011
-- Description	: Insert audit row into audit table AuditAccountUsage
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountUsageDelete]
	ON  [dbo].[AccountUsage]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccountUsage] (
		[AccountUsageID]
		,[AccountID]
		,[AnnualUsage]
		,[UsageReqStatusID]
		,[EffectiveDate]
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
		[AccountUsageID]
		,[AccountID]
		,[AnnualUsage]
		,[UsageReqStatusID]
		,[EffectiveDate]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM deleted
	
	SET NOCOUNT OFF;
END


GO

-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/04/2011
-- Description	: Insert audit row into audit table AuditAccountUsage
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountUsageUpdate]
	ON  [dbo].[AccountUsage]
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='AccountUsage')
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

	INSERT INTO [dbo].[zAuditAccountUsage] (
		[AccountUsageID]
		,[AccountID]
		,[AnnualUsage]
		,[UsageReqStatusID]
		,[EffectiveDate]
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
		a.[AccountUsageID]
		,a.[AccountID]
		,a.[AnnualUsage]
		,a.[UsageReqStatusID]
		,a.[EffectiveDate]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[AccountUsageID],0) <> ISNULL(b.[AccountUsageID],0) THEN 'AccountUsageID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AccountID],0) <> ISNULL(b.[AccountID],0) THEN 'AccountID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AnnualUsage],0) <> ISNULL(b.[AnnualUsage],0) THEN 'AnnualUsage' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[UsageReqStatusID],0) <> ISNULL(b.[UsageReqStatusID],0) THEN 'UsageReqStatusID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EffectiveDate],'') <> ISNULL(b.[EffectiveDate],'') THEN 'EffectiveDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> ISNULL(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> ISNULL(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> ISNULL(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> ISNULL(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	ON a.[AccountUsageID] = b.[AccountUsageID]
	
	SET NOCOUNT OFF;
END


GO
-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/16/2011
-- Description:	Trigger replacing [tr_annual_usage_update]
-- =============================================
CREATE TRIGGER [dbo].[AfterUpdateAnnualUsage]
   ON  [dbo].[AccountUsage]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @p_contract_nbr VARCHAR(12);
	DECLARE @p_CompleteUsageReqStatusID INT;

	SELECT @p_CompleteUsageReqStatusID = UR.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus UR WHERE LTRIM(RTRIM(LOWER([Status]))) = 'complete';

	IF UPDATE(AnnualUsage)
	BEGIN
		
		-- UPDATE usage req status
		-- ==============================
		UPDATE LibertyPower.dbo.AccountUsage
		SET UsageReqStatusID = @p_CompleteUsageReqStatusID
		WHERE AnnualUsage > 0 AND AccountID IN (SELECT AccountID  FROM Inserted)
		-- Update usage for any accounts in renewal table that are the result of a 
		-- new account being added to a renewal contract.
		-- Removed as a result of ticket 19205
		--UPDATE	lp_account.dbo.account_renewal 
		--SET		annual_usage = i.annual_usage
		--FROM	lp_account.dbo.account_renewal r (NOLOCK) INNER JOIN 
		--(SELECT account_id, annual_usage FROM inserted) i
		--ON		r.account_id = i.account_id
		
	END
	
	/* *
	This part of the trigger was replaced by an hourly SQL job, it is no longer necessary
	
	IF UPDATE(AnnualUsage) OR UPDATE(UsageReqStatusID)
	BEGIN
		-- First we collect all contract numbers which has an account that had the usage download completed.
		SELECT DISTINCT C.Number as contract_nbr
		INTO #contracts
		FROM Inserted I
		JOIN Libertypower.dbo.Account A		ON I.AccountID = A.AccountID
		JOIN Libertypower.dbo.[Contract] C	ON A.CurrentContractID = C.ContractID
		

		-- We remove the contracts that have even 1 account where the usage is not downloaded.
		-- This leaves us with a list of contracts where all the accounts have usage.
		DELETE FROM #contracts
		WHERE contract_nbr in (	SELECT	contract_nbr 
								FROM	lp_account.dbo.account (NOLOCK)
								WHERE	usage_req_status <> 'Complete'
								AND		status NOT IN ('911000','999998','999999'))
		OR contract_nbr in (	SELECT	contract_nbr 
								FROM	lp_account.dbo.account_renewal (NOLOCK)
								WHERE	annual_usage = 0)

		-- Here we take every contract with completed usage and update the "check_account" queue.
		DECLARE contract_cursor CURSOR FOR SELECT contract_nbr FROM #contracts

		OPEN contract_cursor
		FETCH NEXT FROM contract_cursor INTO @p_contract_nbr

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- We first check that "USAGE ACQUIRE" is one of the pending steps for the contract's enrollment.
			IF EXISTS (SELECT NULL FROM lp_enrollment.dbo.check_account WHERE check_type = 'USAGE ACQUIRE' and  approval_status in ('INCOMPLETE','PENDING') and contract_nbr=@p_contract_nbr)
				BEGIN
					DECLARE	@CheckRequestId	varchar(25)
					
					SELECT @CheckRequestId = check_request_id FROM lp_enrollment.dbo.check_account (NOLOCK) WHERE check_type = 'USAGE ACQUIRE' and approval_status in ('INCOMPLETE','PENDING') and contract_nbr = @p_contract_nbr

					EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username = N'Usage Trigger', @p_check_request_id = @CheckRequestId, @p_contract_nbr = @p_contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'USAGE ACQUIRE', @p_approval_status = N'APPROVED', @p_comment = N'All Usage Acquired'

				END

			FETCH NEXT FROM contract_cursor INTO @p_contract_nbr
		END

		CLOSE contract_cursor
		DEALLOCATE contract_cursor
	END
	
	
	*/
	
	
	
	
END

GO
-- ===================================================
-- Author:		Jaime Forero	
-- Create date: 07/04/2011
-- Description:	This trigger replaces legacy [tr_usage_request_status_update] trigger
-- OLD COmments:
	-- ===============================================
	-- Author:		Eric Hernandez
	-- Create date: 2-16-2007
	-- Description:	
--
-- 10/21/2011 Jaime Forero: This trigger is disabled in production and will be released as a disabled trigger
--  THIS TRIGGER DOESNT WORK NEEDS SOME ATTENNTION BEFORE RE_ENABLING IT
--
-- ===================================================
CREATE TRIGGER [dbo].[AfterUpdateStatusUpdate]
   ON  [dbo].[AccountUsage]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @w_CompleteUsageStatusID INT;
	
	IF UPDATE(UsageReqStatusID) 
	BEGIN
		-- TODO: Review this logic the queries were re-written
		-- First we collect all contract numbers which has an account that had the usage download completed.
		SELECT @w_CompleteUsageStatusID = U.UsageReqStatusID FROM LibertyPower.dbo.UsageReqStatus U WHERE LOWER(LTRIM(RTRIM(U.[Status]))) = 'complete';
		-- We remove the contracts that have even 1 account where the usage is not downloaded.
		-- This leaves us with a list of contracts where all the accounts have usage.
		
		SELECT DISTINCT I.AccountID as AccountID
		INTO #taccounts
		FROM inserted I 
		JOIN Libertypower.dbo.Account A ON I.AccountID = A.AccountID
		JOIN Libertypower.dbo.AccountContract AC ON A.CurrentContractID = AC.ContractID AND A.AccountID = AC.AccountID
		JOIN LibertyPower.dbo.AccountStatus (NOLOCK) [AS] ON AC.AccountContractID = [AS].AccountContractID
		WHERE I.UsageReqStatusID  = @w_CompleteUsageStatusID 
		AND			[AS].[Status] IN ('911000','999998','999999')
		;
				
		-- Here we take every contract with completed usage and update the "check_account" queue.
		DECLARE @contract_nbr VARCHAR(12);
		
		DECLARE usage_req_status_contract_cursor 
		CURSOR FOR  SELECT C.Number FROM #accounts t
					JOIN LibertyPower.dbo.Account (NOLOCK) A ON  t.AccountID = A.AccountID
					JOIN LibertyPower.dbo.[Contract] (NOLOCK) C ON A.CurrentContractID = C.ContractID;
			

		OPEN usage_req_status_contract_cursor
		FETCH NEXT FROM usage_req_status_contract_cursor INTO @contract_nbr
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--select @contract_nbr as b into new_test
			-- We first check that "USAGE ACQUIRE" is one of the pending steps for the contract's enrollment.
			IF EXISTS (SELECT * FROM lp_enrollment.dbo.check_account with (nolock) WHERE check_type = 'USAGE ACQUIRE' and approval_status='PENDING' and contract_nbr=@contract_nbr)
				EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username=N'Usage Trigger',@p_check_request_id=N'ENROLLMENT',@p_contract_nbr=@contract_nbr,@p_account_id=N'NONE',@p_account_number=N' ',@p_check_type=N'USAGE ACQUIRE',@p_approval_status=N'APPROVED',@p_comment=N'All Usage Acquired'

			FETCH NEXT FROM usage_req_status_contract_cursor INTO @contract_nbr
		END

		CLOSE usage_req_status_contract_cursor
		DEALLOCATE usage_req_status_contract_cursor
		
	
		
	END
	
	
	
END

GO
DISABLE TRIGGER [dbo].[AfterUpdateStatusUpdate]
    ON [dbo].[AccountUsage];

