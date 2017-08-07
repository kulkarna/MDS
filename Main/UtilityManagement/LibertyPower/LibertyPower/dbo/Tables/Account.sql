CREATE TABLE [dbo].[Account] (
    [AccountID]                INT          IDENTITY (1, 1) NOT NULL,
    [AccountIdLegacy]          CHAR (12)    NULL,
    [AccountNumber]            VARCHAR (30) NULL,
    [AccountTypeID]            INT          NULL,
    [CustomerID]               INT          NULL,
    [CustomerIdLegacy]         VARCHAR (10) NULL,
    [EntityID]                 CHAR (15)    NULL,
    [RetailMktID]              INT          NULL,
    [UtilityID]                INT          NULL,
    [AccountNameID]            INT          NULL,
    [BillingAddressID]         INT          NULL,
    [BillingContactID]         INT          NULL,
    [ServiceAddressID]         INT          NULL,
    [Origin]                   VARCHAR (50) NULL,
    [TaxStatusID]              INT          NULL,
    [PorOption]                BIT          NULL,
    [BillingTypeID]            INT          NULL,
    [Zone]                     VARCHAR (50) NULL,
    [ServiceRateClass]         VARCHAR (50) NULL,
    [StratumVariable]          VARCHAR (15) NULL,
    [BillingGroup]             VARCHAR (15) NULL,
    [Icap]                     VARCHAR (15) NULL,
    [Tcap]                     VARCHAR (15) NULL,
    [LoadProfile]              VARCHAR (50) NULL,
    [LossCode]                 VARCHAR (15) NULL,
    [MeterTypeID]              INT          NULL,
    [CurrentContractID]        INT          NULL,
    [CurrentRenewalContractID] INT          NULL,
    [Modified]                 DATETIME     CONSTRAINT [DF_Account_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]               INT          NULL,
    [DateCreated]              DATETIME     CONSTRAINT [DF_Account_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                INT          NULL,
    [MigrationComplete]        BIT          CONSTRAINT [DF_Account_MigrationComplete] DEFAULT ((0)) NOT NULL,
    [LoadProfileRefId]         INT          NULL,
    CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED ([AccountID] ASC),
    CONSTRAINT [FK_Account_AccountType] FOREIGN KEY ([AccountTypeID]) REFERENCES [dbo].[AccountType] ([ID]),
    CONSTRAINT [FK_Account_BillingType] FOREIGN KEY ([BillingTypeID]) REFERENCES [dbo].[BillingType] ([BillingTypeID]),
    CONSTRAINT [FK_Account_Contact] FOREIGN KEY ([BillingContactID]) REFERENCES [dbo].[Contact] ([ContactID]),
    CONSTRAINT [FK_Account_Contract] FOREIGN KEY ([CurrentContractID]) REFERENCES [dbo].[Contract] ([ContractID]),
    CONSTRAINT [FK_Account_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID]),
    CONSTRAINT [FK_Account_Market] FOREIGN KEY ([RetailMktID]) REFERENCES [dbo].[Market] ([ID]),
    CONSTRAINT [FK_Account_MeterType] FOREIGN KEY ([MeterTypeID]) REFERENCES [dbo].[MeterType] ([ID]),
    CONSTRAINT [FK_Account_Name] FOREIGN KEY ([AccountNameID]) REFERENCES [dbo].[Name] ([NameID]),
    CONSTRAINT [FK_Account_TaxStatus] FOREIGN KEY ([TaxStatusID]) REFERENCES [dbo].[TaxStatus] ([TaxStatusID]),
    CONSTRAINT [FK_Account_UserCreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_Account_UserModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_Account_Utility] FOREIGN KEY ([UtilityID]) REFERENCES [dbo].[vw_Utility] ([ID]),
    CONSTRAINT [FK_AccountBilling_Address] FOREIGN KEY ([BillingAddressID]) REFERENCES [dbo].[Address] ([AddressID]),
    CONSTRAINT [FK_AccountService_Address] FOREIGN KEY ([ServiceAddressID]) REFERENCES [dbo].[Address] ([AddressID])
);


GO
CREATE NONCLUSTERED INDEX [idx_Account_CurrentContract]
    ON [dbo].[Account]([CurrentContractID] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_Account_Customer]
    ON [dbo].[Account]([CustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_Account_Utility]
    ON [dbo].[Account]([UtilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_Account_CurrentRenewalContractID]
    ON [dbo].[Account]([CurrentRenewalContractID] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_Account_CurrentContractID_CurrentRenewalContractID]
    ON [dbo].[Account]([CurrentContractID] ASC, [CurrentRenewalContractID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ__AccountNumber_UtilityID]
    ON [dbo].[Account]([AccountNumber] ASC, [UtilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_A_AccountIdLegacy_LUCA]
    ON [dbo].[Account]([AccountIdLegacy] ASC)
    INCLUDE([CurrentContractID]);


GO
CREATE NONCLUSTERED INDEX [idx_Account_CurrentContractID_I_AccountIdLegacy__LUCA]
    ON [dbo].[Account]([CurrentContractID] ASC)
    INCLUDE([AccountIdLegacy]);


GO
CREATE NONCLUSTERED INDEX [IDX_Account_RetailMktID]
    ON [dbo].[Account]([RetailMktID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNQ__AccountIdLegacy]
    ON [dbo].[Account]([AccountIdLegacy] ASC)
    INCLUDE([CurrentContractID]);


GO
CREATE NONCLUSTERED INDEX [Account__CurrentRenewalContractID_I]
    ON [dbo].[Account]([CurrentRenewalContractID] ASC)
    INCLUDE([AccountID], [AccountNumber]);


GO
-- =============================================
-- Author:		Jaime Forero
-- Create date: 06/29/2011
-- Description: This trigger replaces [tr_bank_group_ins] trigger
-- OLD COMMENTS:
	-- Author:		Eric Hernandez
	-- Create date: 9/17/2007
	-- Description:	Deutsche Bank Group is automatically assigned for SMB accounts upon creation
-- =============================================
CREATE TRIGGER [dbo].[AfterInsertBankGroup]
   ON  dbo.Account
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
		
	INSERT INTO lp_account.dbo.account_deutsche_link
	(account_id, deutsche_bank_group_id)
	SELECT AccountIdLegacy, lp_account.dbo.ufn_determine_bank_group_name(AccountIdLegacy) 
	FROM inserted
	;


END

GO

-- =============================================
-- Author:        Jaime Forero
-- Create date:   8/15/2011
-- Description:   Part of legacy trigger: tr_account_upd_ins
-- =============================================
CREATE TRIGGER [dbo].[AfterInsertUpdateLoadProfile]
      ON [dbo].[Account]
      AFTER INSERT,UPDATE
AS 
BEGIN
      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.
      SET NOCOUNT ON;
      -- BEGIN SD 23900
      IF UPDATE(LoadProfile)
      BEGIN
            DECLARE     @p_MeterTypeID INT;
            DECLARE     @p_TexasMarketID INT;

            SELECT      @p_TexasMarketID = M.ID FROM Libertypower..Market M WHERE LTRIM(RTRIM(LOWER(M.MarketCode))) = 'tx';
            SELECT      @p_MeterTypeID = MT.ID FROM Libertypower..MeterType MT WHERE LTRIM(RTRIM(LOWER(MT.MeterTypeCode))) = 'idr';

            UPDATE      Libertypower.dbo.Account SET MeterTypeID = @p_MeterTypeID
            FROM  Libertypower.dbo.Account A
                  JOIN Inserted I ON I.AccountID = A.AccountID
                  JOIN Libertypower.dbo.Utility U ON A.UtilityID = U.ID 
            WHERE U.MarketID = @p_TexasMarketID
                  AND I.LoadProfile like 'busidr%[_]idr%'
                  AND   I.MeterTypeID <> @p_MeterTypeID
      END
      -- END SD 23900

END


GO
-- =============================================
-- Author:		Jaime Forero	
-- Create date: 6/28/2011
-- Description:	This trigger is replacing the old [Account_InsertAccountRecordInLibertyPower] trigger on lp_account..account
-- Inserts a new record in the AccountEtfWaive
-- =============================================
CREATE TRIGGER [dbo].[AfterInsertAccountEtfWaive]
   ON  dbo.Account
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	INSERT INTO		LibertyPower.dbo.AccountEtfWaive 
					(AccountID, CurrentEtfID, IsOutgoingDeenrollmentRequest, WaiveEtf, WaivedEtfReasonCodeID)
    SELECT DISTINCT AccountID, null, 0, 0, null 
    FROM			Inserted
    ;
    
END

GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table AuditAccount
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountInsert]
	ON  dbo.Account
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccount] (
		[AccountID]
		,[AccountIdLegacy]
		,[AccountNumber]
		,[AccountTypeID]
		,[CustomerID]
		,[CustomerIdLegacy]
		,[EntityID]
		,[RetailMktID]
		,[UtilityID]
		,[AccountNameID]
		,[BillingAddressID]
		,[BillingContactID]
		,[ServiceAddressID]
		,[Origin]
		,[TaxStatusID]
		,[PorOption]
		,[BillingTypeID]
		,[Zone]
		,[ServiceRateClass]
		,[StratumVariable]
		,[BillingGroup]
		,[Icap]
		,[Tcap]
		,[LoadProfile]
		,[LossCode]
		,[MeterTypeID]
		,[CurrentContractID]
		,[CurrentRenewalContractID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[MigrationComplete]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		[AccountID]
		,[AccountIdLegacy]
		,[AccountNumber]
		,[AccountTypeID]
		,[CustomerID]
		,[CustomerIdLegacy]
		,[EntityID]
		,[RetailMktID]
		,[UtilityID]
		,[AccountNameID]
		,[BillingAddressID]
		,[BillingContactID]
		,[ServiceAddressID]
		,[Origin]
		,[TaxStatusID]
		,[PorOption]
		,[BillingTypeID]
		,[Zone]
		,[ServiceRateClass]
		,[StratumVariable]
		,[BillingGroup]
		,[Icap]
		,[Tcap]
		,[LoadProfile]
		,[LossCode]
		,[MeterTypeID]
		,[CurrentContractID]
		,[CurrentRenewalContractID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[MigrationComplete]
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
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table AuditAccount
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountUpdate]
	ON  dbo.Account
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='Account')
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
 	
	
	INSERT INTO [dbo].[zAuditAccount] (
		[AccountID]
		,[AccountIdLegacy]
		,[AccountNumber]
		,[AccountTypeID]
		,[CustomerID]
		,[CustomerIdLegacy]
		,[EntityID]
		,[RetailMktID]
		,[UtilityID]
		,[AccountNameID]
		,[BillingAddressID]
		,[BillingContactID]
		,[ServiceAddressID]
		,[Origin]
		,[TaxStatusID]
		,[PorOption]
		,[BillingTypeID]
		,[Zone]
		,[ServiceRateClass]
		,[StratumVariable]
		,[BillingGroup]
		,[Icap]
		,[Tcap]
		,[LoadProfile]
		,[LossCode]
		,[MeterTypeID]
		,[CurrentContractID]
		,[CurrentRenewalContractID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[MigrationComplete]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		a.[AccountID]
		,a.[AccountIdLegacy]
		,a.[AccountNumber]
		,a.[AccountTypeID]
		,a.[CustomerID]
		,a.[CustomerIdLegacy]
		,a.[EntityID]
		,a.[RetailMktID]
		,a.[UtilityID]
		,a.[AccountNameID]
		,a.[BillingAddressID]
		,a.[BillingContactID]
		,a.[ServiceAddressID]
		,a.[Origin]
		,a.[TaxStatusID]
		,a.[PorOption]
		,a.[BillingTypeID]
		,a.[Zone]
		,a.[ServiceRateClass]
		,a.[StratumVariable]
		,a.[BillingGroup]
		,a.[Icap]
		,a.[Tcap]
		,a.[LoadProfile]
		,a.[LossCode]
		,a.[MeterTypeID]
		,a.[CurrentContractID]
		,a.[CurrentRenewalContractID]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,a.[MigrationComplete]
		,'UPD'						--[AuditChangeType]
		--,a.[AuditChangeDate]		Default Value in SQLServer
		--,a.[AuditChangeBy]			Default Value in SQLServer
		--,a.[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN isnull(a.[AccountID],0) <> isnull(b.[AccountID],0) THEN 'AccountID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountIdLegacy],'') <> isnull(b.[AccountIdLegacy],'') THEN 'AccountIdLegacy' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountNumber],'') <> isnull(b.[AccountNumber],'') THEN 'AccountNumber' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountTypeID],0) <> isnull(b.[AccountTypeID],0) THEN 'AccountTypeID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CustomerID],0) <> isnull(b.[CustomerID],0) THEN 'CustomerID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CustomerIdLegacy],'') <> isnull(b.[CustomerIdLegacy],'') THEN 'CustomerIdLegacy' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[EntityID],'') <> isnull(b.[EntityID],'') THEN 'EntityID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[RetailMktID],0) <> isnull(b.[RetailMktID],0) THEN 'RetailMktID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[UtilityID],0) <> isnull(b.[UtilityID],0) THEN 'UtilityID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountNameID],0) <> isnull(b.[AccountNameID],0) THEN 'AccountNameID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[BillingAddressID],0) <> isnull(b.[BillingAddressID],0) THEN 'BillingAddressID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[BillingContactID],0) <> isnull(b.[BillingContactID],0) THEN 'BillingContactID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[ServiceAddressID],0) <> isnull(b.[ServiceAddressID],0) THEN 'ServiceAddressID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Origin],'') <> isnull(b.[Origin],'') THEN 'Origin' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[TaxStatusID],0) <> isnull(b.[TaxStatusID],0) THEN 'TaxStatusID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[PorOption],0) <> isnull(b.[PorOption],0) THEN 'PorOption' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[BillingTypeID],0) <> isnull(b.[BillingTypeID],0) THEN 'BillingTypeID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Zone],'') <> isnull(b.[Zone],'') THEN 'Zone' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[ServiceRateClass],'') <> isnull(b.[ServiceRateClass],'') THEN 'ServiceRateClass' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[StratumVariable],'') <> isnull(b.[StratumVariable],'') THEN 'StratumVariable' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[BillingGroup],'') <> isnull(b.[BillingGroup],'') THEN 'BillingGroup' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Icap],'') <> isnull(b.[Icap],'') THEN 'Icap' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Tcap],'') <> isnull(b.[Tcap],'') THEN 'Tcap' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[LoadProfile],'') <> isnull(b.[LoadProfile],'') THEN 'LoadProfile' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[LossCode],'') <> isnull(b.[LossCode],'') THEN 'LossCode' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[MeterTypeID],0) <> isnull(b.[MeterTypeID],0) THEN 'MeterTypeID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CurrentContractID],0) <> isnull(b.[CurrentContractID],0) THEN 'CurrentContractID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[Modified],'') <> isnull(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[ModifiedBy],0) <> isnull(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[DateCreated],'') <> isnull(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CreatedBy],0) <> isnull(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[MigrationComplete],0) <> isnull(b.[MigrationComplete],0) THEN 'MigrationComplete' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[CurrentRenewalContractID],0) <> isnull(b.[CurrentRenewalContractID],0) THEN 'CurrentRenewalContractID' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	on b.[AccountID]		= a.[AccountID]
	SET NOCOUNT OFF;
END

GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table AuditAccount
-- =============================================================
CREATE TRIGGER dbo.zAuditAccountDelete
	ON  dbo.Account
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccount] (
		[AccountID]
		,[AccountIdLegacy]
		,[AccountNumber]
		,[AccountTypeID]
		,[CustomerID]
		,[CustomerIdLegacy]
		,[EntityID]
		,[RetailMktID]
		,[UtilityID]
		,[AccountNameID]
		,[BillingAddressID]
		,[BillingContactID]
		,[ServiceAddressID]
		,[Origin]
		,[TaxStatusID]
		,[PorOption]
		,[BillingTypeID]
		,[Zone]
		,[ServiceRateClass]
		,[StratumVariable]
		,[BillingGroup]
		,[Icap]
		,[Tcap]
		,[LoadProfile]
		,[LossCode]
		,[MeterTypeID]
		,[CurrentContractID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[MigrationComplete]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		[AccountID]
		,[AccountIdLegacy]
		,[AccountNumber]
		,[AccountTypeID]
		,[CustomerID]
		,[CustomerIdLegacy]
		,[EntityID]
		,[RetailMktID]
		,[UtilityID]
		,[AccountNameID]
		,[BillingAddressID]
		,[BillingContactID]
		,[ServiceAddressID]
		,[Origin]
		,[TaxStatusID]
		,[PorOption]
		,[BillingTypeID]
		,[Zone]
		,[ServiceRateClass]
		,[StratumVariable]
		,[BillingGroup]
		,[Icap]
		,[Tcap]
		,[LoadProfile]
		,[LossCode]
		,[MeterTypeID]
		,[CurrentContractID]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[MigrationComplete]
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
-- =============================================
-- Author:		Jaime Forero
-- Create date: 7/5/2012
-- Description:	The account_id and link column where deleted from the Name, Address, and Contact table, 
-- this is a way to recreate a many to many relationship between customers and those tables so that.
-- This SP will have dual use:
-- 1. For legacy dependencies, since the lagacy structure has no knowledge of the MxN (many to many) structure, then
-- is the job of this trigger to insert those records in the respective tables.
-- 2. If the new API is doing the inserts (from .net) then those records would already be inserted therefore
-- there is no need to insert more, this SP will determine if those records where inserted or not.

-- we can have many contacts for every one or more customers 
-- =============================================

-- Author:		Thiago Nogueira
-- Change date: 9/12/2012
-- Description:	User for these records should be SYSTEM
-- =============================================

CREATE TRIGGER [dbo].[AfterInsertUpdateCustomerManyToManyTables]
   ON  [dbo].[Account]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @w_AccountID INT;
	DECLARE @w_CustomerID INT;
	DECLARE @w_BillingAddressID INT;
	DECLARE @w_ServiceAddressID INT;
	DECLARE @w_AccountNameID INT;
	DECLARE @w_BillingContactID INT;
	DECLARE @w_CreatedBy INT;
	DECLARE @w_ModifiedBy INT;
	-- Check the name table:

	DECLARE local_cursor CURSOR FOR 
	SELECT	AccountID, CustomerID, BillingAddressID, ServiceAddressID, 
			AccountNameID, BillingContactID, CreatedBy, ModifiedBy
	FROM	Inserted
	;


	-- ************************************************************************
	OPEN local_cursor;
	
	FETCH NEXT FROM local_cursor  
	INTO	@w_AccountID, @w_CustomerID, @w_BillingAddressID, @w_ServiceAddressID,
			@w_AccountNameID, @w_BillingContactID, @w_CreatedBy, @w_ModifiedBy;
		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		-- CreatedBy and ModifiedBy should be hardcoded to System user
		IF @w_ModifiedBy IS NULL
			SET @w_ModifiedBy = 1029
		IF @w_CreatedBy IS NULL
			SET @w_CreatedBy = 1029

		-- If the record doesnt exists then insert it
		IF NOT EXISTS (SELECT * FROM LibertyPower.dbo.CustomerAddress WHERE AddressID = @w_BillingAddressID AND CustomerID = @w_CustomerID)
		BEGIN 
			PRINT 'Address Record not found adding one';
			-- The record wasnt added so add it
			INSERT INTO [LibertyPower].[dbo].[CustomerAddress]
				([CustomerID],[AddressID],[Modified],[ModifiedBy],[DateCreated],[CreatedBy])
			 VALUES
				(@w_CustomerID, @w_BillingAddressID, GETDATE(), @w_ModifiedBy, GETDATE(), @w_CreatedBy);
		END

		
		IF NOT EXISTS (SELECT * FROM LibertyPower.dbo.CustomerAddress WHERE AddressID = @w_ServiceAddressID AND CustomerID = @w_CustomerID)
		BEGIN 
			PRINT 'Address Record not found adding one';
			-- The record wasnt added so add it
			INSERT INTO [LibertyPower].[dbo].[CustomerAddress]
				([CustomerID],[AddressID],[Modified],[ModifiedBy],[DateCreated],[CreatedBy])
			 VALUES
				(@w_CustomerID, @w_ServiceAddressID, GETDATE(), @w_ModifiedBy, GETDATE(), @w_CreatedBy);
		END

		IF NOT EXISTS (SELECT * FROM LibertyPower.dbo.CustomerName WHERE NameID = @w_AccountNameID AND CustomerID = @w_CustomerID)
		BEGIN 
			PRINT 'Name Record not found adding one';
			-- The record wasnt added so add it
			INSERT INTO [LibertyPower].[dbo].[CustomerName]
				([CustomerID],[NameID],[Modified],[ModifiedBy],[DateCreated],[CreatedBy])
			 VALUES
				(@w_CustomerID, @w_AccountNameID, GETDATE(), @w_ModifiedBy, GETDATE(), @w_CreatedBy);
		END

		IF NOT EXISTS (SELECT * FROM LibertyPower.dbo.CustomerContact WHERE ContactID = @w_BillingContactID AND CustomerID = @w_CustomerID)
		BEGIN 
			PRINT 'Contact Record not found adding one';
			-- The record wasnt added so add it
			INSERT INTO [LibertyPower].[dbo].[CustomerContact]
				([CustomerID],[ContactID],[Modified],[ModifiedBy],[DateCreated],[CreatedBy])
			 VALUES
				(@w_CustomerID, @w_BillingContactID, GETDATE(), @w_ModifiedBy, GETDATE(), @w_CreatedBy);
		END
		
		-- ===============================================================================================================================================================
		--  WHILE LOOP FOOTER
		-- ===============================================================================================================================================================
		FETCH NEXT FROM local_cursor  
		INTO	@w_AccountID, @w_CustomerID, @w_BillingAddressID, @w_ServiceAddressID,
				@w_AccountNameID, @w_BillingContactID, @w_CreatedBy, @w_ModifiedBy;
	END -- THIS IS THE WHILE FOR THE CURSOR
	
	CLOSE local_cursor;
	DEALLOCATE local_cursor;

END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Account', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Account';

