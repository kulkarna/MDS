USE [Libertypower]
GO
/****** Object:  Trigger [dbo].[zAuditAccountContractDelete]    Script Date: 12/09/2013 15:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 11/02/2011
-- Description	: Insert audit row into audit table AccountContract
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
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM deleted
	
	SET NOCOUNT OFF;
END
