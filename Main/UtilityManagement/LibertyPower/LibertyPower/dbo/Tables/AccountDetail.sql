CREATE TABLE [dbo].[AccountDetail] (
    [AccountDetailID]        INT      IDENTITY (1, 1) NOT NULL,
    [AccountID]              INT      NOT NULL,
    [EnrollmentTypeID]       INT      NULL,
    [OriginalTaxDesignation] INT      NULL,
    [Modified]               DATETIME CONSTRAINT [DF_AccountDetail_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]             INT      NOT NULL,
    [DateCreated]            DATETIME CONSTRAINT [DF_AccountDetail_Created] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              INT      NOT NULL,
    CONSTRAINT [PK_AccountDetail] PRIMARY KEY NONCLUSTERED ([AccountDetailID] ASC),
    CONSTRAINT [FK_AccountDetail_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_AccountDetail_EnrollmentType] FOREIGN KEY ([EnrollmentTypeID]) REFERENCES [dbo].[EnrollmentType] ([EnrollmentTypeID]),
    CONSTRAINT [FK_AccountDetail_UserCreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_AccountDetail_UserModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [IDX_AccountDetail_AccountID_I]
    ON [dbo].[AccountDetail]([AccountID] ASC);


GO
CREATE NONCLUSTERED INDEX [AccountDetail__EnrollmentTypeID_AccountID]
    ON [dbo].[AccountDetail]([EnrollmentTypeID] ASC)
    INCLUDE([AccountID]);


GO
-- =============================================
-- Author:		Jaime Forero
-- Create date: 09/03/2011
-- Description:	Trigger replacing legacy :[tr_enrollment_type_upd]

-- =============================================
CREATE TRIGGER [dbo].[AfterUpdateEnrollmentType]
   ON  [dbo].[AccountDetail]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	IF UPDATE(EnrollMentTypeID)
	BEGIN
		INSERT INTO lp_account.dbo.enrollment_type_log
		(timestamp,account_id,new)
		SELECT GETDATE(),A.AccountIdLegacy, ET.[Type]
		FROM Inserted I
		JOIN Libertypower.dbo.Account A ON I.AccountID = A.AccountID
		JOIN LibertyPower.dbo.EnrollmentType ET ON ET.EnrollmentTypeID = I.EnrollmentTypeID
	END
	
END

GO

-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/04/2011
-- Description	: Insert audit row into audit table AuditAccountDetail
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountDetailInsert]
	ON  [dbo].[AccountDetail]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccountDetail] (
		[AccountDetailID]
		,[AccountID]
		,[EnrollmentTypeID]
		,[OriginalTaxDesignation]
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
		[AccountDetailID]
		,[AccountID]
		,[EnrollmentTypeID]
		,[OriginalTaxDesignation]
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
-- Description	: Insert audit row into audit table AuditAccountDetail
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountDetailDelete]
	ON  [dbo].[AccountDetail]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditAccountDetail] (
		[AccountDetailID]
		,[AccountID]
		,[EnrollmentTypeID]
		,[OriginalTaxDesignation]
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
		[AccountDetailID]
		,[AccountID]
		,[EnrollmentTypeID]
		,[OriginalTaxDesignation]
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
-- Description	: Insert audit row into audit table AuditAccountDetail
-- =============================================================
CREATE TRIGGER [dbo].[zAuditAccountDetailUpdate]
	ON  [dbo].[AccountDetail]
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='AccountDetail')
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

	INSERT INTO [dbo].[zAuditAccountDetail] (
		[AccountDetailID]
		,[AccountID]
		,[EnrollmentTypeID]
		,[OriginalTaxDesignation]
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
		a.[AccountDetailID]
		,a.[AccountID]
		,a.[EnrollmentTypeID]
		,a.[OriginalTaxDesignation]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[AccountDetailID],0) <> ISNULL(b.[AccountDetailID],0) THEN 'AccountDetailID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AccountID],0) <> ISNULL(b.[AccountID],0) THEN 'AccountID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EnrollmentTypeID],0) <> ISNULL(b.[EnrollmentTypeID],0) THEN 'EnrollmentTypeID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[OriginalTaxDesignation],0) <> ISNULL(b.[OriginalTaxDesignation],0) THEN 'OriginalTaxDesignation' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> ISNULL(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> ISNULL(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> ISNULL(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> ISNULL(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END

	FROM inserted a
	INNER JOIN deleted b
	ON b.[AccountDetailID] = a.[AccountDetailID]
	
	SET NOCOUNT OFF;
END

