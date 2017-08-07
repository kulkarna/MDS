USE [LibertyPower]
GO

/****** Object:  Trigger [zAuditUtilityDelete]    Script Date: 07/03/2012 16:17:26 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[zAuditUtilityDelete]'))
DROP TRIGGER [dbo].[zAuditUtilityDelete]
GO

USE [LibertyPower]
GO

/****** Object:  Trigger [dbo].[zAuditUtilityDelete]    Script Date: 07/03/2012 16:17:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author		: Sheri Scott
-- Create date	: 06/25/2012
-- Description	: Insert audit row into audit table zAuditUtility
--					(Derived from zAuditAccountDelete)
-- =============================================================
CREATE TRIGGER [dbo].[zAuditUtilityDelete]
	ON  [dbo].[Utility]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditUtility] (
		 [UtilityCode]	 		
		,[FullName]	 			
		,[ShortName]	 			
		,[MarketID]	 			
		,[DunsNumber]	 		
		,[EntityId]	 			
		,[EnrollmentLeadDays]	
		,[BillingType]	 		
		,[AccountLength]	 		
		,[AccountNumberPrefix]	
		,[LeadScreenProcess]	 	
		,[DealScreenProcess]	 	
		,[PorOption]	 			
		,[DateCreated]	 		
		,[UserName]	 			
		,[InactiveInd]	 		
		,[ActiveDate]	 		
		,[ChgStamp]	 			
		,[MeterNumberRequired]	
		,[MeterNumberLength]	 	
		,[AnnualUsageMin]	 	
		,[Qualifier]	 			
		,[EdiCapable]	 		
		,[WholeSaleMktID]	 	
		,[Phone]	 				
		,[RateCodeRequired]	 	
		,[HasZones]	 			
		,[ZoneDefault]	 		
		,[RateCodeFormat]	 	
		,[RateCodeFields]	 	
		,[LegacyName]	 		
		,[SSNIsRequired]	 		
		,[PricingModeID]	 		
		,[isIDR_EDI_Capable]	 	
		,[HU_RequestType]	 	
		,[MultipleMeters]	 	
		,[AuditChangeType]	 	
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged])
	SELECT 
		 [UtilityCode]	 		
		,[FullName]	 			
		,[ShortName]	 			
		,[MarketID]	 			
		,[DunsNumber]	 		
		,[EntityId]	 			
		,[EnrollmentLeadDays]	
		,[BillingType]	 		
		,[AccountLength]	 		
		,[AccountNumberPrefix]	
		,[LeadScreenProcess]	 	
		,[DealScreenProcess]	 	
		,[PorOption]	 			
		,[DateCreated]	 		
		,[UserName]	 			
		,[InactiveInd]	 		
		,[ActiveDate]	 		
		,[ChgStamp]	 			
		,[MeterNumberRequired]	
		,[MeterNumberLength]	 	
		,[AnnualUsageMin]	 	
		,[Qualifier]	 			
		,[EdiCapable]	 		
		,[WholeSaleMktID]	 	
		,[Phone]	 				
		,[RateCodeRequired]	 	
		,[HasZones]	 			
		,[ZoneDefault]	 		
		,[RateCodeFormat]	 	
		,[RateCodeFields]	 	
		,[LegacyName]	 		
		,[SSNIsRequired]	 		
		,[PricingModeID]	 		
		,[isIDR_EDI_Capable]	 	
		,[HU_RequestType]	 	
		,[MultipleMeters]	 	
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM deleted
	
	SET NOCOUNT OFF;
END

GO

