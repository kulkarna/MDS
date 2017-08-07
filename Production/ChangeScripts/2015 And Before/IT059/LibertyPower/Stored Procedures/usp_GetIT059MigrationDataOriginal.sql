USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetIT059MigrationDataOriginal]    Script Date: 08/19/2013 10:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetIT059MigrationDataOriginal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetIT059MigrationDataOriginal]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetIT059MigrationDataOriginal]    Script Date: 08/19/2013 10:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jikku John
-- Create date: 8/21/2013
-- Description:	Getting all IT059 migration data(original)

/*

*/
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetIT059MigrationDataOriginal]
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
	WHERE AST.[Status] = '905000' -- enrolled
	--AND U.MarketID NOT IN (1,2) -- excluding ca and tx
	
	
	insert into #EnrolledAccounts	
	SELECT distinct  cast(u.UtilityCode as varchar(80)),oa.Account_number, cast(a.AccountNumber as varchar(50))
	FROM Libertypower..Account A WITH (NOLOCK)
	
	JOIN Libertypower..Utility u (nolock) on a.UtilityID=u.id
	JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID

	join lp_account..account_number_history anh (nolock) on anh.account_id=a.AccountIdLegacy

	join OfferEngineDB..OE_ACCOUNT oa WITH (NOLOCK) on oa.ACCOUNT_NUMBER=anh.old_account_number and oa.UTILITY=u.UtilityCode
	WHERE AST.[Status] = '905000' -- enrolled
	--AND U.MarketID NOT IN (1,2) -- excluding ca and tx
	
	Create clustered index #EnrolledAccounts_cidx1 on #EnrolledAccounts (UtilityCode, OldAccountNumber, NewAccountNumber) with fillfactor =100
	
	--MISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' from
	#EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='miso'
	and a.Icap is not null and len(a.Icap)> 0
	--NYISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'05/01/2013' from
	#EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='nyiso'
	and a.Icap is not null and len(a.Icap)> 0
	--PJM 
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' from
	#EnrolledAccounts ea (nolock) 
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='pjm'
	and a.Icap is not null and len(a.Icap)> 0
	
	insert into #LatestTcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'01/01/2013' from
	#EnrolledAccounts ea (nolock)
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.newAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='pjm'
	and a.Icap is not null and len(a.Icap)> 0
	--NEISO
	insert into #LatestIcaps
	SELECT ea.UtilityCode,ea.NewAccountNumber,cast(a.Icap as decimal(12,6)),'06/01/2013' from
	#EnrolledAccounts ea (nolock) 
	join libertypower..Utility u (nolock) on ea.UtilityCode=u.UtilityCode
	join libertypower..Account a (nolock) on a.AccountNumber=ea.NewAccountNumber and a.UtilityID=u.id
	where u.WholeSaleMktID='neiso'
	and a.Icap is not null and len(a.Icap)> 0
	----------------------------Beginning of Handlement for PROSPECT accounts---------------------
	
	insert into #UnEnrolledAccounts
	select distinct oa.utility, oa.Account_Number,anc.NewAccountNumber,u.MarketID
	
	from offerenginedb..oe_account oa (nolock)
	join #AccountNumberChanges anc (nolock) on oa.ACCOUNT_NUMBER=anc.OldAccountNumber and oa.UTILITY= anc.Utilitycode
	JOIN OfferEngineDB..OE_OFFER_ACCOUNTS ooa (NOLOCK) on ooa.OE_ACCOUNT_ID =oa.ID 
	JOIN OfferEngineDB..OE_OFFER oo (nolock) on oo.OFFER_ID= ooa.OFFER_ID
	join libertypower..Utility u (nolock) on oa.UTILITY =u.UtilityCode
	join libertypower..account a (nolock) on anc.NewAccountNumber=a.AccountNumber and u.ID = a.UtilityID
	JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE 1=1 
	--U.MarketID NOT IN (1,2) -- excluding ca and tx
	AND oo.DATE_CREATED >= '01/01/2013'
	and AST.[Status] <> '905000'
	
	insert into #UnEnrolledAccounts
	select distinct oa.utility, oa.ACCOUNT_NUMBER,oa.ACCOUNT_NUMBER,u.MarketID
	from offerenginedb..oe_account oa (nolock)
	left join #AccountNumberChanges anc (nolock) on oa.ACCOUNT_NUMBER=anc.OldAccountNumber and oa.UTILITY= anc.Utilitycode
	
	JOIN OfferEngineDB..OE_OFFER_ACCOUNTS ooa (NOLOCK) on ooa.OE_ACCOUNT_ID =oa.ID 
	JOIN OfferEngineDB..OE_OFFER oo (nolock) on oo.OFFER_ID= ooa.OFFER_ID
	
	join libertypower..Utility u (nolock) on oa.UTILITY =u.UtilityCode
	
	left join libertypower..account a (nolock) on anc.NewAccountNumber=a.AccountNumber and u.ID = a.UtilityID
	LEFT JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	LEFT JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE 1=1 
	--U.MarketID NOT IN (1,2) -- excluding ca and tx
	AND oo.DATE_CREATED >= '01/01/2013'
	and anc.OldAccountNumber is null
	and (a.AccountID is null or AST.[Status] <> '905000')
	
	insert into #UnEnrolledAccounts
	select distinct oa.utility, oa.Account_Number,anc.NewAccountNumber,u.MarketID
	
	from offerenginedb..oe_account oa (nolock)
	join #AccountNumberChanges anc (nolock) on oa.ACCOUNT_NUMBER=anc.OldAccountNumber and oa.UTILITY= anc.Utilitycode
	JOIN OfferEngineDB..OE_PRICING_REQUEST_ACCOUNTS pra (NOLOCK) on pra.OE_ACCOUNT_ID =oa.ID 
	JOIN OfferEngineDB..OE_PRICING_REQUEST pr (nolock) on pr.REQUEST_ID= pra.PRICING_REQUEST_ID
	join libertypower..Utility u (nolock) on oa.UTILITY =u.UtilityCode
	join libertypower..account a (nolock) on anc.NewAccountNumber=a.AccountNumber and u.ID = a.UtilityID
	JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE 1=1 
	--U.MarketID NOT IN (1,2) -- excluding ca and tx
	AND pr.CREATION_DATE >= '01/01/2013'
	and AST.[Status] <> '905000'
	Except 
	select Utilitycode, OldAccountNumber, NewAccountNumber, MarketID  from #UnEnrolledAccounts
	
	insert into #UnEnrolledAccounts
	select distinct oa.utility, oa.ACCOUNT_NUMBER,oa.ACCOUNT_NUMBER,u.MarketID
	from offerenginedb..oe_account oa (nolock)
	left join #AccountNumberChanges anc (nolock) on oa.ACCOUNT_NUMBER=anc.OldAccountNumber and oa.UTILITY= anc.Utilitycode
	
	JOIN OfferEngineDB..OE_PRICING_REQUEST_ACCOUNTS pra (NOLOCK) on pra.OE_ACCOUNT_ID =oa.ID 
	JOIN OfferEngineDB..OE_PRICING_REQUEST pr (nolock) on pr.REQUEST_ID= pra.PRICING_REQUEST_ID
	
	
	join libertypower..Utility u (nolock) on oa.UTILITY =u.UtilityCode
	
	left join libertypower..account a (nolock) on anc.NewAccountNumber=a.AccountNumber and u.ID = a.UtilityID
	LEFT JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	LEFT JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE 1=1 
	--U.MarketID NOT IN (1,2) -- excluding ca and tx
	AND pr.CREATION_DATE >= '01/01/2013'
	and anc.OldAccountNumber is null
	and (a.AccountID is null or AST.[Status] <> '905000')
	except
	select Utilitycode, OldAccountNumber, NewAccountNumber, MarketID  from #UnEnrolledAccounts
	
	Create clustered index #UnEnrolledAccounts_cidx1 on #UnEnrolledAccounts (UtilityCode, OldAccountNumber, NewAccountNumber,MarketID) with fillfactor =100
	
	
--	select  * from lp_transactions..amerenaccount aa (nolock)
--	where aa.accountnumber in ('6134851378',
--'8234000944',
--'0794002328',
--'6827114897',
--'6827114897',
--'3183803536')
--order by aa.AccountNumber,EligibleSwitchDate
--	select 'AMEREN',aa.AccountNumber, EligibleSwitchDate, count(*)
--	from lp_transactions..amerenaccount aa with(nolock)
--	join
--	(
--		select aa.AccountNumber, aa.ServicePoint,max(Created) as NewestCreated from lp_transactions..AmerenAccount aa with (nolock)
--		join #UnEnrolledAccounts uea on uea.NewAccountNumber=aa.AccountNumber 
--		where aa.EffectivePLC >= 0 and uea.UtilityCode='AMEREN'
--		group by aa.AccountNumber, aa.ServicePoint
--	) aa1 on aa.AccountNumber = aa1.AccountNumber and aa.ServicePoint=aa1.ServicePoint and aa.Created=aa1.NewestCreated
--	group by aa.AccountNumber,EligibleSwitchDate
--	having count(*) >1
	
--	select 'AMEREN',aa.AccountNumber, count(*), EligibleSwitchDate
--	from lp_transactions..amerenaccount aa with(nolock)
--	join
--	(
--		select aa.AccountNumber, aa.ServicePoint,max(DATEADD(dd, 0, DATEDIFF(dd, 0, Created))) as NewestCreated from lp_transactions..AmerenAccount aa with (nolock)
--		join #UnEnrolledAccounts uea on uea.NewAccountNumber=aa.AccountNumber 
--		where aa.EffectivePLC >=0 and uea.UtilityCode='AMEREN'
--		group by aa.AccountNumber, aa.ServicePoint
--	) aa1 on aa.AccountNumber = aa1.AccountNumber and aa.ServicePoint=aa1.ServicePoint and DATEADD(dd, 0, DATEDIFF(dd, 0, aa.Created))=aa1.NewestCreated
--	group by aa.AccountNumber,EligibleSwitchDate
--	having count(*) >2
	
--	select * from lp_transactions..amerenaccount aa (nolock)
--	where aa.accountnumber = '8849842576'
	
	
--	insert into #LatestIcaps
--	select 'AMEREN',aa.AccountNumber, sum(EffectivePLC), EligibleSwitchDate
--	from lp_transactions..amerenaccount aa with(nolock)
--	join
--	(
--		select aa.AccountNumber, aa.ServicePoint,max(DATEADD(dd, 0, DATEDIFF(dd, 0, Created))) as NewestCreated from lp_transactions..AmerenAccount aa with (nolock)
--		join #UnEnrolledAccounts uea on uea.AccountNumber=aa.AccountNumber 
--		where aa.EffectivePLC >=0 and uea.UtilityCode='AMEREN'
--		group by aa.AccountNumber, aa.ServicePoint
--	) aa1 on aa.AccountNumber = aa1.AccountNumber and aa.ServicePoint=aa1.ServicePoint and DATEADD(dd, 0, DATEDIFF(dd, 0, aa.Created))=aa1.NewestCreated
--	group by aa.AccountNumber,EligibleSwitchDate
	
	
	
	insert into #LatestIcaps
	select distinct 'COMED',ca.AccountNumber, ca.CapacityPLC1Value,ca.CapacityPLC1StartDate
	from lp_transactions..comedaccount ca with (nolock)
	join 
	(
		select ca.AccountNumber, max(ca.Created) NewestCreated from lp_transactions..comedaccount ca  with (nolock)
		join #UnEnrolledAccounts uea on ca.AccountNumber=uea.newAccountNumber
		where uea.UtilityCode='COMED'and ca.CapacityPLC1Value >=0
		group by ca.AccountNumber
	)ca1 on ca1.AccountNumber=ca.AccountNumber and ca1.NewestCreated=ca.Created
	
	--future icap entries in comed
	insert into #LatestIcaps
	select distinct 'COMED',ca.AccountNumber, ca.CapacityPLC2Value,ca.CapacityPLC2StartDate
	from lp_transactions..comedaccount ca  with (nolock)
	join 
	(
		select ca.AccountNumber, max(ca.Created) NewestCreated from lp_transactions..comedaccount ca  with (nolock)
		join #UnEnrolledAccounts uea on ca.AccountNumber=uea.NewAccountNumber
		where uea.UtilityCode='COMED'and ca.CapacityPLC2Value >=0
		group by ca.AccountNumber
	)ca1 on ca1.AccountNumber=ca.AccountNumber and ca1.NewestCreated=ca.Created
	
	insert into #LatestTcaps
	select distinct 'COMED',ca.AccountNumber, ca.NetworkServicePLCValue,ca.NetworkServicePLCStartDate
	from lp_transactions..comedaccount ca  with (nolock)
	join 
	(
		select ca.AccountNumber, max(ca.Created) NewestCreated from lp_transactions..comedaccount ca  with (nolock)
		join #UnEnrolledAccounts uea on ca.AccountNumber=uea.NewAccountNumber
		where uea.UtilityCode='COMED'and ca.NetworkServicePLCValue >=0
		group by ca.AccountNumber
	)ca1 on ca1.AccountNumber=ca.AccountNumber and ca1.NewestCreated=ca.Created
	
	--order by ca.accountnumber,ca.Created
	insert into #LatestIcaps
	select 'CONED',cna.AccountNumber, cna.ICAP, cna.created
	from lp_transactions..ConedAccount cna  with (nolock)
	join (
		select cna.AccountNumber, max(cna.created) LatestCreated from lp_transactions..conedaccount cna  with (nolock)
		join #UnEnrolledAccounts uea on uea.NewAccountNumber=cna.AccountNumber 
		where uea.UtilityCode='CONED' and cna.ICAP >=0
		group by cna.AccountNumber
	) cna1 on cna1.AccountNumber = cna.AccountNumber and cna1.LatestCreated = cna.Created
	
	insert into #LatestIcaps
	select 'NYSEG',ny.AccountNumber, ny.Icap, ny.Created
	from lp_transactions..NysegAccount ny  with (nolock)
	join
	(
		select ny.AccountNumber, max(ny.Created) LatestCreated 
		from lp_transactions..NysegAccount ny  with (nolock)
		join #UnEnrolledAccounts uea on uea.NewAccountNumber = ny.AccountNumber
		where uea.UtilityCode='NYSEG' and ny.Icap >=0
		group by ny.AccountNumber
	) ny1 on ny1.LatestCreated=ny.Created and ny1.AccountNumber=ny.AccountNumber
	
	insert into #LatestIcaps
	select 'RGE',rge.AccountNumber, rge.Icap, rge.Created
	from lp_transactions..RgeAccount rge with (nolock)
	join
	(
		select rge.AccountNumber, max(rge.Created) LatestCreated 
		from lp_transactions..RgeAccount rge with (nolock) 
		join #UnEnrolledAccounts uea on uea.NewAccountNumber = rge.AccountNumber
		where uea.UtilityCode='RGE' and rge.Icap >=0
		group by rge.AccountNumber
	) rge1 on rge1.LatestCreated=rge.Created and rge1.AccountNumber=rge.AccountNumber
	
	insert into #LatestIcaps
	select 'BGE',bge.AccountNumber, bge.CapPLC, bge.Created
	from lp_transactions..BgeAccount bge with (nolock)
	join
	(
		select bge.AccountNumber, max(bge.Created) LatestCreated 
		from lp_transactions..BgeAccount bge with (nolock)
		join #UnEnrolledAccounts uea on uea.NewAccountNumber = bge.AccountNumber
		where uea.UtilityCode='BGE' and bge.CapPLC >=0
		group by bge.AccountNumber
	) bge1 on bge1.LatestCreated=bge.Created and bge1.AccountNumber=bge.AccountNumber
	
	insert into #LatestTcaps
	select 'BGE',bge.AccountNumber, bge.TransPLC, bge.Created
	from lp_transactions..BgeAccount bge with (nolock)
	join
	(
		select bge.AccountNumber, max(bge.Created) LatestCreated 
		from lp_transactions..BgeAccount bge with (nolock)
		join #UnEnrolledAccounts uea on uea.NewAccountNumber = bge.AccountNumber
		where uea.UtilityCode='BGE' and bge.TransPLC >=0
		group by bge.AccountNumber
	) bge1 on bge1.LatestCreated=bge.Created and bge1.AccountNumber=bge.AccountNumber
	
	insert into #latestIcaps
	select edi1.UtilityCode, edi1.AccountNumber, Case when edi1.UtilityCode='CMP' THEN edi.Icap *1000.0 else edi.Icap End, edi.TimeStampInsert 
	from lp_transactions..EdiAccount edi with (nolock)
	join 
	(
		select edi.UtilityCode,edi.AccountNumber,max(edi.TimeStampInsert) LastTimeStampInsert from lp_transactions..ediaccount edi with (nolock)
		join #UnEnrolledAccounts uea on uea.UtilityCode=edi.UtilityCode and uea.NewAccountNumber=edi.AccountNumber
		where edi.Icap >=0 and edi.UtilityCode not in ('COMED','AMEREN','CONED','RGE','RGE','NYSEG','NIMO','CENHUD','BANGOR') and uea.MarketID not in (1,2)
		group by edi.UtilityCode,edi.AccountNumber
	) edi1 on edi.AccountNumber = edi1.AccountNumber and edi.UtilityCode=edi1.UtilityCode and edi1.LastTimeStampInsert=edi.TimeStampInsert
	
	insert into #LatestIcaps
	select oa.UTILITY, oa.Account_number, oa.Icap, max(oo.DATE_CREATED)
	from OfferEngineDB..oe_account oa  with (nolock)
	join #UnEnrolledAccounts uea on  oa.UTILITY=uea.UtilityCode and oa.ACCOUNT_NUMBER=uea.NewAccountNumber
	join OfferEngineDB..OE_OFFER_ACCOUNTS ooa with (nolock) on ooa.OE_ACCOUNT_ID=oa.ID
	join offerenginedb..OE_OFFER oo with (nolock) on ooa.OFFER_ID=oo.offer_id
	where uea.UtilityCode in ('NIMO','CENHUD','BANGOR')  and ooa.ID is  not null and oa.Icap > =0
	group by oa.UTILITY,oa.Account_number,oa.ICAP
	order by UTILITY
	
	--start of common part
	
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
