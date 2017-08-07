USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetIT059MigrationDataMissingEnrolled]    Script Date: 08/19/2013 10:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetIT059MigrationDataMissingEnrolled]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetIT059MigrationDataMissingEnrolled]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetIT059MigrationDataMissingEnrolled]    Script Date: 08/19/2013 10:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku John
-- Create date: 8/21/2013
-- Description:	Getting all IT059 migration data(missing enrolled)

/*

*/
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetIT059MigrationDataMissingEnrolled]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      


-- to get mutliple meter utilities

	if OBJECT_ID('tempdb..#GridResult') is not null
	drop table #GridResult

	if OBJECT_ID('tempdb..#EnrolledAccounts') is not null
	drop table #EnrolledAccounts
	
	if OBJECT_ID('tempdb..#UnEnrolledAccounts') is not null
		drop table #UnEnrolledAccounts
	

	if OBJECT_ID('tempdb..#LatestIcapDates') is not null
		drop table #LatestIcapDates
	if OBJECT_ID('tempdb..#LatestTcapDates') is not null
		drop table #LatestTcapDates

	if OBJECT_ID('tempdb..#LatestIcaps') is not null
			drop table #LatestIcaps
	if OBJECT_ID('tempdb..#LatestTcaps') is not null
		drop table #LatestTcaps
		
	if OBJECT_ID('tempdb..#MultipleMeterAmeren') is not null
		drop table #MultipleMeterAmeren
	
	if OBJECT_ID('tempdb..#SingleMeterAmeren') is not null
		drop table #SingleMeterAmeren
	
	
	if OBJECT_ID('tempdb..#LatestEdiDates') is not null
		drop table #LatestEdiDates	
		
	if OBJECT_ID('tempdb..#LatestIcapDates1') is not null
			drop table #LatestIcapDates1
	if OBJECT_ID('tempdb..#LatestTcapDates1') is not null
		drop table #LatestTcapDates1	
	
	if OBJECT_ID('tempdb..#EdiEnrolledAmeren') is not null
		drop table #EdiEnrolledAmeren

	if OBJECT_ID('tempdb..#EnrolledMissingIcaps') is not null
		drop table #EnrolledMissingIcaps
	
	if OBJECT_ID('tempdb..#EnrolledMissingTcaps') is not null
		drop table #EnrolledMissingTcaps
	
	if OBJECT_ID('tempdb..#IstaIcapsTcaps') is not null
		drop table #IstaIcapsTcaps
	
	if OBJECT_ID('tempdb..#EnrolledAmerenMissingIcaps') is not null
		drop table #EnrolledAmerenMissingIcaps
		
	if OBJECT_ID('tempdb..#UnchangedAccountNumberOeAccounts') is not null
		drop table #UnchangedAccountNumberOeAccounts
		
	if OBJECT_ID('tempdb..#ChangedAccountNumberOeAccounts') is not null
		drop table #ChangedAccountNumberOeAccounts
	
	if OBJECT_ID('tempdb..#AccountNumberChanges') is not null
		drop table #AccountNumberChanges	
		
	--
	Create table #LatestIcapDates(Utilitycode varchar(80), AccountNumber varchar(50), LatestInsert datetime)
	Create table #LatestTcapDates(Utilitycode varchar(80), AccountNumber varchar(50), LatestInsert datetime)
	Create table #LatestIcaps(Utilitycode varchar(80), AccountNumber varchar(50), Icap decimal(12,6), EffectiveDate datetime)
	Create table #LatestTcaps(Utilitycode varchar(80), AccountNumber varchar(50),Tcap decimal(12,6), EffectiveDate datetime)
	Create table #EnrolledMissingIcaps(Utilitycode varchar(80), AccountNumber varchar(50))
	Create table #EnrolledMissingTcaps(Utilitycode varchar(80), AccountNumber varchar(50))
	Create table #EnrolledAmerenMissingIcaps(Utilitycode varchar(80), AccountNumber varchar(50))
	Create table #UnchangedAccountNumberOeAccounts(Utilitycode varchar(80), AccountNumber varchar(50))
	Create table #ChangedAccountNumberOeAccounts(Utilitycode varchar(80), OldAccountNumber varchar(50),NewAccountNumber varchar(50))
	Create table #AccountNumberChanges(Utilitycode varchar(80), OldAccountNumber varchar(50),NewAccountNumber varchar(50))
	Create table #UnEnrolledAccounts(Utilitycode varchar(80), OldAccountNumber varchar(50),NewAccountNumber varchar(50), MarketID int)
	Create table #EnrolledAccounts(Utilitycode varchar(80), OldAccountNumber varchar(50),NewAccountNumber varchar(50))
	
	insert into #AccountNumberChanges
	select u.UtilityCode,anh.old_account_number,anh.new_account_number 
	from lp_account..account_number_history anh (nolock)
	join libertypower..account a (nolock) on anh.account_id = a.AccountIdLegacy
	join libertypower..Utility u (nolock) on a.UtilityID=u.id
	
	insert into #EnrolledAccounts	
	SELECT distinct cast(u.UtilityCode as varchar(80)) ,cast(a.AccountNumber as varchar(50)),cast(a.AccountNumber as varchar(50))
	FROM OfferEngineDB..OE_ACCOUNT OE  (NOLOCK)
	INNER JOIN Libertypower..Utility U  (NOLOCK) ON OE.UTILITY = U.UtilityCode
	JOIN Libertypower..Account A  (NOLOCK) ON OE.ACCOUNT_NUMBER = A.AccountNumber AND A.UtilityID = U.ID
	JOIN Libertypower..AccountContract AC  (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN Libertypower..AccountStatus AST  (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE AST.[Status] = '906000' -- enrolled
	--AND U.MarketID NOT IN (1,2) -- excluding ca and tx
	
	
	insert into #EnrolledAccounts	
	SELECT distinct  cast(u.UtilityCode as varchar(80)),oa.Account_number, cast(a.AccountNumber as varchar(50))
	FROM Libertypower..Account A WITH (NOLOCK)
	
	JOIN Libertypower..Utility u (nolock) on a.UtilityID=u.id
	JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID

	join lp_account..account_number_history anh (nolock) on anh.account_id=a.AccountIdLegacy

	join OfferEngineDB..OE_ACCOUNT oa WITH (NOLOCK) on oa.ACCOUNT_NUMBER=anh.old_account_number and oa.UTILITY=u.UtilityCode
	WHERE AST.[Status] = '906000' -- enrolled
	--AND U.MarketID NOT IN (1,2) -- excluding ca and tx
	
	Create clustered index #EnrolledAccounts_cidx1 on #EnrolledAccounts (UtilityCode, OldAccountNumber, NewAccountNumber) with fillfactor =100
	--select * from #EnrolledAccounts
	--MISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.OldAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' from
	#EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='miso'
	and a.Icap is not null and len(a.Icap)> 0
	--NYISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.OldAccountNumber,cast(a.Icap as decimal(12,6)),'05/01/2013' from
	#EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='nyiso'
	and a.Icap is not null and len(a.Icap)> 0
	--PJM 
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.OldAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' from
	#EnrolledAccounts ea (nolock) 
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='pjm'
	and a.Icap is not null and len(a.Icap)> 0
	
	insert into #LatestTcaps
	SELECT ea.UtilityCode,ea.OldAccountNumber,cast(a.Tcap as decimal(12,6)),'01/01/2013' from
	#EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.newAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='pjm'
	and a.Tcap is not null and len(a.Tcap)> 0
	--NEISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.OldAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' from
	#EnrolledAccounts ea (nolock) 
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='neiso'
	and a.Icap is not null and len(a.Icap)> 0
	----------------------------Beginning of Handlement for PROSPECT accounts---------------------
	
	
	--Start of common part
	
	select * from #LatestIcaps
	select * from #LatestTcaps

	select aa.AccountNumber, aa.Servicepoint, aa.EffectivePLC, aa.EligibleSwitchDate,Created from lp_transactions..amerenaccount aa with (nolock)
	join #UnEnrolledAccounts uea on uea.NewAccountNumber = aa.AccountNumber
	where uea.UtilityCode = 'Ameren'
	
	SELECT ISNULL(oa.UTILITY, '') AS UTILITY,
	ISNULL(oa.ACCOUNT_NUMBER, '') AS ACCOUNT_NUMBER,
	ISNULL(oa.METER_TYPE, '') AS METER_TYPE ,
	ISNULL(oa.RATE_CLASS, '') AS RATE_CLASS ,
	ISNULL(oa.VOLTAGE, '') AS VOLTAGE,
	ISNULL(oa.ZONE, '') AS ZONE,
	ISNULL(oa.LOAD_SHAPE_ID, '') AS LOAD_SHAPE_ID,
	ISNULL(oa.LOAD_PROFILE, '')  AS LOAD_PROFILE,
	ISNULL(oa.TarrifCode, '')  AS TarrifCode,
	ISNULL(oa.Grid, '') AS Grid,
	ISNULL(oa.LbmpZone, '') AS LbmpZone,
	ISNULL(oa.ICAP, 0) AS ICAP,
	ISNULL(oa.TCAP, 0) AS TCAP,
	CASE
		WHEN oa.LOSSES IS NULL THEN ''
		else CONVERT(varchar,oa.Losses)
	END AS LOSSES
	FROM OfferEngineDB..OE_ACCOUNT oa WITH (NOLOCK)
	JOIN #UnEnrolledAccounts uea (nolock) on uea.OldAccountNumber=oa.Account_Number
	union
	SELECT ISNULL(oa.UTILITY, '') AS UTILITY,
	ISNULL(oa.ACCOUNT_NUMBER, '') AS ACCOUNT_NUMBER,
	ISNULL(oa.METER_TYPE, '') AS METER_TYPE ,
	ISNULL(oa.RATE_CLASS, '') AS RATE_CLASS ,
	ISNULL(oa.VOLTAGE, '') AS VOLTAGE,
	ISNULL(oa.ZONE, '') AS ZONE,
	ISNULL(oa.LOAD_SHAPE_ID, '') AS LOAD_SHAPE_ID,
	ISNULL(oa.LOAD_PROFILE, '')  AS LOAD_PROFILE,
	ISNULL(oa.TarrifCode, '')  AS TarrifCode,
	ISNULL(oa.Grid, '') AS Grid,
	ISNULL(oa.LbmpZone, '') AS LbmpZone,
	ISNULL(oa.ICAP, 0) AS ICAP,
	ISNULL(oa.TCAP, 0) AS TCAP,
	CASE
		WHEN oa.LOSSES IS NULL THEN ''
		else CONVERT(varchar,oa.Losses)
	END AS LOSSES
	FROM OfferEngineDB..OE_ACCOUNT oa WITH (NOLOCK)
	JOIN #EnrolledAccounts ea (nolock) on ea.OldAccountNumber=oa.Account_Number
	
	SET NOCOUNT OFF
END




GO
