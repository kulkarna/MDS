USE [Libertypower]
GO
/****** Object:  Trigger [dbo].[zAuditAccountContractRateInsert]    Script Date: 09/13/2013 10:30:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/02/2011
-- Description	: Insert audit row into audit table AuditAccountContractRate
-- =============================================
-- Author:		José Muñoz - SWCS
-- Create date: 09/13/2013
-- Description:	RCR - 17105 (Rate End Date not sync'ing with term and Rate Start Date)
-- =============================================
ALTER TRIGGER [dbo].[zAuditAccountContractRateInsert]
	ON  [dbo].[AccountContractRate]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	/* RCR - 17105 Begin */
	UPDATE [AccountContractRate]
	SET RateEnd = DATEADD (DD,-1,DATEADD(MONTH,I.TERM,I.RateStart))
	FROM [AccountContractRate] ACR WITH (NOLOCK)
	INNER JOIN inserted I
	ON ACR.AccountContractRateID		= I.AccountContractRateID 
	WHERE I.IsContractedRate			= 0
	/* RCR - 17105 End */
	
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
