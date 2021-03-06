/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    data types:
        [dbo].[AccountPropertyRecord], [dbo].[MappingRecord], [dbo].[ResultantRecord]

    procedures:
        [dbo].[usp_ActivityGetAllByUserID], [dbo].[usp_Determinants_AccountCurrentPropertiesSelect], [dbo].[usp_Determinants_AliasDeactivate], [dbo].[usp_Determinants_AliasInsert], [dbo].[usp_Determinants_AliasSelectAll], [dbo].[usp_Determinants_AliasSelectByID], [dbo].[usp_Determinants_DeactivateFutureRecords], [dbo].[usp_Determinants_FieldMapAccounts], [dbo].[usp_Determinants_FieldMapDeactivate], [dbo].[usp_Determinants_FieldMapsSelect], [dbo].[usp_Determinants_FieldValueLock], [dbo].[usp_Determinants_FieldValueSelect], [dbo].[usp_Determinants_FutureFieldValueHistorySelect], [dbo].[usp_Determinants_FutureFieldValueSelect], [dbo].[usp_GetIT059MigrationData], [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount], [dbo].[usp_InitialAccountPropertyValuesInsert], [dbo].[usp_InsertDeactivateAndApplyMappings], [dbo].[usp_OfferEngineAccountDeterminants], [dbo].[usp_UsageGetMostRecentUsageDate], [dbo].[usp_UtilityAndMarketsSelect], [dbo].[usp_UtilityClassMappingDeterminantsSelectAll], [dbo].[usp_UtilityClassMappingInsert], [dbo].[usp_UtilityClassMappingSelect], [dbo].[usp_UtilityClassMappingUpdate], [dbo].[usp_UtilityMappingByUtilityIDSelect], [dbo].[usp_UtilityMappingSelect], [dbo].[usp_UtilityZoneMappingByUtilityIDSelect], [dbo].[usp_UtilityZoneMappingInsert], [dbo].[usp_UtilityZoneMappingSelect], [dbo].[usp_UtilityZoneMappingUpdate], [dbo].[usp_VRE_GetCurveFiles], [dbo].[usp_VRE_ServiceClassMapInsert]

    tables:
        [dbo].[AccountPropertyHistory], [dbo].[AccountPropertyLockHistory], [dbo].[DeterminantAlias], [dbo].[DeterminantFieldMapResultants], [dbo].[DeterminantFieldMaps], [dbo].[DeterminantHistory], [dbo].[TmpAccountPropertyHistory], [dbo].[UtilityClassMapping], [dbo].[UtilityZoneMapping], [dbo].[VRE_ServiceClassMapping]

    functions:
        [dbo].[GetDeterminantValue]

     Make vm2lpcnocsqlint1\prod.Libertypower Equal lpcnocsqlint1\prod.Libertypower

   AUTHOR:	[Jikku Joseph John]

   DATE:	11/14/2013 10:56:15 AM

 
   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO
USE [Libertypower]
GO

BEGIN TRAN
GO

-- Drop Extended Property MS_Description from [dbo].[DeterminantHistory]
Print 'Drop Extended Property MS_Description from [dbo].[DeterminantHistory]'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'dbo', 'TABLE', N'DeterminantHistory', 'COLUMN', N'Active'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Extended Property MS_Description from [dbo].[DeterminantHistory]
Print 'Drop Extended Property MS_Description from [dbo].[DeterminantHistory]'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'dbo', 'TABLE', N'DeterminantHistory', 'COLUMN', N'DateCreated'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Extended Property MS_Description from [dbo].[DeterminantHistory]
Print 'Drop Extended Property MS_Description from [dbo].[DeterminantHistory]'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'dbo', 'TABLE', N'DeterminantHistory', 'COLUMN', N'EffectiveDate'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Extended Property MS_Description from [dbo].[DeterminantHistory]
Print 'Drop Extended Property MS_Description from [dbo].[DeterminantHistory]'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'dbo', 'TABLE', N'DeterminantHistory', 'COLUMN', N'FieldName'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Extended Property MS_Description from [dbo].[DeterminantHistory]
Print 'Drop Extended Property MS_Description from [dbo].[DeterminantHistory]'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'dbo', 'TABLE', N'DeterminantHistory', 'COLUMN', N'FieldSource'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Extended Property MS_Description from [dbo].[DeterminantHistory]
Print 'Drop Extended Property MS_Description from [dbo].[DeterminantHistory]'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'dbo', 'TABLE', N'DeterminantHistory', 'COLUMN', N'LockStatus'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Foreign Key FK_AccountPropertyLockHistory_AccountPropertyHistory from [dbo].[AccountPropertyLockHistory]
Print 'Drop Foreign Key FK_AccountPropertyLockHistory_AccountPropertyHistory from [dbo].[AccountPropertyLockHistory]'
GO
ALTER TABLE [dbo].[AccountPropertyLockHistory] DROP CONSTRAINT [FK_AccountPropertyLockHistory_AccountPropertyHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_GetIT059MigrationData]
Print 'Drop Procedure [dbo].[usp_GetIT059MigrationData]'
GO
DROP PROCEDURE [dbo].[usp_GetIT059MigrationData]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_ActivityGetAllByUserID]
Print 'Drop Procedure [dbo].[usp_ActivityGetAllByUserID]'
GO
DROP PROCEDURE [dbo].[usp_ActivityGetAllByUserID]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityAndMarketsSelect]
Print 'Drop Procedure [dbo].[usp_UtilityAndMarketsSelect]'
GO
DROP PROCEDURE [dbo].[usp_UtilityAndMarketsSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_InsertDeactivateAndApplyMappings]
Print 'Drop Procedure [dbo].[usp_InsertDeactivateAndApplyMappings]'
GO
DROP PROCEDURE [dbo].[usp_InsertDeactivateAndApplyMappings]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_InitialAccountPropertyValuesInsert]
Print 'Drop Procedure [dbo].[usp_InitialAccountPropertyValuesInsert]'
GO
DROP PROCEDURE [dbo].[usp_InitialAccountPropertyValuesInsert]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_FieldValueLock]
Print 'Drop Procedure [dbo].[usp_Determinants_FieldValueLock]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueLock]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_FieldValueSelect]
Print 'Drop Procedure [dbo].[usp_Determinants_FieldValueSelect]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_FutureFieldValueHistorySelect]
Print 'Drop Procedure [dbo].[usp_Determinants_FutureFieldValueHistorySelect]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_FutureFieldValueHistorySelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_FutureFieldValueSelect]
Print 'Drop Procedure [dbo].[usp_Determinants_FutureFieldValueSelect]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_FutureFieldValueSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_AliasSelectByID]
Print 'Drop Procedure [dbo].[usp_Determinants_AliasSelectByID]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_AliasSelectByID]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_AliasSelectAll]
Print 'Drop Procedure [dbo].[usp_Determinants_AliasSelectAll]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_AliasSelectAll]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_AliasDeactivate]
Print 'Drop Procedure [dbo].[usp_Determinants_AliasDeactivate]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_AliasDeactivate]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_AliasInsert]
Print 'Drop Procedure [dbo].[usp_Determinants_AliasInsert]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_AliasInsert]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_FieldMapAccounts]
Print 'Drop Procedure [dbo].[usp_Determinants_FieldMapAccounts]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapAccounts]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_DeactivateFutureRecords]
Print 'Drop Procedure [dbo].[usp_Determinants_DeactivateFutureRecords]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_DeactivateFutureRecords]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]
Print 'Drop Procedure [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_AccountCurrentPropertiesSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_FieldMapsSelect]
Print 'Drop Procedure [dbo].[usp_Determinants_FieldMapsSelect]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapsSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_FieldMapDeactivate]
Print 'Drop Procedure [dbo].[usp_Determinants_FieldMapDeactivate]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_FieldMapDeactivate]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityMappingSelect]
Print 'Drop Procedure [dbo].[usp_UtilityMappingSelect]'
GO
DROP PROCEDURE [dbo].[usp_UtilityMappingSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityMappingByUtilityIDSelect]
Print 'Drop Procedure [dbo].[usp_UtilityMappingByUtilityIDSelect]'
GO
DROP PROCEDURE [dbo].[usp_UtilityMappingByUtilityIDSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityZoneMappingUpdate]
Print 'Drop Procedure [dbo].[usp_UtilityZoneMappingUpdate]'
GO
DROP PROCEDURE [dbo].[usp_UtilityZoneMappingUpdate]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityZoneMappingSelect]
Print 'Drop Procedure [dbo].[usp_UtilityZoneMappingSelect]'
GO
DROP PROCEDURE [dbo].[usp_UtilityZoneMappingSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]
Print 'Drop Procedure [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]'
GO
DROP PROCEDURE [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityZoneMappingInsert]
Print 'Drop Procedure [dbo].[usp_UtilityZoneMappingInsert]'
GO
DROP PROCEDURE [dbo].[usp_UtilityZoneMappingInsert]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Extended Property VirtualFolder_Path from [dbo].[usp_VRE_ServiceClassMapInsert]
Print 'Drop Extended Property VirtualFolder_Path from [dbo].[usp_VRE_ServiceClassMapInsert]'
GO
EXEC sp_dropextendedproperty N'VirtualFolder_Path', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_VRE_ServiceClassMapInsert', NULL, NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_VRE_ServiceClassMapInsert]
Print 'Drop Procedure [dbo].[usp_VRE_ServiceClassMapInsert]'
GO
DROP PROCEDURE [dbo].[usp_VRE_ServiceClassMapInsert]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityClassMappingInsert]
Print 'Drop Procedure [dbo].[usp_UtilityClassMappingInsert]'
GO
DROP PROCEDURE [dbo].[usp_UtilityClassMappingInsert]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityClassMappingUpdate]
Print 'Drop Procedure [dbo].[usp_UtilityClassMappingUpdate]'
GO
DROP PROCEDURE [dbo].[usp_UtilityClassMappingUpdate]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityClassMappingSelect]
Print 'Drop Procedure [dbo].[usp_UtilityClassMappingSelect]'
GO
DROP PROCEDURE [dbo].[usp_UtilityClassMappingSelect]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UtilityClassMappingDeterminantsSelectAll]
Print 'Drop Procedure [dbo].[usp_UtilityClassMappingDeterminantsSelectAll]'
GO
DROP PROCEDURE [dbo].[usp_UtilityClassMappingDeterminantsSelectAll]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Function [dbo].[GetDeterminantValue]
Print 'Drop Function [dbo].[GetDeterminantValue]'
GO
DROP FUNCTION [dbo].[GetDeterminantValue]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index idxLockStatus_AccountPropertyLockHistory from [dbo].[AccountPropertyLockHistory]
Print 'Drop Index idxLockStatus_AccountPropertyLockHistory from [dbo].[AccountPropertyLockHistory]'
GO
DROP INDEX [idxLockStatus_AccountPropertyLockHistory] ON [dbo].[AccountPropertyLockHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Table [dbo].[AccountPropertyLockHistory]
Print 'Drop Table [dbo].[AccountPropertyLockHistory]'
GO
DROP TABLE [dbo].[AccountPropertyLockHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_OfferEngineAccountDeterminants]
Print 'Drop Procedure [dbo].[usp_OfferEngineAccountDeterminants]'
GO
DROP PROCEDURE [dbo].[usp_OfferEngineAccountDeterminants]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_UsageGetMostRecentUsageDate]
Print 'Drop Procedure [dbo].[usp_UsageGetMostRecentUsageDate]'
GO
DROP PROCEDURE [dbo].[usp_UsageGetMostRecentUsageDate]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]
Print 'Drop Procedure [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]'
GO
DROP PROCEDURE [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Procedure [dbo].[usp_Determinants_FieldValueInsert]
Print 'Drop Procedure [dbo].[usp_Determinants_FieldValueInsert]'
GO
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueInsert]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Table [dbo].[TmpAccountPropertyHistory]
Print 'Drop Table [dbo].[TmpAccountPropertyHistory]'
GO
DROP TABLE [dbo].[TmpAccountPropertyHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Default Constraint DF_UtilityClassMapping_MappingRuleType from [dbo].[UtilityClassMapping]
Print 'Drop Default Constraint DF_UtilityClassMapping_MappingRuleType from [dbo].[UtilityClassMapping]'
GO
ALTER TABLE [dbo].[UtilityClassMapping] DROP CONSTRAINT [DF_UtilityClassMapping_MappingRuleType]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Column TCap from [dbo].[UtilityClassMapping]
Print 'Drop Column TCap from [dbo].[UtilityClassMapping]'
GO
ALTER TABLE [dbo].[UtilityClassMapping] DROP COLUMN [TCap]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Column ICap from [dbo].[UtilityClassMapping]
Print 'Drop Column ICap from [dbo].[UtilityClassMapping]'
GO
ALTER TABLE [dbo].[UtilityClassMapping] DROP COLUMN [ICap]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Column RuleType from [dbo].[UtilityClassMapping]
Print 'Drop Column RuleType from [dbo].[UtilityClassMapping]'
GO
ALTER TABLE [dbo].[UtilityClassMapping] DROP COLUMN [RuleType]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Default Constraint DF_UtilityZoneMapping_MappingRuleType from [dbo].[UtilityZoneMapping]
Print 'Drop Default Constraint DF_UtilityZoneMapping_MappingRuleType from [dbo].[UtilityZoneMapping]'
GO
ALTER TABLE [dbo].[UtilityZoneMapping] DROP CONSTRAINT [DF_UtilityZoneMapping_MappingRuleType]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Column RuleType from [dbo].[UtilityZoneMapping]
Print 'Drop Column RuleType from [dbo].[UtilityZoneMapping]'
GO
ALTER TABLE [dbo].[UtilityZoneMapping] DROP COLUMN [RuleType]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Primary Key PK_VRE_ServiceClassMapping_1 from [dbo].[VRE_ServiceClassMapping]
Print 'Drop Primary Key PK_VRE_ServiceClassMapping_1 from [dbo].[VRE_ServiceClassMapping]'
GO
ALTER TABLE [dbo].[VRE_ServiceClassMapping] DROP CONSTRAINT [PK_VRE_ServiceClassMapping_1]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index CIdx_DeterminantFieldMapResultants from [dbo].[DeterminantFieldMapResultants]
Print 'Drop Index CIdx_DeterminantFieldMapResultants from [dbo].[DeterminantFieldMapResultants]'
GO
DROP INDEX [CIdx_DeterminantFieldMapResultants] ON [dbo].[DeterminantFieldMapResultants]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Table [dbo].[DeterminantFieldMapResultants]
Print 'Drop Table [dbo].[DeterminantFieldMapResultants]'
GO
DROP TABLE [dbo].[DeterminantFieldMapResultants]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index idx__DateCreated_I from [dbo].[DeterminantFieldMaps]
Print 'Drop Index idx__DateCreated_I from [dbo].[DeterminantFieldMaps]'
GO
DROP INDEX [idx__DateCreated_I] ON [dbo].[DeterminantFieldMaps]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Table [dbo].[DeterminantFieldMaps]
Print 'Drop Table [dbo].[DeterminantFieldMaps]'
GO
DROP TABLE [dbo].[DeterminantFieldMaps]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index CIdx_DeterminantHistory from [dbo].[DeterminantHistory]
Print 'Drop Index CIdx_DeterminantHistory from [dbo].[DeterminantHistory]'
GO
DROP INDEX [CIdx_DeterminantHistory] ON [dbo].[DeterminantHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Table [dbo].[DeterminantHistory]
Print 'Drop Table [dbo].[DeterminantHistory]'
GO
DROP TABLE [dbo].[DeterminantHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Table [dbo].[DeterminantAlias]
Print 'Drop Table [dbo].[DeterminantAlias]'
GO
DROP TABLE [dbo].[DeterminantAlias]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index IDX_AccountPropertyHistoryTemp02 from [dbo].[AccountPropertyHistory]
Print 'Drop Index IDX_AccountPropertyHistoryTemp02 from [dbo].[AccountPropertyHistory]'
GO
DROP INDEX [IDX_AccountPropertyHistoryTemp02] ON [dbo].[AccountPropertyHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index idx__temp1 from [dbo].[AccountPropertyHistory]
Print 'Drop Index idx__temp1 from [dbo].[AccountPropertyHistory]'
GO
DROP INDEX [idx__temp1] ON [dbo].[AccountPropertyHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Table [dbo].[AccountPropertyHistory]
Print 'Drop Table [dbo].[AccountPropertyHistory]'
GO
DROP TABLE [dbo].[AccountPropertyHistory]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Type [dbo].[MappingRecord]
Print 'Drop Type [dbo].[MappingRecord]'
GO
DROP TYPE [dbo].[MappingRecord]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Type [dbo].[AccountPropertyRecord]
Print 'Drop Type [dbo].[AccountPropertyRecord]'
GO
DROP TYPE [dbo].[AccountPropertyRecord]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Type [dbo].[ResultantRecord]
Print 'Drop Type [dbo].[ResultantRecord]'
GO
DROP TYPE [dbo].[ResultantRecord]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_VRE_ServiceClassMapping_1 to [dbo].[VRE_ServiceClassMapping]
Print 'Add Primary Key PK_VRE_ServiceClassMapping_1 to [dbo].[VRE_ServiceClassMapping]'
GO
ALTER TABLE [dbo].[VRE_ServiceClassMapping]
	ADD
	CONSTRAINT [PK_VRE_ServiceClassMapping_1]
	PRIMARY KEY
	CLUSTERED
	([UtilityCode], [RawServiceClass])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Function [dbo].[GetDeterminantValue]
Print 'Create Function [dbo].[GetDeterminantValue]'
GO



CREATE FUNCTION [dbo].[GetDeterminantValue]
(
	@UtilityID varchar(80),
	@AccountNumber varchar(30),
	@FieldName varchar(60),
     @ContextDate datetime = null
)

Returns varchar(60)

AS

BEGIN
			
    DECLARE @DeterminantValue varchar(60)
	DECLARE @EffectiveDate datetime	
	DECLARE @accountFieldHistory TABLE( ID bigint, UtilityID varchar(80), AccountNumber varchar(50), FieldName varchar(60), FieldValue varchar( 200 ), EffectiveDate datetime, FieldSource varchar(60), UserIdentity varchar(256), DateCreated datetime, LockStatus varchar(60), Active bit);

	IF @ContextDate IS NULL 
	BEGIN
		SET @EffectiveDate = getdate() 
	END
	ELSE 
	BEGIN
		SET @EffectiveDate = @ContextDate
	END

	INSERT INTO @accountFieldHistory
	SELECT AccountPropertyHistoryID, UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active
	FROM AccountPropertyHistory (NOLOCK) WHERE UtilityID = @UtilityID
	AND AccountNumber = @AccountNumber
	AND FieldName = @FieldName
	AND EffectiveDate <= @ContextDate
	AND Active = 1 
	ORDER BY AccountPropertyHistoryID;
	
	IF EXISTS (SELECT * FROM @accountFieldHistory WHERE LockStatus = 'Locked' AND Active = 1)
	BEGIN
		SELECT TOP 1 @DeterminantValue = FieldValue
		FROM @accountFieldHistory
		WHERE LockStatus = 'Locked'
		AND Active = 1
		ORDER BY ID DESC;
	END
	ELSE
	BEGIN
		SELECT TOP 1 @DeterminantValue = FieldValue
		FROM @accountFieldHistory
		WHERE Active = 1
		ORDER BY ID DESC;
	END
	
RETURN @DeterminantValue

END


GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityClassMappingSelect]
Print 'Create Procedure [dbo].[usp_UtilityClassMappingSelect]'
GO

/*******************************************************************************
 * usp_UtilityClassMappingSelect
 * Gets all utility class mappings
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,m.ZoneID,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, u.UtilityCode,
			z.ZoneCode
    FROM	UtilityClassMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..RateClass r WITH (NOLOCK) ON m.RateClassID = r.ID
			LEFT JOIN LibertyPower..ServiceClass s WITH (NOLOCK) ON m.ServiceClassID = s.ID
			LEFT JOIN LibertyPower..LoadProfile p on m.LoadProfileID = p.ID
			LEFT JOIN LibertyPower..LoadShape l WITH (NOLOCK) ON m.LoadShapeID = l.ID	
			LEFT JOIN LibertyPower..TariffCode t WITH (NOLOCK) ON m.TariffCodeID = t.ID		
			LEFT JOIN LibertyPower..Voltage v WITH (NOLOCK) ON m.VoltageID = v.ID
			LEFT JOIN LibertyPower..MeterType mt WITH (NOLOCK) ON m.MeterTypeID = mt.ID
			LEFT JOIN LibertyPower..AccountType at WITH (NOLOCK) ON m.AccountTypeID = at.ID	
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON m.ZoneID = z.ID
    ORDER BY u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityClassMappingUpdate]
Print 'Create Procedure [dbo].[usp_UtilityClassMappingUpdate]'
GO
/*******************************************************************************
 * usp_UtilityClassMappingUpdate
 * Updates utility class mapping for specified record identity,
 * inserting new values into corresponding tables, if any.
 *
 * History
 *******************************************************************************
 * 12/3/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingUpdate]
	@ID					int,
	@UtilityID			int,
	@AccountTypeID		int,	
	@MeterTypeID		int,
	@VoltageID			int,	
	@RateClassCode		varchar(50),
	@ServiceClassCode	varchar(50),
	@LoadProfileCode	varchar(50),
	@LoadShapeCode		varchar(50),
	@TariffCode			varchar(50),
	@Losses				decimal(20,16) = NULL,
	@Zone				varchar(50),
	@IsActive			tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE	@RateClassID	int,
			@ServiceClassID	int,
			@LoadProfileID	int,
			@LoadShapeID	int,
			@TariffID		int,
			@ZoneID		    int 
			
	SELECT @RateClassID = ID FROM RateClass WITH (NOLOCK) WHERE RateClassCode = @RateClassCode			
	IF @RateClassID IS NULL
		BEGIN
			INSERT INTO RateClass (RateClassCode) VALUES (@RateClassCode)
			SET @RateClassID = SCOPE_IDENTITY()
		END
    
    SELECT @ServiceClassID = ID FROM ServiceClass WITH (NOLOCK) WHERE ServiceClassCode = @ServiceClassCode
	IF @ServiceClassID IS NULL
		BEGIN
			INSERT INTO ServiceClass (ServiceClassCode) VALUES (@ServiceClassCode)
			SET @ServiceClassID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadProfileID = ID FROM LoadProfile WITH (NOLOCK) WHERE LoadProfileCode = @LoadProfileCode
	IF @LoadProfileID IS NULL
		BEGIN
			INSERT INTO LoadProfile (LoadProfileCode) VALUES (@LoadProfileCode)
			SET @LoadProfileID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadShapeID = ID FROM LoadShape WITH (NOLOCK) WHERE LoadShapeCode = @LoadShapeCode
	IF @LoadShapeID IS NULL
		BEGIN
			INSERT INTO LoadShape (LoadShapeCode) VALUES (@LoadShapeCode)
			SET @LoadShapeID = SCOPE_IDENTITY()
		END
    
    SELECT @TariffID = ID FROM TariffCode WITH (NOLOCK) WHERE Code = @TariffCode
	IF @TariffID IS NULL
		BEGIN
			INSERT INTO TariffCode (Code) VALUES (@TariffCode)
			SET @TariffID = SCOPE_IDENTITY()
		END
    
    SELECT 
		@ZoneID = Z.ID 
	FROM 
		Zone Z WITH (NOLOCK) 
		Inner Join UtilityZone UZ WITH (NOLOCK) 
		On Z.ID = UZ.ZoneID
	WHERE 
		Z.ZoneCode = @Zone And
		UZ.UtilityID = @UtilityID
		
	IF @ZoneID IS NULL
		BEGIN
			INSERT INTO Zone (ZoneCode) VALUES (@Zone)
			SET @ZoneID = SCOPE_IDENTITY()
		END
		
    UPDATE	UtilityClassMapping
	SET		AccountTypeID	= @AccountTypeID,
			MeterTypeID		= @MeterTypeID,
			VoltageID		= @VoltageID,
			RateClassID		= @RateClassID,
			ServiceClassID	= @ServiceClassID,
			LoadProfileID	= @LoadProfileID,
			LoadShapeID		= @LoadShapeID,
			TariffCodeID	= @TariffID,
			LossFactor		= @Losses,
			ZoneID			= @ZoneID,
			IsActive		= @IsActive
    WHERE	ID				= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityClassMappingInsert]
Print 'Create Procedure [dbo].[usp_UtilityClassMappingInsert]'
GO
/*******************************************************************************
 * usp_UtilityClassMappingInsert
 * Inserts utility class mapping record
 *
 * History
 *******************************************************************************
 * 12/3/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingInsert]
	@UtilityID			int,
	@AccountTypeID		int,	
	@MeterTypeID		int,
	@VoltageID			int,	
	@RateClassCode		varchar(50),
	@ServiceClassCode	varchar(50),
	@LoadProfileCode	varchar(50),
	@LoadShapeCode		varchar(50),
	@TariffCode			varchar(50),
	@Losses				decimal(20,16) = NULL,
	@Zone				varchar(50),
	@IsActive			tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE	@RateClassID	int,
			@ServiceClassID	int,
			@LoadProfileID	int,
			@LoadShapeID	int,
			@TariffID		int,
			@ZoneID 		int
			
	SELECT @RateClassID = ID FROM RateClass WITH (NOLOCK) WHERE RateClassCode = @RateClassCode			
	IF @RateClassID IS NULL
		BEGIN
			INSERT INTO RateClass (RateClassCode) VALUES (@RateClassCode)
			SET @RateClassID = SCOPE_IDENTITY()
		END
    
    SELECT @ServiceClassID = ID FROM ServiceClass WITH (NOLOCK) WHERE ServiceClassCode = @ServiceClassCode
	IF @ServiceClassID IS NULL
		BEGIN
			INSERT INTO ServiceClass (ServiceClassCode) VALUES (@ServiceClassCode)
			SET @ServiceClassID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadProfileID = ID FROM LoadProfile WITH (NOLOCK) WHERE LoadProfileCode = @LoadProfileCode
	IF @LoadProfileID IS NULL
		BEGIN
			INSERT INTO LoadProfile (LoadProfileCode) VALUES (@LoadProfileCode)
			SET @LoadProfileID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadShapeID = ID FROM LoadShape WITH (NOLOCK) WHERE LoadShapeCode = @LoadShapeCode
	IF @LoadShapeID IS NULL
		BEGIN
			INSERT INTO LoadShape (LoadShapeCode) VALUES (@LoadShapeCode)
			SET @LoadShapeID = SCOPE_IDENTITY()
		END
    
    SELECT @TariffID = ID FROM TariffCode WITH (NOLOCK) WHERE Code = @TariffCode
	IF @TariffID IS NULL
		BEGIN
			INSERT INTO TariffCode (Code) VALUES (@TariffCode)
			SET @TariffID = SCOPE_IDENTITY()
		END
			
	SELECT 
		@ZoneID = Z.ID 
	FROM 
		Zone Z WITH (NOLOCK) 
		Inner Join UtilityZone UZ WITH (NOLOCK) 
		On Z.ID = UZ.ZoneID
	WHERE 
		Z.ZoneCode = @Zone And
		UZ.UtilityID = @UtilityID
	
	IF @ZoneID IS NULL
		BEGIN
			INSERT INTO Zone (ZoneCode) VALUES (@Zone)
			SET @ZoneID = SCOPE_IDENTITY()
		END
     
    INSERT INTO	UtilityClassMapping (UtilityID, AccountTypeID, MeterTypeID, VoltageID, 
				RateClassID, ServiceClassID, LoadProfileID, LoadShapeID, TariffCodeID, 
				LossFactor, ZoneID, IsActive)
	VALUES		(@UtilityID, @AccountTypeID, @MeterTypeID, @VoltageID, 
				@RateClassID, @ServiceClassID, @LoadProfileID, @LoadShapeID, @TariffID, 
				@Losses, @ZoneID, @IsActive)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityMappingByUtilityIDSelect]
Print 'Create Procedure [dbo].[usp_UtilityMappingByUtilityIDSelect]'
GO


/*******************************************************************************
 * usp_UtilityMappingByUtilityIDSelect
 * Gets the utility mappings for specified utility
 *
 * History
 *******************************************************************************
 * 11/19/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityMappingByUtilityIDSelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, 
			u.UtilityCode, u.FullName AS UtilityFullName, u.MarketID, mkt.MarketCode, m.IsActive,m.ZoneID,z.ZoneCode
    FROM	UtilityClassMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..RateClass r WITH (NOLOCK) ON m.RateClassID = r.ID
			LEFT JOIN LibertyPower..ServiceClass s WITH (NOLOCK) ON m.ServiceClassID = s.ID
			LEFT JOIN LibertyPower..LoadProfile p on m.LoadProfileID = p.ID
			LEFT JOIN LibertyPower..LoadShape l WITH (NOLOCK) ON m.LoadShapeID = l.ID	
			LEFT JOIN LibertyPower..TariffCode t WITH (NOLOCK) ON m.TariffCodeID = t.ID		
			LEFT JOIN LibertyPower..Voltage v WITH (NOLOCK) ON m.VoltageID = v.ID
			LEFT JOIN LibertyPower..MeterType mt WITH (NOLOCK) ON m.MeterTypeID = mt.ID
			LEFT JOIN LibertyPower..AccountType at WITH (NOLOCK) ON m.AccountTypeID = at.ID	
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON z.ID = m.ZoneID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
    WHERE	m.UtilityID = @UtilityID
    ORDER BY mkt.MarketCode, u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_VRE_ServiceClassMapInsert]
Print 'Create Procedure [dbo].[usp_VRE_ServiceClassMapInsert]'
GO
CREATE PROCEDURE [dbo].[usp_VRE_ServiceClassMapInsert]
(
 @UtilityCode varchar(50) ,
 @ServiceClass varchar(50),
 @RawServiceClass varchar(50) ) 
AS
SET NOCOUNT ON


IF NOT EXISTS (SELECT ID FROM VRE_ServiceClassMapping WHERE UtilityCode = @UtilityCode AND RawServiceClass = @RawServiceClass)
BEGIN 

INSERT INTO
    VRE_ServiceClassMapping (UtilityCode, ServiceClass,  RawServiceClass)
	VALUES
	( @UtilityCode, @ServiceClass,  @RawServiceClass )
END
ELSE IF EXISTS (SELECT ID FROM VRE_ServiceClassMapping WHERE UtilityCode = @UtilityCode AND RawServiceClass = @RawServiceClass)
BEGIN 

	UPDATE VRE_ServiceClassMapping SET IsActive = 1 WHERE UtilityCode = @UtilityCode AND RawServiceClass = @RawServiceClass

END

SELECT
    ID , UtilityCode, ServiceClass , RawServiceClass, DateCreated , CreatedBy , DateModified , ModifiedBy
FROM
    VRE_ServiceClassMapping 
WHERE
    IsActive = 1
    
SET NOCOUNT OFF
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Extended Property VirtualFolder_Path on [dbo].[usp_VRE_ServiceClassMapInsert]
Print 'Create Extended Property VirtualFolder_Path on [dbo].[usp_VRE_ServiceClassMapInsert]'
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'VRE', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_VRE_ServiceClassMapInsert', NULL, NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityZoneMappingSelect]
Print 'Create Procedure [dbo].[usp_UtilityZoneMappingSelect]'
GO
/*******************************************************************************
 * usp_UtilityZoneMappingSelect
 * Gets all utility zone mappings
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, uz.ZoneID, z.ZoneCode, u.UtilityCode, Grid, LBMPZone, 
			LossFactor, u.MarketID, mkt.MarketCode, m.IsActive
    FROM	UtilityZoneMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..UtilityZone uz WITH (NOLOCK) ON m.UtilityZoneID = uz.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON uz.ZoneID = z.ID
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
    ORDER BY mkt.MarketCode, u.UtilityCode, z.ZoneCode, LossFactor

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityZoneMappingUpdate]
Print 'Create Procedure [dbo].[usp_UtilityZoneMappingUpdate]'
GO
/*******************************************************************************
 * usp_UtilityZoneMappingUpdate
 * Updates utility zone mapping record
 *
 * History
 *******************************************************************************
 * 12/6/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingUpdate]
	@ID			int,
	@UtilityID	varchar(50),	
	@ZoneID		int,
	@Grid		varchar(50),
	@LbmpZone	varchar(50),
	@Losses		decimal(20,16) = NULL,
	@IsActive	tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@UtilityZoneID	int
    
    SELECT	@UtilityZoneID	= ID
    FROM	UtilityZone WITH (NOLOCK)
    WHERE	UtilityID		= @UtilityID
    AND		ZoneID			= @ZoneID
    
    IF @UtilityZoneID IS NULL
		BEGIN
			INSERT INTO UtilityZone (UtilityID, ZoneID)
			VALUES		(@UtilityID, @ZoneID)
			
			SET	@UtilityZoneID = SCOPE_IDENTITY()
		END    
     
    UPDATE	UtilityZoneMapping
    SET		Grid			= @Grid, 
			LBMPZone		= @LbmpZone, 
			LossFactor		= @Losses,
			IsActive		= @IsActive,
			UtilityZoneID	= @UtilityZoneID
	WHERE	ID				= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityMappingSelect]
Print 'Create Procedure [dbo].[usp_UtilityMappingSelect]'
GO


/*******************************************************************************
 * usp_UtilityMappingSelect
 * Gets all utility mappings
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityMappingSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, 
			u.UtilityCode, u.FullName AS UtilityFullName, u.MarketID, mkt.MarketCode, m.IsActive,m.ZoneID,z.ZoneCode
	FROM	LibertyPower..UtilityClassMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..RateClass r WITH (NOLOCK) ON m.RateClassID = r.ID
			LEFT JOIN LibertyPower..ServiceClass s WITH (NOLOCK) ON m.ServiceClassID = s.ID
			LEFT JOIN LibertyPower..LoadProfile p on m.LoadProfileID = p.ID
			LEFT JOIN LibertyPower..LoadShape l WITH (NOLOCK) ON m.LoadShapeID = l.ID	
			LEFT JOIN LibertyPower..TariffCode t WITH (NOLOCK) ON m.TariffCodeID = t.ID		
			LEFT JOIN LibertyPower..Voltage v WITH (NOLOCK) ON m.VoltageID = v.ID
			LEFT JOIN LibertyPower..MeterType mt WITH (NOLOCK) ON m.MeterTypeID = mt.ID
			LEFT JOIN LibertyPower..AccountType at WITH (NOLOCK) ON m.AccountTypeID = at.ID	
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON m.ZoneID = z.ID
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID		
	ORDER BY mkt.MarketCode, u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityZoneMappingInsert]
Print 'Create Procedure [dbo].[usp_UtilityZoneMappingInsert]'
GO
/*******************************************************************************
 * usp_UtilityZoneMappingInsert
 * Inserts utility zone mapping record
 *
 * History
 *******************************************************************************
 * 12/6/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingInsert]
	@UtilityID	int,	
	@ZoneID		int,
	@Grid		varchar(50),
	@LbmpZone	varchar(50),
	@Losses		decimal(20,16) = NULL,	
	@IsActive	tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@UtilityZoneID	int
    
    SELECT	@UtilityZoneID	= ID
    FROM	UtilityZone WITH (NOLOCK)
    WHERE	UtilityID		= @UtilityID
    AND		ZoneID			= @ZoneID
    
    IF @UtilityZoneID IS NULL
		BEGIN
			INSERT INTO UtilityZone (UtilityID, ZoneID)
			VALUES		(@UtilityID, @ZoneID)
			
			SET	@UtilityZoneID = SCOPE_IDENTITY()
		END
     
    INSERT INTO	UtilityZoneMapping (UtilityID, Grid, LBMPZone, LossFactor, IsActive, UtilityZoneID)
	VALUES		(@UtilityID, @Grid, @LbmpZone, @Losses, @IsActive, @UtilityZoneID)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]
Print 'Create Procedure [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]'
GO
/*******************************************************************************
 * usp_UtilityZoneMappingByUtilityIDSelect
 * Gets the utility zone mappings for specified utility
 *
 * History
 *******************************************************************************
 * 11/19/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, uz.ZoneID, z.ZoneCode, u.UtilityCode, Grid, LBMPZone, 
			LossFactor, u.MarketID, mkt.MarketCode, m.IsActive
    FROM	UtilityZoneMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..UtilityZone uz WITH (NOLOCK) ON m.UtilityZoneID = uz.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON uz.ZoneID = z.ID
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
    WHERE	m.UtilityID = @UtilityID
    ORDER BY mkt.MarketCode, u.UtilityCode, z.ZoneCode, LossFactor

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Alter Procedure [dbo].[usp_VRE_GetCurveFiles]
Print 'Alter Procedure [dbo].[usp_VRE_GetCurveFiles]'
GO



-- =============================================
-- Author:		Jaime Forero
-- Create date: 7/29/2010
-- Description:	gets all the file contexts for all the curve files of INF82
-- =============================================
ALTER PROCEDURE [dbo].[usp_VRE_GetCurveFiles]
	@CurveFileType VARCHAR(50) = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	IF @StartDate IS NULL
		SET @StartDate = CAST('2000-01-01' AS DATETIME);
	
	IF @EndDate IS NULL
		SET @EndDate =  DATEADD(YEAR,10,GETDATE());
		
	DECLARE @tempCurveFiles TABLE 
	(
		FileContextGUID UNIQUEIDENTIFIER,
		OriginalFileName VARCHAR(256),
		CurveFileType VARCHAR(50),
		DateCreated DATETIME,
		CreatedBy INT,
		FirstName VARCHAR(50),
		LastName VARCHAR(50),
		NumRecords INT
	);

	IF @CurveFileType IS NULL OR @CurveFileType = 'ARCreditReservePercent'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
				SELECT C.FileContextGUID,'ARCreditReservePercent', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
				FROM VREARCreditReservePercent C 
				JOIN [User] U ON C.CreatedBy = U.UserID
				GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'CaisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'CaisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRECaisoDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'CapacityTransmissionFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'CapacityTransmissionFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRECapacityTransmissionFactor C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'HourlyProfiles'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'HourlyProfiles', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREHourlyProfile C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'Markup'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'Markup', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREMarkupCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'MisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'MisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREMisoDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'NeisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'NeisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRENeisoDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'NyisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'NyisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRENyisoDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'PjmPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'PjmPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPjmDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;

	IF @CurveFileType IS NULL OR @CurveFileType = 'AncillaryServices'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'AncillaryServices', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREAncillaryServicesCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
    IF @CurveFileType IS NULL OR @CurveFileType = 'AuctionRevenueRightPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'AuctionRevenueRightPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREAuctionRevenueRightPriceCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	 -------------------------------------------------------------------------
	IF @CurveFileType IS NULL OR @CurveFileType = 'BillingTransactionCost'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'BillingTransactionCost', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREBillingTransactionCostCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'FinanceFee'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'FinanceFee', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREFinanceFeeCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'LossFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'LossFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRELossFactorItemDataCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'POR'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'POR', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPorDataCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'RenewablePortfolioStandardPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'RenewablePortfolioStandardPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRERenewablePortfolioStandardPriceCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'TCapFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'TCapFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRETCapFactorCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'TCapPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'TCapPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRETCapPriceCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'UCapFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'UCapFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREUCapFactorCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'UCapPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'UCapPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREUCapPriceCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	-------------------------------------------------------------------------------
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'DailyProfile'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'DailyProfile', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREDailyProfileCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'PromptEnergyPriceCurve'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'PromptEnergyPriceCurve', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPromptEnergyPriceCurveHeader C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'RUCSettlementCurve'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'RUCSettlementCurve', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRERUCSettlementCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'ShapingFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'ShapingFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREShapingFactorCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'SuplierPremiumFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'SuplierPremiumFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRESupplierPremiumCurveHeader C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	
	SELECT * FROM @tempCurveFiles
	WHERE  DateCreated BETWEEN @StartDate AND @EndDate;	
	
	
END



GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

