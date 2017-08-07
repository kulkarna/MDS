-- LpcNocSqlInt1\Prod

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_DataSync_ServiceAccount_Updates_ByAccountNumber]    Script Date: 10/26/2016 10:18:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_DataSync_ServiceAccount_Updates_ByAccountNumber]
	@AccountNumber varchar(30),
	@UtilityCode varchar(50)
		
/*        
 * PROCEDURE/FUNCTION/VIEW/TRIGGER:   usp_DataSync_ServiceAccount_Updates_ByAccountNumber
 *        
 * EXAMPLE:
  usp_DataSync_ServiceAccount_Updates_ByAccountNumber '463207076675025', 'CONED'

 * DEFINITION:  Used by the CRM to update data inside the CRM ServiceAccountBase
 *        
 * REVISIONS:   N/A  		10-26-2016 			New,  Created By Abhi Kulkarni
 */
AS
 BEGIN
 
	Set NOCOUNT ON
	Set transaction isolation level read uncommitted

	Create table #UpdatedAccounts  
	(
		UtilityID VARCHAR(80) ,
		AccountNumber VARCHAR(50)
	);

	INSERT INTO #UpdatedAccounts
	SELECT  DISTINCT 
			H.UtilityID ,
			H.AccountNumber
	FROM    
			dbo.vw_AccountPropertyHistory_NoFutureEffectiveDates H (NOLOCK)
	WHERE 	
		H.AccountNumber = @AccountNumber
		AND H.UtilityID = @UtilityCode
		AND Active = 1

	
	Create table #Properties  
	(
		FieldName VARCHAR(60)
	);
	
	INSERT INTO #Properties (FieldName)
	SELECT P.FieldName  
	FROM (
		SELECT 'AccountType' AS [FieldName] UNION ALL
		SELECT 'Grid' AS [FieldName] UNION ALL
		SELECT 'Icap' AS [FieldName] UNION ALL
		SELECT 'LbmpZone' AS [FieldName] UNION ALL
		SELECT 'LoadProfile' AS [FieldName] UNION ALL
		SELECT 'LoadShapeId' AS [FieldName] UNION ALL
		SELECT 'LossFactor' AS [FieldName] UNION ALL
		SELECT 'MeterType' AS [FieldName] UNION ALL
		SELECT 'RateClass' AS [FieldName] UNION ALL
		SELECT 'ServiceClass' AS [FieldName] UNION ALL
		SELECT 'TariffCode' AS [FieldName] UNION ALL
		SELECT 'Utility' AS [FieldName] UNION ALL
		SELECT 'Voltage' AS [FieldName] UNION ALL
		SELECT 'Zone' AS [FieldName] UNION ALL
		SELECT 'TCap' AS [FieldName] 
	) P

	Create clustered index cidx1 on #Properties (FieldName) with fillfactor =100
	
	Create table #AccountPropertyHistory 
	(
		ID BIGINT ,
		UtilityID VARCHAR(80) ,
		AccountNumber VARCHAR(50) ,
		FieldName VARCHAR(60) ,
		FieldValue VARCHAR(60) ,
		EffectiveDate DATETIME ,
		DateCreated DATETIME ,
		LockStatus VARCHAR(60)
	);

	-- Creating cartesian product of Utility/Account/Fields
	
	INSERT INTO #AccountPropertyHistory (UtilityID, AccountNumber, FieldName)
		SELECT UA.UtilityID, UA.AccountNumber, P.FieldName 
		FROM	#UpdatedAccounts UA 
			,	#Properties P

	Create clustered index cidx1 on #AccountPropertyHistory (UtilityID, Accountnumber, fieldname) with (fillfactor = 100, data_compression=page)


	-- Collecting  PK of available data for each Utility/account/field regardless of lock status
	
	Select	v.UtilityId
		,	v.Accountnumber
		,	v.FieldName
		,	max_AccountPropertyHistoryID = max(AccountPropertyHistoryID)
	into #t1_no_locked_join
	FROM      
		dbo.vw_AccountPropertyHistory_NoFutureEffectiveDates v with (NOLOCK) 
	join #AccountPropertyHistory t	on	t.UtilityId = v.UtilityId 
										and	t.Accountnumber = v.Accountnumber
										and	t.FieldName	= v.FieldName
	group by 											
			v.UtilityId
		,	v.Accountnumber
		,	v.FieldName


	-- Collecting PK of available data for each Utility/account/field where lock status = 'Locked'
	
	Select	v.UtilityId
		,	v.Accountnumber
		,	v.FieldName
		,	max_AccountPropertyHistoryID = max(AccountPropertyHistoryID)
	into #t1_locked_join
	FROM      
		dbo.vw_AccountPropertyHistory_NoFutureEffectiveDates v with (NOLOCK) 
	join #AccountPropertyHistory t	on	t.UtilityId = v.UtilityId 
										and	t.Accountnumber = v.Accountnumber
										and	t.FieldName	= v.FieldName
	where v.LockStatus IN ( 'Locked' )
	group by 											
			v.UtilityId
		,	v.Accountnumber
		,	v.FieldName


	Create clustered index cidx1 on #t1_no_locked_join (UtilityID, Accountnumber, fieldname) with (fillfactor = 100, data_compression=page)
	Create clustered index cidx1 on #t1_locked_join (UtilityID, Accountnumber, fieldname) with (fillfactor = 100, data_compression=page)

	-- Updating the Utility/Account/Fieldname grid with available values
	
	UPDATE T
	SET 
		ID = aph.AccountPropertyHistoryID,
		FieldValue = left(aph.FieldValue, 60), -- The receiving end of this value can only handle 60 characters.  It's ok to cut off because the largest value we have is 50 characters.
		EffectiveDate = aph.EffectiveDate,
		DateCreated = aph.DateCreated,
		LockStatus = aph.LockStatus
	from	#AccountPropertyHistory T
	join	#t1_no_locked_join		NL	on	nl.UtilityId		= T.UtilityId 
										and	nl.Accountnumber	= T.Accountnumber
										and	nl.FieldName		= T.FieldName
	Join	AccountPropertyHistory	aph on aph.AccountPropertyHistoryID = nl.max_AccountPropertyHistoryID
	where aph.FieldValue NOT LIKE '="GENERATOR"Content%' -- ### Modified by LF 6/23 to skip bad data

	UPDATE T
	SET 
		ID = aph.AccountPropertyHistoryID,
		FieldValue = left(aph.FieldValue, 60), -- The receiving end of this value can only handle 60 characters.  It's ok to cut off because the largest value we have is 50 characters.
		EffectiveDate = aph.EffectiveDate,
		DateCreated = aph.DateCreated,
		LockStatus = aph.LockStatus
	from	#AccountPropertyHistory T
	join	#t1_locked_join			NL	on	nl.UtilityId		= T.UtilityId 
										and	nl.Accountnumber	= T.Accountnumber
										and	nl.FieldName		= T.FieldName
	Join	AccountPropertyHistory	aph on aph.AccountPropertyHistoryID = nl.max_AccountPropertyHistoryID
	where aph.FieldValue NOT LIKE '="GENERATOR"Content%' -- ### Modified by LF 6/23 to skip bad data


	SELECT 
		ISNULL(UtilityID,'') + ':' + ISNULL(AccountNumber,'') [Key],
		UtilityID,
		AccountNumber,
		FieldName,
		FieldValue,
		EffectiveDate,
		DateCreated,
		LockStatus
	FROM #AccountPropertyHistory ORDER BY UtilityID, AccountNumber, FieldName ASC

	Set NOCOUNT OFF
 
 END 



GO


