USE [LibertyPower]
GO

/****** Object:  Trigger [zAuditUtilityInsert]    Script Date: 07/03/2012 16:20:07 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[zAuditUtilityInsert]'))
DROP TRIGGER [dbo].[zAuditUtilityInsert]
GO

USE [LibertyPower]
GO

/****** Object:  Trigger [dbo].[zAuditUtilityInsert]    Script Date: 07/03/2012 16:20:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author		: Sheri Scott
-- Create date	: 06/25/2012
-- Description	: Insert audit row into audit table zAuditUtility
--					(Derived from zAuditAccountInsert)
-- =============================================================
CREATE TRIGGER [dbo].[zAuditUtilityInsert]
	ON  [dbo].[Utility]
	AFTER INSERT
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
		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
	FROM inserted
	
	SET NOCOUNT OFF;
END

GO

