CREATE TABLE [dbo].[Customer] (
    [CustomerID]           INT            IDENTITY (1, 1) NOT NULL,
    [NameID]               INT            NOT NULL,
    [OwnerNameID]          INT            NULL,
    [AddressID]            INT            NULL,
    [ContactID]            INT            NULL,
    [DBA]                  VARCHAR (128)  NULL,
    [Duns]                 VARCHAR (30)   NULL,
    [SsnClear]             NVARCHAR (100) NULL,
    [SsnEncrypted]         NVARCHAR (512) NULL,
    [TaxId]                VARCHAR (30)   NULL,
    [EmployerId]           VARCHAR (30)   NULL,
    [CreditAgencyID]       INT            NULL,
    [CreditScoreEncrypted] NVARCHAR (512) NULL,
    [BusinessTypeID]       INT            NULL,
    [BusinessActivityID]   INT            NULL,
    [ExternalNumber]       VARCHAR (64)   NULL,
    [Modified]             DATETIME       CONSTRAINT [DF_Customer_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]           INT            NOT NULL,
    [DateCreated]          DATETIME       CONSTRAINT [DF_Customer_Created] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            INT            CONSTRAINT [DF_Customer_CreatedBy] DEFAULT ((0)) NOT NULL,
    [CustomerPreferenceID] INT            NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [FK_Customer_Address] FOREIGN KEY ([AddressID]) REFERENCES [dbo].[Address] ([AddressID]),
    CONSTRAINT [FK_Customer_BusinessActivity] FOREIGN KEY ([BusinessActivityID]) REFERENCES [dbo].[BusinessActivity] ([BusinessActivityID]),
    CONSTRAINT [FK_Customer_BusinessType] FOREIGN KEY ([BusinessTypeID]) REFERENCES [dbo].[BusinessType] ([BusinessTypeID]),
    CONSTRAINT [FK_Customer_Contact] FOREIGN KEY ([ContactID]) REFERENCES [dbo].[Contact] ([ContactID]),
    CONSTRAINT [FK_Customer_CreditAgency] FOREIGN KEY ([CreditAgencyID]) REFERENCES [dbo].[CreditAgency] ([CreditAgencyID]),
    CONSTRAINT [FK_Customer_CustomerPreference] FOREIGN KEY ([CustomerPreferenceID]) REFERENCES [dbo].[CustomerPreference] ([CustomerPreferenceID]),
    CONSTRAINT [FK_Customer_Name] FOREIGN KEY ([NameID]) REFERENCES [dbo].[Name] ([NameID]),
    CONSTRAINT [FK_Customer_OwnerName] FOREIGN KEY ([OwnerNameID]) REFERENCES [dbo].[Name] ([NameID]),
    CONSTRAINT [FK_Customer_UserCreated] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_Customer_UserModified] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_BusinessTypeID]
    ON [dbo].[Customer]([BusinessTypeID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IDX_ContactID_I_CustomerID]
    ON [dbo].[Customer]([ContactID] ASC)
    INCLUDE([CustomerID]);


GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditCustomer
-- =============================================================
CREATE TRIGGER [dbo].[zAuditCustomerInsert]
	ON  [dbo].[Customer]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditCustomer] (
		[CustomerID] 
		,[NameID] 
		,[OwnerNameID] 
		,[AddressID] 
		,[ContactID] 
		,[DBA]
		,[Duns]
		,[SsnClear]
		,[SsnEncrypted]
		,[TaxId]
		,[EmployerId]
		,[CreditAgencyID]
		,[CreditScoreEncrypted]
		,[BusinessTypeID]
		,[BusinessActivityID]
		,[ExternalNumber]
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
		[CustomerID] 
		,[NameID] 
		,[OwnerNameID] 
		,[AddressID] 
		,[ContactID] 
		,[DBA]
		,[Duns]
		,[SsnClear]
		,[SsnEncrypted]
		,[TaxId]
		,[EmployerId]
		,[CreditAgencyID]
		,[CreditScoreEncrypted]
		,[BusinessTypeID]
		,[BusinessActivityID]
		,[ExternalNumber]
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
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditCustomer
-- =============================================================
CREATE TRIGGER [dbo].[zAuditCustomerDelete]
	ON  [dbo].[Customer]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditCustomer] (
		[CustomerID] 
		,[NameID] 
		,[OwnerNameID] 
		,[AddressID] 
		,[ContactID] 
		,[DBA]
		,[Duns]
		,[SsnClear]
		,[SsnEncrypted]
		,[TaxId]
		,[EmployerId]
		,[CreditAgencyID]
		,[CreditScoreEncrypted]
		,[BusinessTypeID]
		,[BusinessActivityID]
		,[ExternalNumber]
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
		[CustomerID] 
		,[NameID] 
		,[OwnerNameID] 
		,[AddressID] 
		,[ContactID] 
		,[DBA]
		,[Duns]
		,[SsnClear]
		,[SsnEncrypted]
		,[TaxId]
		,[EmployerId]
		,[CreditAgencyID]
		,[CreditScoreEncrypted]
		,[BusinessTypeID]
		,[BusinessActivityID]
		,[ExternalNumber]
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
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditCustomer
-- =============================================================
CREATE TRIGGER [dbo].[zAuditCustomerUpdate]
	ON  [dbo].[Customer]
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='Customer')
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
 	
	INSERT INTO [dbo].[zAuditCustomer] (
		[CustomerID] 
		,[NameID] 
		,[OwnerNameID] 
		,[AddressID] 
		,[ContactID] 
		,[DBA]
		,[Duns]
		,[SsnClear]
		,[SsnEncrypted]
		,[TaxId]
		,[EmployerId]
		,[CreditAgencyID]
		,[CreditScoreEncrypted]
		,[BusinessTypeID]
		,[BusinessActivityID]
		,[ExternalNumber]
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
		a.[CustomerID] 
		,a.[NameID] 
		,a.[OwnerNameID] 
		,a.[AddressID] 
		,a.[ContactID] 
		,a.[DBA]
		,a.[Duns]
		,a.[SsnClear]
		,a.[SsnEncrypted]
		,a.[TaxId]
		,a.[EmployerId]
		,a.[CreditAgencyID]
		,a.[CreditScoreEncrypted]
		,a.[BusinessTypeID]
		,a.[BusinessActivityID]
		,a.[ExternalNumber]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[CustomerID],0) <> isnull(b.[CustomerID],0) THEN 'CustomerID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[NameID],0) <> isnull(b.[NameID],0) THEN 'NameID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[OwnerNameID],0) <> isnull(b.[OwnerNameID],0) THEN 'OwnerNameID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AddressID],0) <> isnull(b.[AddressID],0) THEN 'AddressID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContactID],0) <> isnull(b.[ContactID],0) THEN 'ContactID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DBA],'') <> isnull(b.[DBA],'') THEN 'DBA' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Duns],'') <> isnull(b.[Duns],'') THEN 'Duns' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SsnClear],'') <> isnull(b.[SsnClear],'') THEN 'SsnClear' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SsnEncrypted],'') <> isnull(b.[SsnEncrypted],'') THEN 'SsnEncrypted' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[TaxId],'') <> isnull(b.[TaxId],'') THEN 'TaxId' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EmployerId],'') <> isnull(b.[EmployerId],'') THEN 'EmployerId' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreditAgencyID],0) <> isnull(b.[CreditAgencyID],0) THEN 'CreditAgencyID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreditScoreEncrypted],'') <> isnull(b.[CreditScoreEncrypted],'') THEN 'CreditScoreEncrypted' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[BusinessTypeID],0) <> isnull(b.[BusinessTypeID],0) THEN 'BusinessTypeID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[BusinessActivityID],0) <> isnull(b.[BusinessActivityID],0) THEN 'BusinessActivityID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ExternalNumber],'') <> isnull(b.[ExternalNumber],'') THEN 'ExternalNumber' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> isnull(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> isnull(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> isnull(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> isnull(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	ON a.[CustomerID]		= b.[CustomerID]
	
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
CREATE TRIGGER AfterInsertUpdateCustomerManyToManyTables2
   ON  dbo.Customer
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @w_CustomerID INT;
	DECLARE @w_AddressID INT;
	DECLARE @w_OwnerNameID INT;
	DECLARE @w_NameID INT;
	DECLARE @w_ContactID INT;
	DECLARE @w_CreatedBy INT;
	DECLARE @w_ModifiedBy INT;
	-- Check the name table:

	DECLARE local_cursor CURSOR FOR 
	SELECT	CustomerID, AddressID, OwnerNameID, NameID, ContactID, CreatedBy, ModifiedBy
	FROM	Inserted
	;


	-- ************************************************************************
	OPEN local_cursor;
	
	FETCH NEXT FROM local_cursor  
	INTO	@w_CustomerID, @w_AddressID, @w_OwnerNameID,
			@w_NameID, @w_ContactID, @w_CreatedBy, @w_ModifiedBy;
		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		

		-- If the record doesnt exists then insert it
		IF NOT EXISTS (SELECT * FROM LibertyPower.dbo.CustomerAddress WHERE AddressID = @w_AddressID AND CustomerID = @w_CustomerID)
		BEGIN 
			PRINT 'Address Record not found adding one';
			-- The record wasnt added so add it
			INSERT INTO [LibertyPower].[dbo].[CustomerAddress]
				([CustomerID],[AddressID],[Modified],[ModifiedBy],[DateCreated],[CreatedBy])
			 VALUES
				(@w_CustomerID, @w_AddressID, GETDATE(), @w_ModifiedBy, GETDATE(), @w_CreatedBy);
		END

		IF NOT EXISTS (SELECT * FROM LibertyPower.dbo.CustomerName WHERE NameID = @w_NameID AND CustomerID = @w_CustomerID)
		BEGIN 
			PRINT 'Name Record not found adding one';
			-- The record wasnt added so add it
			INSERT INTO [LibertyPower].[dbo].[CustomerName]
				([CustomerID],[NameID],[Modified],[ModifiedBy],[DateCreated],[CreatedBy])
			 VALUES
				(@w_CustomerID, @w_NameID, GETDATE(), @w_ModifiedBy, GETDATE(), @w_CreatedBy);
		END

		IF NOT EXISTS (SELECT * FROM LibertyPower.dbo.CustomerName WHERE NameID = @w_OwnerNameID AND CustomerID = @w_CustomerID)
		BEGIN 
			PRINT 'Name Record not found adding one';
			-- The record wasnt added so add it
			INSERT INTO [LibertyPower].[dbo].[CustomerName]
				([CustomerID],[NameID],[Modified],[ModifiedBy],[DateCreated],[CreatedBy])
			 VALUES
				(@w_CustomerID, @w_OwnerNameID, GETDATE(), @w_ModifiedBy, GETDATE(), @w_CreatedBy);
		END

		IF NOT EXISTS (SELECT * FROM LibertyPower.dbo.CustomerContact WHERE ContactID = @w_ContactID AND CustomerID = @w_CustomerID)
		BEGIN 
			PRINT 'Contact Record not found adding one';
			-- The record wasnt added so add it
			INSERT INTO [LibertyPower].[dbo].[CustomerContact]
				([CustomerID],[ContactID],[Modified],[ModifiedBy],[DateCreated],[CreatedBy])
			 VALUES
				(@w_CustomerID, @w_ContactID, GETDATE(), @w_ModifiedBy, GETDATE(), @w_CreatedBy);
		END
		
		-- ===============================================================================================================================================================
		--  WHILE LOOP FOOTER
		-- ===============================================================================================================================================================
		FETCH NEXT FROM local_cursor  
		INTO	@w_CustomerID, @w_AddressID, @w_OwnerNameID,
				@w_NameID, @w_ContactID, @w_CreatedBy, @w_ModifiedBy;	
	END -- THIS IS THE WHILE FOR THE CURSOR
	
	CLOSE local_cursor;
	DEALLOCATE local_cursor;

END
