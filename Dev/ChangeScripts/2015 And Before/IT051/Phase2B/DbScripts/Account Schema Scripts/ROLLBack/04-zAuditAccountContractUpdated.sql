USE [Libertypower]
GO
/****** Object:  Trigger [dbo].[zAuditAccountContractUpdated]    Script Date: 12/09/2013 15:14:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/02/2011
-- Description	: Insert audit row into audit table AccountContract
-- =============================================================
ALTER TRIGGER [dbo].[zAuditAccountContractUpdated]
	ON  [dbo].[AccountContract]
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='AccountContract')
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

	INSERT INTO [dbo].[zAuditAccountContract] (
		[AccountContractID] 
		,[AccountID] 
		,[ContractID]
		,[RequestedStartDate]
		,[SendEnrollmentDate]
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
		a.[AccountContractID] 
		,a.[AccountID] 
		,a.[ContractID]
		,a.[RequestedStartDate]
		,a.[SendEnrollmentDate]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,a.[MigrationComplete]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[AccountContractID],0) <> ISNULL(b.[AccountContractID],0) THEN 'AccountContractID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AccountID],0) <> ISNULL(b.[AccountID],0) THEN 'AccountID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractID],0) <> ISNULL(b.[ContractID],0) THEN 'ContractID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[RequestedStartDate],'') <> ISNULL(b.[RequestedStartDate],'') THEN 'RequestedStartDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SendEnrollmentDate],'') <> ISNULL(b.[SendEnrollmentDate],'') THEN 'SendEnrollmentDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> ISNULL(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> ISNULL(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> ISNULL(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> ISNULL(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[MigrationComplete],0) <> ISNULL(b.[MigrationComplete],0) THEN 'MigrationComplete' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	ON b.[AccountContractID] = a.[AccountContractID]
	
	SET NOCOUNT OFF;
END
