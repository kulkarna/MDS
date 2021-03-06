USE [LibertyPower]
GO
/****** Object:  Trigger [dbo].[zAuditAccountContractRateInsert]    Script Date: 10/12/2012 13:43:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/02/2011
-- Description	: Insert audit row into audit table AuditAccountContractRate
-- =============================================================
ALTER TRIGGER [dbo].[zAuditAccountContractRateInsert]
	ON  [dbo].[AccountContractRate]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

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
		,'INS'						--[AuditChangeType]
		,[PriceID]
		,[ProductCrossPriceMultiID]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM inserted
	
	SET NOCOUNT OFF;
END
