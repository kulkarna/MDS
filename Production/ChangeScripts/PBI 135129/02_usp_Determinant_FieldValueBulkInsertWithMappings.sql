USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]    Script Date: 3/28/2017 9:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ==============================================================================
-- Author:		Jikku Joseph John
-- Create date: 2/4/2014 5:00 PM
-- Description:	Take a list of candidate account properties, Get any mapping/aliasing resulting properties and insert into APH
-- ==============================================================================
-- 9/27/2016 - Rick Deigsler
-- Modified to accommodate multiple DeterminantFieldMaps for a single DeterminantFieldMapResultants
-- ==============================================================================
CREATE PROCEDURE [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings] 
	-- Add the parameters for the stored procedure here
	@AccountPropertyList as dbo.AccountPropertyHistoryRecord READONLY
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


	Create table #AccountPropertyStagingTable (seqid int identity (1,1),
	Utility VARCHAR(80),
	AccountNumber VARCHAR(50),
	FieldName varchar(60) ,
	FieldValue varchar(200) ,
	EffectiveDate datetime ,
	FieldSource varchar(60) ,
	LockStatus varchar(60),
	CreatedBy varchar(256) ,
	FieldSourceOrder int
	)
	
	Create table #ResultingAccountPropertyStagingTable (seqid int,
	Utility VARCHAR(80),
	AccountNumber VARCHAR(50),
	FieldName varchar(60) ,
	FieldValue varchar(200) ,
	EffectiveDate datetime ,
	FieldSource varchar(60) ,
	CreatedBy varchar(256),
	LockStatus varchar(60)
	)
	
	
	CREATE TABLE #PROPERTYOUTPUT (AccountPropertyHistoryID BIGINT PRIMARY KEY NONCLUSTERED, LockStatus VARCHAR(60), CreatedBy VARCHAR(256), DateCreated DATETIME) 
	
	insert into #AccountPropertyStagingTable
	select *,1 from @AccountPropertyList
	
	set identity_insert #AccountPropertyStagingTable on 
	
	--aliasing portion
	insert into #AccountPropertyStagingTable
	(seqid, Utility, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, LockStatus, FieldSourceOrder)
	select apl.seqid,apl.Utility,apl.AccountNumber,apl.FieldName,da.AliasValue,@CurrDate,'MappingAliasing','System', apl.LockStatus, 2 
	from #AccountPropertyStagingTable apl
	join DeterminantAlias da (nolock) on apl.Utility=da.UtilityCode and apl.FieldName=da.FieldName and apl.FieldValue=da.OriginalValue
	where da.DateCreated <=@CurrDate and da.Active=1 and apl.FieldSource not like 'Mapping%'
	
	--get all 
	insert into #AccountPropertyStagingTable
	(seqid, Utility, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, LockStatus, FieldSourceOrder)
	SELECT  apl.seqid, apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue, @CurrDate,'MappingOverwriteAlways', 'System', apl.LockStatus, 2
	FROM #AccountPropertyStagingTable apl
	JOIN	Libertypower..DeterminantFieldMaps dfm WITH (NOLOCK) ON apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
	JOIN	Libertypower..DeterminantResultantGroup g WITH (NOLOCK) ON dfm.ID = g.DeterminantID
	JOIN	Libertypower..DeterminantFieldMapResultants dfmr WITH (NOLOCK) ON g.GroupID = dfmr.GroupID
	where apl.FieldName <> 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
	and dfm.MappingRuleType='ReplaceValueAlways'
	
	insert into #AccountPropertyStagingTable
	(seqid, Utility, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, LockStatus, FieldSourceOrder)
	SELECT  apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue, @CurrDate,'MappingAllElseOverwriteAlways', 'System', apl.LockStatus, 2
	FROM #AccountPropertyStagingTable apl
	JOIN	Libertypower..DeterminantFieldMaps dfm WITH (NOLOCK) ON apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
	JOIN	Libertypower..DeterminantResultantGroup g WITH (NOLOCK) ON dfm.ID = g.DeterminantID
	JOIN	Libertypower..DeterminantFieldMapResultants dfmr WITH (NOLOCK) ON g.GroupID = dfmr.GroupID
	where apl.FieldName = 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
	and dfm.MappingRuleType='ReplaceValueAlways'
	
	insert into #AccountPropertyStagingTable
	(seqid, Utility, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, LockStatus, FieldSourceOrder)
	SELECT  distinct apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue, @CurrDate,'MappingOverwriteExisting', 'System', apl.LockStatus, 2
	FROM #AccountPropertyStagingTable apl
	JOIN	Libertypower..DeterminantFieldMaps dfm WITH (NOLOCK) ON apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
	JOIN	Libertypower..DeterminantResultantGroup g WITH (NOLOCK) ON dfm.ID = g.DeterminantID
	JOIN	Libertypower..DeterminantFieldMapResultants dfmr WITH (NOLOCK) ON g.GroupID = dfmr.GroupID
	join AccountPropertyHistory aph (nolock) on apl.Utility=aph.UtilityID and apl.AccountNumber=aph.AccountNumber and aph.FieldName=dfmr.ResultantFieldName
	where apl.FieldName <> 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
	and dfm.MappingRuleType='ReplaceIfValueExists'
	
	insert into #AccountPropertyStagingTable
	(seqid,Utility, AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy, LockStatus, FieldSourceOrder)
	SELECT  distinct apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue, @CurrDate,'MappingAllElseOverwriteExisting', 'System', apl.LockStatus, 2
	FROM #AccountPropertyStagingTable apl
	JOIN	Libertypower..DeterminantFieldMaps dfm WITH (NOLOCK) ON apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
	JOIN	Libertypower..DeterminantResultantGroup g WITH (NOLOCK) ON dfm.ID = g.DeterminantID
	JOIN	Libertypower..DeterminantFieldMapResultants dfmr WITH (NOLOCK) ON g.GroupID = dfmr.GroupID
	join AccountPropertyHistory aph (nolock) on apl.Utility=aph.UtilityID and apl.AccountNumber=aph.AccountNumber and aph.FieldName=dfmr.ResultantFieldName
	where apl.FieldName = 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
	and dfm.MappingRuleType='ReplaceIfValueExists'
	
	insert into #AccountPropertyStagingTable
	(seqid, Utility, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, LockStatus, FieldSourceOrder)
	SELECT  apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue, @CurrDate,'MappingFillDefaultValue', 'System', apl.LockStatus, 2
	FROM #AccountPropertyStagingTable apl
	JOIN	Libertypower..DeterminantFieldMaps dfm WITH (NOLOCK) ON apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
	JOIN	Libertypower..DeterminantResultantGroup g WITH (NOLOCK) ON dfm.ID = g.DeterminantID
	JOIN	Libertypower..DeterminantFieldMapResultants dfmr WITH (NOLOCK) ON g.GroupID = dfmr.GroupID
	left join AccountPropertyHistory aph (nolock) on apl.Utility=aph.UtilityID and apl.AccountNumber=aph.AccountNumber and aph.FieldName=dfmr.ResultantFieldName
	where apl.FieldName <> 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
	and dfm.MappingRuleType='FillIfNoHistory'  and aph.AccountPropertyHistoryID is null
	
	insert into #AccountPropertyStagingTable
	(seqid, Utility, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, LockStatus, FieldSourceOrder)
	SELECT  apl.seqid,apl.Utility, apl.AccountNumber,dfmr.ResultantFieldName, dfmr.ResultantFieldValue, @CurrDate,'MappingAllElseFillDefaultValue', 'System', apl.LockStatus, 2
	FROM #AccountPropertyStagingTable apl	
	JOIN	Libertypower..DeterminantFieldMaps dfm WITH (NOLOCK) ON apl.Utility=dfm.UtilityCode and apl.FieldName =dfm.DeterminantFieldName and apl.FieldValue=dfm.DeterminantValue
	JOIN	Libertypower..DeterminantResultantGroup g WITH (NOLOCK) ON dfm.ID = g.DeterminantID
	JOIN	Libertypower..DeterminantFieldMapResultants dfmr WITH (NOLOCK) ON g.GroupID = dfmr.GroupID
	left join AccountPropertyHistory aph (nolock) on apl.Utility=aph.UtilityID and apl.AccountNumber=aph.AccountNumber and aph.FieldName=dfmr.ResultantFieldName
	where apl.FieldName = 'Utility' and apl.FieldSource not like 'Mapping%' and (dfm.ExpirationDate is null or dfm.ExpirationDate > @CurrDate)
	and dfm.MappingRuleType='FillIfNoHistory' and aph.AccountPropertyHistoryID is null
	
	INSERT INTO dbo.AccountPropertyHistory
	( UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active)
	OUTPUT INSERTED.AccountPropertyHistoryID, INSERTED.LockStatus, INSERTED.CreatedBy, INSERTED.DateCreated INTO #PROPERTYOUTPUT
	SELECT Utility , 
	AccountNumber ,
	FieldName,
	FieldValue ,
	EffectiveDate,
	FieldSource ,
	CreatedBy,
	@CurrDate,
	LockStatus,
	1
	FROM #AccountPropertyStagingTable
	order by seqid, FieldSourceOrder
	
	INSERT INTO AccountPropertyLockHistory (
		AccountPropertyHistoryID,
		LockStatus,
		CreatedBy,
		DateCreated
	)
	SELECT AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated
	FROM #PROPERTYOUTPUT	
	
    IF @@ERROR != 0      
		ROLLBACK      
	ELSE      
		COMMIT   
		
	SET NOCOUNT OFF;  
END




