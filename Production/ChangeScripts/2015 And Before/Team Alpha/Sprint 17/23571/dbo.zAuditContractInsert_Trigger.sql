USE [LibertyPower]
GO
/****** Object:  Trigger [dbo].[zAuditContractInsert]    Script Date: 10/30/2013 15:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditContract
-- =============================================================
-- =============================================================
-- Modify		: Satchi Jena 
-- Create date	: 10/30/2013
-- Description	: Added logic for additional columns [EstimatedAnnualUsage] ,[ExternalNumber],[DigitalSignature],[AffinityCode]
-- =============================================================

ALTER TRIGGER [dbo].[zAuditContractInsert]
	ON  [dbo].[Contract]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditContract] (
		[ContractID] 
		,[Number] 
		,[ContractTypeID] 
		,[ContractDealTypeID] 
		,[ContractStatusID] 
		,[ContractTemplateID] 
		,[ReceiptDate] 
		,[StartDate] 
		,[EndDate] 
		,[SignedDate] 
		,[SubmitDate] 
		,[SalesChannelID] 
		,[SalesRep] 
		,[SalesManagerID] 
		,[PricingTypeID] 
		,[Modified] 
		,[ModifiedBy] 
		,[DateCreated] 
		,[CreatedBy] 
		,[IsFutureContract]
		,[MigrationComplete]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged]
		,[EstimatedAnnualUsage]
        ,[ExternalNumber]
        ,[DigitalSignature]
        ,[AffinityCode]
		)
	SELECT 
		[ContractID] 
		,[Number] 
		,[ContractTypeID] 
		,[ContractDealTypeID] 
		,[ContractStatusID] 
		,[ContractTemplateID] 
		,[ReceiptDate] 
		,[StartDate] 
		,[EndDate] 
		,[SignedDate] 
		,[SubmitDate] 
		,[SalesChannelID] 
		,[SalesRep] 
		,[SalesManagerID] 
		,[PricingTypeID] 
		,[Modified] 
		,[ModifiedBy] 
		,[DateCreated] 
		,[CreatedBy] 
		,[IsFutureContract]
		,[MigrationComplete]
		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
		,[EstimatedAnnualUsage]
        ,[ExternalNumber]
        ,[DigitalSignature]
        ,[AffinityCode]
	FROM inserted
	
	SET NOCOUNT OFF;
END
