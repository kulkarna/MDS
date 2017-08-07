
USE [Workspace]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]    Script Date: 02/21/2017 12:04:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]
GO

USE [Workspace]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]    Script Date: 02/21/2017 12:04:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*-- ===========================================================================================

-- Author:		Jikku Joseph John

-- Create date: 2/4/2014 5:00 PM

-- Description:	Take a list of candidate account properties, Get any mapping/aliasing resulting properties and insert into APH
*************************************************************************************************************************
--Modified By: Srikanth Bachina

--Modified Date:02/21/2017

--Convert the collation setting from "Latin1_General_CI_AS" to"SQL_Latin1_General_CP1_CI_AS" using COLLATE Command (Line no:158)
--For Columnn [lpc_UtilityCode] in [LPCNOCCRMSQL].[LIBERTYCRM_MSCRM].[dbo].[lpc_utilityBase] Table

--Convert the collation setting from "Latin1_General_CI_AS" to"SQL_Latin1_General_CP1_CI_AS" using COLLATE Command (Line no:158)
--For Columnn [lpc_AccountNumber] in [LPCNOCCRMSQL].[LIBERTYCRM_MSCRM].[dbo].[lpc_utilityBase] Table
-- =======================================================================================================*/

CREATE PROCEDURE [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings] 
      -- Add the parameters for the stored procedure here
      @AccountPropertyList as dbo.AccountPropertyHistoryRecordwk READONLY
AS
BEGIN
      SET NOCOUNT ON
      --added to prevent extra result sets from interfering with SELECT statements.
      
      BEGIN TRANSACTION
      SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

      DECLARE @CurrDate Datetime
      SELECT @CurrDate = GETDATE()
      
      ---- Insert statements for procedure here
      Create table #AccountPropertyStagingTable (seqid int identity (1,1),Utility VARCHAR(80), AccountNumber VARCHAR(50),FieldName varchar(60) ,
      FieldValue varchar(200) ,
      EffectiveDate datetime ,
      FieldSource varchar(60) ,
      CreatedBy varchar(256) ,
      FieldSourceOrder int
      )
      
      Create table #ResultingAccountPropertyStagingTable (seqid int,Utility VARCHAR(80), AccountNumber VARCHAR(50),FieldName varchar(60) ,
      FieldValue varchar(200) ,
      EffectiveDate datetime ,
      FieldSource varchar(60) ,
      CreatedBy varchar(256) )
      
      
      CREATE TABLE #PROPERTYOUTPUT (AccountPropertyHistoryID BIGINT PRIMARY KEY NONCLUSTERED, LockStatus VARCHAR(60), CreatedBy VARCHAR(256), DateCreated DATETIME) 
      
      insert into #AccountPropertyStagingTable
      select *,1 from @AccountPropertyList
      
      set identity_insert #AccountPropertyStagingTable on 
      
      --aliasing portion
      insert into #AccountPropertyStagingTable
      (seqid,Utility, AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,FieldSourceOrder)
      select apl.seqid,apl.Utility,apl.AccountNumber,apl.FieldName,da.AliasValue,@CurrDate,'MappingAliasing','System',2 
      from #AccountPropertyStagingTable apl (nolock)  
      join Libertypower..DeterminantAlias da (nolock) on apl.Utility=da.UtilityCode and apl.FieldName=da.FieldName and apl.FieldValue=da.OriginalValue
      where da.DateCreated <=@CurrDate and da.Active=1 and apl.FieldSource not like 'Mapping%'
      
      --get all 
      insert into #AccountPropertyStagingTable
      (seqid,Utility, AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,FieldSourceOrder)
      SELECT  apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue,@CurrDate,'MappingOverwriteAlways', 'System',2
      FROM #AccountPropertyStagingTable apl
      join Libertypower..DeterminantFieldMaps dfm (nolock) on apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
      join Libertypower..DeterminantFieldMapResultants dfmr (nolock) on dfm.ID=dfmr.FieldMapID  
      where apl.FieldName <> 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
      and dfm.MappingRuleType='ReplaceValueAlways'
      
      insert into #AccountPropertyStagingTable
      (seqid,Utility, AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,FieldSourceOrder)
      SELECT  apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue,@CurrDate,'MappingAllElseOverwriteAlways', 'System',2
      FROM #AccountPropertyStagingTable apl (nolock)
      join Libertypower..DeterminantFieldMaps dfm (nolock) on apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
      join Libertypower..DeterminantFieldMapResultants dfmr (nolock) on dfm.ID=dfmr.FieldMapID  
      where apl.FieldName = 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
      and dfm.MappingRuleType='ReplaceValueAlways'
      
      insert into #AccountPropertyStagingTable
      (seqid,Utility, AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,FieldSourceOrder)
      SELECT  distinct apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue,@CurrDate,'MappingOverwriteExisting', 'System',2
      FROM #AccountPropertyStagingTable apl (nolock)
      join Libertypower..DeterminantFieldMaps dfm (nolock) on apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
      join Libertypower..DeterminantFieldMapResultants dfmr (nolock) on dfm.ID=dfmr.FieldMapID  
      join Libertypower..AccountPropertyHistory aph (nolock) on apl.Utility=aph.UtilityID and apl.AccountNumber=aph.AccountNumber and aph.FieldName=dfmr.ResultantFieldName
      where apl.FieldName <> 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
      and dfm.MappingRuleType='ReplaceIfValueExists'
      
      insert into #AccountPropertyStagingTable
      (seqid,Utility, AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,FieldSourceOrder)
      SELECT  distinct apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue,@CurrDate,'MappingAllElseOverwriteExisting', 'System',2
      FROM #AccountPropertyStagingTable apl (nolock)
      join Libertypower..DeterminantFieldMaps dfm (nolock) on apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
      join Libertypower..DeterminantFieldMapResultants dfmr (nolock) on dfm.ID=dfmr.FieldMapID  
      join Libertypower..AccountPropertyHistory aph (nolock) on apl.Utility=aph.UtilityID and apl.AccountNumber=aph.AccountNumber and aph.FieldName=dfmr.ResultantFieldName
      where apl.FieldName = 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
      and dfm.MappingRuleType='ReplaceIfValueExists'
      
      insert into #AccountPropertyStagingTable
      (seqid,Utility, AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,FieldSourceOrder)
      SELECT  apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue,@CurrDate,'MappingFillDefaultValue', 'System',2
      FROM #AccountPropertyStagingTable apl (nolock)
      join Libertypower..DeterminantFieldMaps dfm (nolock) on apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
      join Libertypower..DeterminantFieldMapResultants dfmr (nolock) on dfm.ID=dfmr.FieldMapID  
      left join Libertypower..AccountPropertyHistory aph (nolock) on apl.Utility=aph.UtilityID and apl.AccountNumber=aph.AccountNumber and aph.FieldName=dfmr.ResultantFieldName
      where apl.FieldName <> 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
      and dfm.MappingRuleType='FillIfNoHistory'  and aph.AccountPropertyHistoryID is null
      
      insert into #AccountPropertyStagingTable
      (seqid,Utility, AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,FieldSourceOrder)
      SELECT  apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue,@CurrDate,'MappingAllElseFillDefaultValue', 'System',2
      FROM #AccountPropertyStagingTable apl (nolock)
      join Libertypower..DeterminantFieldMaps dfm (nolock) on apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
      join Libertypower..DeterminantFieldMapResultants dfmr (nolock) on dfm.ID=dfmr.FieldMapID  
      left join Libertypower..AccountPropertyHistory aph (nolock) on apl.Utility=aph.UtilityID and apl.AccountNumber=aph.AccountNumber and aph.FieldName=dfmr.ResultantFieldName
      where apl.FieldName = 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
      and dfm.MappingRuleType='FillIfNoHistory' and aph.AccountPropertyHistoryID is null
      
--  INSERT INTO WorkSpace..AccountPropertyHistoryTEMTEST
      INSERT INTO Libertypower..AccountPropertyHistory
      ( UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active)
      OUTPUT INSERTED.AccountPropertyHistoryID, INSERTED.LockStatus,INSERTED.CreatedBy, INSERTED.DateCreated INTO #PROPERTYOUTPUT
      SELECT AA.Utility , 
      AA.AccountNumber ,
      AA.FieldName,
      AA.FieldValue ,
      AA.EffectiveDate,
      AA.FieldSource ,
      AA.CreatedBy,
      @CurrDate,
      'Unknown',
      1
      FROM #AccountPropertyStagingTable AA (NOLOCK)
      INNER JOIN [LPCNOCCRMSQL].[LIBERTYCRM_MSCRM].[dbo].[lpc_utilityBase] UT WITH (NOLOCK)
	  --Convert the collation setting from "collate Latin1_General_CI_AS" to"SQL_Latin1_General_CP1_CI_AS" using COLLATE Command
	  ON UT.[lpc_UtilityCode]	COLLATE SQL_Latin1_General_CP1_CI_AS = AA.Utility 
      INNER JOIN [LPCNOCCRMSQL].LIBERTYCRM_MSCRM.dbo.lpc_serviceaccountBase BB WITH (NOLOCK)
      ON BB.[lpc_utilityId]               = UT.[lpc_utilityId]
	  --Convert the collation setting from "collate Latin1_General_CI_AS" to"SQL_Latin1_General_CP1_CI_AS" using COLLATE Command
      AND BB.[lpc_AccountNumber] COLLATE SQL_Latin1_General_CP1_CI_AS = AA.AccountNumber

      --INSERT INTO workspace..AccountPropertyLockHistoryTEMTEST (AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated)
      INSERT INTO Libertypower..AccountPropertyLockHistory (AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated)
      SELECT AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated
      FROM #PROPERTYOUTPUT (NOLOCK)
      
    IF @@ERROR != 0      
            ROLLBACK      
      ELSE      
            COMMIT   
            
      SET NOCOUNT OFF;  
END

GO


