USE [Libertypower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/02/2011
-- Description	: Insert audit row into audit table AccountContract
-- =============================================================
--Modified	: Added Default Location and ProfileID columns. 
--By		: Gail Mangaroo
--Date		: 4/15/2013
-- =============================================================
ALTER TRIGGER [dbo].[zAuditAccountContractDelete]
	ON  [dbo].[AccountContract]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

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
		
		,[SettlementLocationRefID]
		
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	
	SELECT 
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
		
		,[SettlementLocationRefID]
		
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM deleted
	
	SET NOCOUNT OFF;
END
