USE [LibertyPower]
GO
/****** Object:  Trigger [dbo].[zAuditAccountContractRateUpdate]    Script Date: 10/12/2012 13:43:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[zAuditAccountContractRateUpdate]
	ON  [dbo].[AccountContractRate]
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
			
	SET @ObjectID					= (SELECT id FROM sysobjects with (nolock) WHERE name='AccountContractRate')
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


	INSERT INTO [dbo].[zAuditAccountContractRate] (
		[AccountContractRateID]
		,[AccountContractID]
		,[LegacyProductID]
		,[Term]
		,[RateID]
		,[Rate]
		,[RateCode]
		,[RateStart]
		,[RateEnd]
		,[IsContractedRate]
		,[HeatIndexSourceID]
		,[HeatRate]
		,[TransferRate]
		,[GrossMargin]
		,[CommissionRate]
		,[AdditionalGrossMargin]
		,[Modified]
		,[ModifiedBy]
		,[DateCreated]
		,[CreatedBy]
		,[AuditChangeType]
		,[PriceID]
		,[ProductCrossPriceMultiID]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		a.[AccountContractRateID]
		,a.[AccountContractID]
		,a.[LegacyProductID]
		,a.[Term]
		,a.[RateID]
		,a.[Rate]
		,a.[RateCode]
		,a.[RateStart]
		,a.[RateEnd]
		,a.[IsContractedRate]
		,a.[HeatIndexSourceID]
		,a.[HeatRate]
		,a.[TransferRate]
		,a.[GrossMargin]
		,a.[CommissionRate]
		,a.[AdditionalGrossMargin]
		,a.[Modified]
		,a.[ModifiedBy]
		,a.[DateCreated]
		,a.[CreatedBy]
		,'UPD'						--[AuditChangeType]
		,a.[PriceID]
		,a.[ProductCrossPriceMultiID]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[AccountContractRateID],0) <> ISNULL(b.[AccountContractRateID],0) THEN 'AccountContractRateID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AccountContractID],0) <> ISNULL(b.[AccountContractID],0) THEN 'AccountContractID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[LegacyProductID],0) <> ISNULL(b.[LegacyProductID],0) THEN 'LegacyProductID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Term],0) <> ISNULL(b.[Term],0) THEN 'Term' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[RateID],0) <> ISNULL(b.[RateID],0) THEN 'RateID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Rate],0) <> ISNULL(b.[Rate],0) THEN 'Rate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[RateCode],'') <> ISNULL(b.[RateCode],'') THEN 'RateCode' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[RateStart],'') <> ISNULL(b.[RateStart],'') THEN 'RateStart' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[RateEnd],'') <> ISNULL(b.[RateEnd],'') THEN 'RateEnd' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[IsContractedRate],0) <> ISNULL(b.[IsContractedRate],0) THEN 'IsContractedRate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[HeatIndexSourceID],0) <> ISNULL(b.[HeatIndexSourceID],0) THEN 'HeatIndexSourceID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[HeatRate],0) <> ISNULL(b.[HeatRate],0) THEN 'HeatRate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[TransferRate],0) <> ISNULL(b.[TransferRate],0) THEN 'TransferRate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[GrossMargin],0) <> ISNULL(b.[GrossMargin],0) THEN 'GrossMargin' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CommissionRate],0) <> ISNULL(b.[CommissionRate],0) THEN 'CommissionRate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AdditionalGrossMargin],0) <> ISNULL(b.[AdditionalGrossMargin],0) THEN 'AdditionalGrossMargin' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> ISNULL(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> ISNULL(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> ISNULL(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> ISNULL(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END			
			+ CASE WHEN ISNULL(a.[PriceID],0) <> ISNULL(b.[PriceID],0) THEN 'PriceID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ProductCrossPriceMultiID],0) <> ISNULL(b.[ProductCrossPriceMultiID],0) THEN 'ProductCrossPriceMultiID' + ',' ELSE '' END
	FROM inserted a
	INNER JOIN deleted b
	ON b.[AccountContractRateID] = a.[AccountContractRateID]
	
	SET NOCOUNT OFF;
END
