USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]    Script Date: 08/19/2013 10:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]    Script Date: 08/19/2013 10:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetScrapedDataForMultipleMeterAmerenAccount]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --Get the accounts with multiple meters for Ameren





	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      


-- to get mutliple meter utilities

	if OBJECT_ID('tempdb..#GridResult') is not null
	drop table #GridResult

	if OBJECT_ID('tempdb..#EnrolledAccounts') is not null
	drop table #EnrolledAccounts

	if OBJECT_ID('tempdb..#MultipleMeterAmeren') is not null
		drop table #MultipleMeterAmeren
	
	--- temp table exists
	Create table #EnrolledAccounts (Utility varchar(50), AccountNumber VARCHAR(50))
	insert into #EnrolledAccounts

	SELECT oe.Account_Number,oe.UTILITY
	FROM OfferEngineDB..OE_ACCOUNT OE WITH (NOLOCK)
	INNER JOIN Libertypower..Utility U WITH (NOLOCK) ON OE.UTILITY = U.UtilityCode
	LEFT JOIN Libertypower..Account A WITH (NOLOCK) ON OE.ACCOUNT_NUMBER = A.AccountNumber AND A.UtilityID = U.ID
	LEFT JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
	LEFT JOIN Libertypower..AccountStatus AST WITH (NOLOCK) ON AC.AccountContractID = AST.AccountContractID
	WHERE AST.[Status] = '905000'

	Create clustered index #EnrolledAccounts_cidx1 on #EnrolledAccounts (UTILITY, ACCOUNTNUMBER) with fillfactor =100

	select 
		  oe.account_number as AccountNumber
	,     oe.market 
	,     oe.Utility as UtilityCode

	into #GridResult
	from offerenginedb..OE_Account oe with(nolock)
	left join #EnrolledAccounts a on oe.account_number=a.accountnumber and a.Utility = oe.Utility
	where a.accountnumber is null 
	group by  
	oe.account_number
	,oe.market 
	,oe.Utility

	Create clustered index #GridResult_cidx1 on #GridResult (UtilityCode, AccountNumber) with fillfactor =100
 

	select tmp1.accountnumber
	into #MultipleMeterAmeren
	from
	(
		select tmp.accountnumber, count(*) ct from 
		(
			select AccountNumber, isnull(MeterNumber,'NULL') as mn, count(*) as cnt 
			from lp_transactions..AmerenAccount with (nolock)
			group by AccountNumber, isnull(meternumber,'NULL')
		) tmp
		group by tmp.accountnumber 
		having count(*) >1
		and 
		(
		select count(distinct MeterNumber) from lp_transactions..AmerenAccount with (nolock)
		where MeterNumber is not null and  meternumber <> '' and accountnumber =tmp.accountnumber

		) > 1
	) tmp1
	 
	Create clustered index #MultipleMeterAmeren_cidx1 on #MultipleMeterAmeren (ACCOUNTNUMBER) with fillfactor =100
 
	select am.Id, am.AccountNumber, am.MeterNumber,am.ServicePoint, am.EffectivePLC, am.Created
	from lp_transactions..AmerenAccount am with (nolock)
	join #MultipleMeterAmeren sme on am.AccountNumber =sme.AccountNumber
	join #GridResult gr on sme.Accountnumber =gr.AccountNumber and gr.UtilityCode='Ameren'
	order by am.AccountNumber,am.Created
 
	SET NOCOUNT OFF
END

GO


