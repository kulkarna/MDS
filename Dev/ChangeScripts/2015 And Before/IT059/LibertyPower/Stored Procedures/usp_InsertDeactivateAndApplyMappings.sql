USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertDeactivateAndApplyMappings]    Script Date: 11/21/2013 13:34:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_InsertDeactivateAndApplyMappings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_InsertDeactivateAndApplyMappings]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertDeactivateAndApplyMappings]    Script Date: 11/21/2013 13:34:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jikku Joseph John
-- Create date: 5/14/2013
-- Description:	Takes a list of mappings/rules and does the appropriate insertion/deactivation and
-- application to target accounts
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertDeactivateAndApplyMappings] 
	-- Add the parameters for the stored procedure here
	@MappingList as dbo.MappingRecord READONLY,
	@ResultantList as dbo.ResultantRecord READONLY,
	@CreatedBy as varchar(256) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	BEGIN TRANSACTION
	SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @CurrDate Datetime
	SELECT @CurrDate = GETDATE()
	
	-- Insert statements for procedure here
	Create table #MappingsTable (seqid int identity (1,1), MappingStyle VARCHAR(60), Utility VARCHAR(80), DeterminantName VARCHAR(60), DeterminantValue VARCHAR(200), DeleteOrNot VARCHAR(20))

	Create table #ResultantsTable (seqid int identity (1,1) primary key, MappingStyle VARCHAR(60), Utility VARCHAR(80), DeterminantName VARCHAR(60), DeterminantValue VARCHAR(200), ResultantName VARCHAR(60), ResultantValue VARCHAR(200),DeleteOrNot VARCHAR(20))
	
	INSERT INTO #MappingsTable(MappingStyle, Utility, DeterminantName, DeterminantValue, DeleteOrNot)
	SELECT MappingStyle, Utility, DeterminantName, DeterminantValue, DeleteOrNot
	FROM
	@MappingList
	
	Create clustered index cidx1 on #MappingsTable (Utility, DeterminantName, DeterminantValue)

	INSERT INTO #ResultantsTable(MappingStyle, Utility, DeterminantName, DeterminantValue, ResultantName, ResultantValue, DeleteOrNot)
	SELECT 
	MappingStyle, Utility, DeterminantName, DeterminantValue, ResultantName, ResultantValue, DeleteOrNot
	FROM
	@ResultantList

	UPDATE  dfm
	SET dfm.ExpirationDate = @CurrDate
	FROM DeterminantFieldMaps dfm
	JOIN #MappingsTable mt ON mt.Utility = dfm.UtilityCode AND mt.DeterminantName= dfm.DeterminantFieldName AND mt.DeterminantValue=dfm.DeterminantValue
	WHERE dfm.ExpirationDate IS NULL 
	
	--Insert mapping and the resultants
	Create table #OUTPUT (ID int primary KEY NONCLUSTERED, UtilityCode VARCHAR(80), DeterminantFieldName VARCHAR(60), DeterminantValue VARCHAR(200)) 
	
	INSERT INTO DeterminantFieldMaps(UtilityCode,DeterminantFieldName,DeterminantValue,MappingRuleType,DateCreated,CreatedBy)
	OUTPUT INSERTED.ID, INSERTED.UtilityCode,INSERTED.DeterminantFieldName, INSERTED.DeterminantValue into #OUTPUT
	SELECT mt.Utility, mt.DeterminantName, ltrim(rtrim(mt.DeterminantValue)), mt.MappingStyle, @CurrDate, @CreatedBy
	FROM		 #MappingsTable	  mt
	where mt.DeleteOrNot = 'N' OR mt.DeleteOrNot = 'No'

	CREATE CLUSTERED INDEX cidx1
    ON #OUTPUT ([UtilityCode],[DeterminantFieldName],[DeterminantValue])
    with fillfactor = 50

	INSERT INTO DeterminantFieldMapResultants(FieldMapID, ResultantFieldName, ResultantFieldValue)
	SELECT dfm.ID, rt.ResultantName, rt.ResultantValue
	FROM #ResultantsTable rt
	JOIN #OUTPUT dfm on rt.Utility = dfm.UtilityCode AND rt.DeterminantName= dfm.DeterminantFieldName AND rt.DeterminantValue=dfm.DeterminantValue
	
	---- Do the account specific inserts!!
	---- the second join is to filter only those which match on

	CREATE TABLE #TempAccountPropertyHistory (seqid int identity (1,1), UtilityID VARCHAR(80), AccountNumber VARCHAR(50), FieldName VARCHAR(60), FieldValue VARCHAR(200), EffectiveDate DATETIME, FieldSource VARCHAR(60), CreatedBy VARCHAR(256), DateCreated DATETIME, LockStatus VARCHAR(60), ACTIVE BIT)
     
     --If fieldname for the mapping is Utility and the mappingstyle is FillIfNoHistory and no items exist in Determinants history with the account, utility and the tracked field being same as in the account specific field value, insert account specific field value into DeterminantHistory setting FieldSource to MappingAllElseFillDefaultValue
     INSERT INTO #TempAccountPropertyHistory
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingAllElseFillDefaultValue', @CreatedBy,@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN		 dbo.AccountPropertyHistory aphDriver	 ON rt.Utility = aphDriver.UtilityID    AND rt.DeterminantName = aphDriver.FieldName   AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	LEFT JOIN	 dbo.AccountPropertyHistory aphResultant ON aphDriver.AccountNumber = aphResultant.AccountNumber AND rt.Utility = aphResultant.UtilityID AND rt.ResultantName = aphResultant.FieldName AND aphResultant.Active = 1	
	WHERE rt.DeterminantName = 'Utility' AND rt.MappingStyle = 'FillIfNoHistory' AND aphResultant.UtilityID IS NULL AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')

	--If fieldname for the mapping is Utility and the mappingstyle is ReplaceValueAlways, insert account specific field value into DeterminantHistory setting FieldSource to MappingAllElseOverwriteAlways
	INSERT INTO #TempAccountPropertyHistory
	        ( UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active)
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingAllElseOverwriteAlways', @CreatedBy,@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN dbo.AccountPropertyHistory aphDriver ON rt.Utility = aphDriver.UtilityID AND rt.DeterminantName = aphDriver.FieldName AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	WHERE rt.DeterminantName = 'Utility' AND rt.MappingStyle = 'ReplaceValueAlways' AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
	--If fieldname for the mapping is Utility and the mappingstyle is ReplaceIfValueExists and the resultantfield has an entry for the account, insert account specific field value into DeterminantHistory setting FieldSource to MappingAllElseOverwriteAlways
	INSERT INTO #TempAccountPropertyHistory
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingAllElseOverwriteExisting', @CreatedBy,@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN		 dbo.AccountPropertyHistory aphDriver	 ON rt.Utility = aphDriver.UtilityID    AND rt.DeterminantName = aphDriver.FieldName   AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	JOIN	 dbo.AccountPropertyHistory aphResultant ON aphDriver.AccountNumber = aphResultant.AccountNumber AND rt.Utility = aphResultant.UtilityID AND rt.ResultantName = aphResultant.FieldName AND aphResultant.Active = 1	
	WHERE rt.DeterminantName = 'Utility' AND rt.MappingStyle = 'ReplaceIfValueExists' AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
     --If fieldname for the mapping is not Utility and the mappingstyle is FillIfNoHistory and no items exist in Determinants history with the account, utility and the tracked field being same as in the account specific field value, insert account specific field value into DeterminantHistory setting FieldSource to MappingFillDefaultValue
     INSERT INTO #TempAccountPropertyHistory
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingFillDefaultValue',@CreatedBy,@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN		 dbo.AccountPropertyHistory aphDriver	 ON rt.Utility = aphDriver.UtilityID    AND rt.DeterminantName = aphDriver.FieldName   AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	LEFT JOIN	 dbo.AccountPropertyHistory aphResultant ON aphDriver.AccountNumber = aphResultant.AccountNumber AND rt.Utility = aphResultant.UtilityID AND rt.ResultantName = aphResultant.FieldName AND aphResultant.Active = 1	
	WHERE rt.DeterminantName <> 'Utility' AND rt.MappingStyle = 'FillIfNoHistory' AND aphResultant.UtilityID IS NULL AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
	--If fieldname for the mapping is not Utility and the mappingstyle is ReplaceValueAlways, insert account specific field value into DeterminantHistory setting FieldSource to MappingOverwriteAlways
	INSERT INTO #TempAccountPropertyHistory
	        ( UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active)
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingOverwriteAlways',@CreatedBy,@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN dbo.AccountPropertyHistory aphDriver ON rt.Utility = aphDriver.UtilityID AND rt.DeterminantName = aphDriver.FieldName AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	WHERE rt.DeterminantName <> 'Utility' AND rt.MappingStyle = 'ReplaceValueAlways' AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
	--If fieldname for the mapping is not Utility and the mappingstyle is ReplaceIfValueExists and the resultantfield has an entry for the account, insert account specific field value into DeterminantHistory setting FieldSource to MappingOverwriteExisting
	INSERT INTO #TempAccountPropertyHistory
	SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingOverwriteExisting', @CreatedBy,@CurrDate,'Unknown',1
	FROM #ResultantsTable rt
	JOIN		 dbo.AccountPropertyHistory aphDriver	 ON rt.Utility = aphDriver.UtilityID    AND rt.DeterminantName = aphDriver.FieldName   AND rt.DeterminantValue = aphDriver.FieldValue AND aphDriver.Active = 1
	JOIN	 dbo.AccountPropertyHistory aphResultant ON aphDriver.AccountNumber = aphResultant.AccountNumber AND rt.Utility = aphResultant.UtilityID AND rt.ResultantName = aphResultant.FieldName AND aphResultant.Active = 1	
	WHERE rt.DeterminantName <> 'Utility' AND rt.MappingStyle = 'ReplaceIfValueExists' AND (rt.DeleteOrNot ='N' OR rt.DeleteOrNot='No')
	
	CREATE TABLE #PROPERTYOUTPUT (AccountPropertyHistoryID BIGINT PRIMARY KEY NONCLUSTERED, LockStatus VARCHAR(60), CreatedBy VARCHAR(256), DateCreated DATETIME) 
	
	INSERT INTO dbo.AccountPropertyHistory
	( UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active)
	OUTPUT INSERTED.AccountPropertyHistoryID, INSERTED.LockStatus,INSERTED.CreatedBy, INSERTED.DateCreated INTO #PROPERTYOUTPUT
	SELECT UtilityID, AccountNumber, FieldName, FieldValue, Cast(EffectiveDate as Date), FieldSource, CreatedBy, DateCreated, LockStatus, Active 
	FROM #TempAccountPropertyHistory
	
	INSERT INTO AccountPropertyLockHistory (AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated)
	SELECT AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated
	FROM #PROPERTYOUTPUT	
	
    IF @@ERROR != 0      
		ROLLBACK      
	ELSE      
		COMMIT   
		
	SET NOCOUNT OFF;  
END


GO


