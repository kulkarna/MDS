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
create TRIGGER [dbo].[zAuditAccountSubmissionQueueInsert]
	ON  [dbo].AccountSubmissionQueue
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

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
		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM inserted a
	
	SET NOCOUNT OFF;
END
