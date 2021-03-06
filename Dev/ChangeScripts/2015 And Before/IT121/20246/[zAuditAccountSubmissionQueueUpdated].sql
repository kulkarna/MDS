USE [LibertyPower]
GO
/****** Object:  Trigger [dbo].[zAuditAccountContractDelete]    Script Date: 9/10/2013  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Rafael Vasques
-- Create date	: 9/10/2013
-- Description	: Insert audit row into audit table AccountSubmissionQueue
-- =============================================================
create TRIGGER [dbo].[zAuditAccountSubmissionQueueUpdated]
	ON  [dbo].[AccountSubmissionQueue]
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
			
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='AccountSubmissionQueue')
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

	INSERT INTO [dbo].zauditAccountSubmissionQueue (
		AccountSubmissionQueueID 
		,Category 
		,Type
		,EdiStatus
		,ScheduledSendDate
		,DesiredEffectiveDate
		,CreateDate
		,AccountContractRateID			
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		a.AccountSubmissionQueueID 
		,a.Category 
		,a.Type
		,a.EdiStatus
		,a.ScheduledSendDate
		,a.DesiredEffectiveDate
		,a.CreateDate
		,a.AccountContractRateID		
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,--CASE WHEN ISNULL(a.AccountSubmissionQueueID,0) <> ISNULL(b.AccountSubmissionQueueID,0) THEN 'AccountSubmissionQueueID' + ',' ELSE '' END			
			+ CASE WHEN ISNULL(a.Category,0) <> ISNULL(b.Category,0) THEN 'Category' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.Type,'') <> ISNULL(b.Type,'') THEN 'Type' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.EdiStatus,'') <> ISNULL(b.EdiStatus,'') THEN 'EdiStatus' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.ScheduledSendDate,'') <> ISNULL(b.ScheduledSendDate,'') THEN 'ScheduledSendDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.DesiredEffectiveDate,0) <> ISNULL(b.DesiredEffectiveDate,0) THEN 'DesiredEffectiveDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.CreateDate,'') <> ISNULL(b.CreateDate,'') THEN 'CreateDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.AccountContractRateID,0) <> ISNULL(b.AccountContractRateID,0) THEN 'AccountContractRateID' + ',' ELSE '' END			
	FROM inserted a
	INNER JOIN deleted b
	ON b.AccountSubmissionQueueID = a.AccountSubmissionQueueID
	
	SET NOCOUNT OFF;
END
