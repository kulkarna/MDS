USE [LibertyPower]
GO
/****** Object:  Trigger [dbo].[zAuditContractDelete]    Script Date: 10/30/2013 15:31:11 ******/
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
ALTER TRIGGER [dbo].[zAuditContractDelete]
	ON  [dbo].[Contract]
	AFTER DELETE
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
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
		,[EstimatedAnnualUsage]
        ,[ExternalNumber]
        ,[DigitalSignature]
        ,[AffinityCode]
	FROM deleted
	
	SET NOCOUNT OFF;
END
