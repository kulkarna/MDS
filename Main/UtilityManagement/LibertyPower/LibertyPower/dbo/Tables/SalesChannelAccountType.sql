CREATE TABLE [dbo].[SalesChannelAccountType] (
    [ID]            INT IDENTITY (1, 1) NOT NULL,
    [ChannelID]     INT NOT NULL,
    [AccountTypeID] INT NOT NULL,
    [MarketID]      INT NOT NULL,
    CONSTRAINT [PK_SalesChannelAccountType] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

CREATE TRIGGER [dbo].[zAuditSalesChannelAccountTypeDelete]
	ON  [dbo].[SalesChannelAccountType]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditSalesChannelAccountType] (
		[ChannelID],
		[AccountTypeID],
		[MarketID],
		[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		[ChannelID]
		,[AccountTypeID]
		,[MarketID]
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

CREATE TRIGGER [dbo].[zAuditSalesChannelAccountTypeInsert]
	ON  [dbo].[SalesChannelAccountType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditSalesChannelAccountType] (
		[ChannelID],
		[AccountTypeID],
		[MarketID],
		[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		[ChannelID]
		,[AccountTypeID]
		,[MarketID]
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

CREATE TRIGGER [dbo].[zAuditSalesChannelAccountTypeUpdate]
	ON  [dbo].[SalesChannelAccountType]
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='SalesChannelAccountType')
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
 	
	
	INSERT INTO [dbo].[zAuditSalesChannelAccountType] (
		[ChannelID],
		[AccountTypeID],
		[MarketID],
		[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		a.[ChannelID]
		,a.[AccountTypeID]
		,a.[MarketID]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN isnull(a.[ChannelID],0) <> isnull(b.[ChannelID],0) THEN 'ChannelID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[AccountTypeID],0) <> isnull(b.[AccountTypeID],0) THEN 'AccountTypeID' + ',' ELSE '' END
			+ CASE WHEN isnull(a.[MarketID],'') <> isnull(b.[MarketID],'') THEN 'MarketID' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	on b.[ChannelID]		= a.[ChannelID]
	SET NOCOUNT OFF;
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SalesChannelAccountType';

