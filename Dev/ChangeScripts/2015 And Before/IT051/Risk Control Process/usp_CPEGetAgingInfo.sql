USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 11/04/2013
-- Description: Summary of aging information
-- =============================================
CREATE PROCEDURE usp_CPEGetAgingInfo
AS
BEGIN
	SET NOCOUNT ON;

	select 
		COUNT(*) as NumberOfAccounts, 
		DATEDIFF(DD, m.DateCreated, GETDATE()) as Aging,
		m.ProxiedLocation,
		m.ProxiedProfile,
		m.ProxiedUsage,
		i.IsDaily
	into #firstCounters
	from 
		MtMZainetAccountInfo i with (nolock) -- this table gets updated every morning before we start the Zainet process
		INNER JOIN MtMAccount m with (nolock) ON (i.AccountID=m.AccountID AND i.ContractID=m.ContractID)
	where 
		(ProxiedLocation <> 0
		or ProxiedProfile <> 0
		or ProxiedUsage <> 0)
		and m.Status = 'ETPd'
	group by
		DATEDIFF(DD, m.DateCreated, GETDATE()),
		m.ProxiedLocation,
		m.ProxiedProfile,
		i.IsDaily,
		m.ProxiedUsage
	order by 
		COUNT(*),
		DATEDIFF(DD, m.DateCreated, GETDATE())

	select * from (
		select 
			0 as AgingOrder,
			'Book 0' as Book, 
			'0-5 days' as Aging,
			isnull(sum(case when f.ProxiedLocation = 1 then NumberOfAccounts else null end), 0) as ProxiedLocation,
			isnull(sum(case when f.ProxiedProfile = 1 then NumberOfAccounts else null end), 0) as ProxiedProfile,
			isnull(sum(case when f.ProxiedUsage = 1 then NumberOfAccounts else null end), 0) as ProxiedUsage
		from
			#firstCounters f with (nolock)
		where
			f.IsDaily = 1
			and f.Aging < 6
		union
		select 
			1 as AgingOrder,
			'Book 0' as Book, 	 
			'6-10 days' as Aging,
			isnull(sum(case when f.ProxiedLocation = 1 then NumberOfAccounts else null end), 0) as ProxiedLocation,
			isnull(sum(case when f.ProxiedProfile = 1 then NumberOfAccounts else null end), 0) as ProxiedProfile,
			isnull(sum(case when f.ProxiedUsage = 1 then NumberOfAccounts else null end), 0) as ProxiedUsage
		from
			#firstCounters f with (nolock)
		where
			f.IsDaily = 1
			and f.Aging >= 6
			and f.Aging <= 10
		union
		select 
			3 as AgingOrder,
			'Book 0' as Book, 	 
			'>10 days' as Aging,
			isnull(sum(case when f.ProxiedLocation = 1 then NumberOfAccounts else null end), 0) as ProxiedLocation,
			isnull(sum(case when f.ProxiedProfile = 1 then NumberOfAccounts else null end), 0) as ProxiedProfile,
			isnull(sum(case when f.ProxiedUsage = 1 then NumberOfAccounts else null end), 0) as ProxiedUsage
		from
			#firstCounters f with (nolock)
		where
			f.IsDaily = 1
			and f.Aging > 10
		union
		select 
			0 as AgingOrder,
			'Book 1' as Book, 
			'0-5 days' as Aging,
			isnull(sum(case when f.ProxiedLocation = 1 then NumberOfAccounts else null end), 0) as ProxiedLocation,
			isnull(sum(case when f.ProxiedProfile = 1 then NumberOfAccounts else null end), 0) as ProxiedProfile,
			isnull(sum(case when f.ProxiedUsage = 1 then NumberOfAccounts else null end), 0) as ProxiedUsage
		from
			#firstCounters f with (nolock)
		where
			f.IsDaily = 0
			and f.Aging < 6
		union
		select 
			1 as AgingOrder,
			'Book 1' as Book, 
			'6-10 days' as Aging, 
			isnull(sum(case when f.ProxiedLocation = 1 then NumberOfAccounts else null end), 0) as ProxiedLocation,
			isnull(sum(case when f.ProxiedProfile = 1 then NumberOfAccounts else null end), 0) as ProxiedProfile,
			isnull(sum(case when f.ProxiedUsage = 1 then NumberOfAccounts else null end), 0) as ProxiedUsage
		from
			#firstCounters f with (nolock)
		where
			f.IsDaily =0
			and f.Aging >= 6
			and f.Aging <= 10
		union
		select 
			2 as AgingOrder,
			'Book 1' as Book, 	 
			'>10 days' as Aging,
			isnull(sum(case when f.ProxiedLocation = 1 then NumberOfAccounts else null end), 0) as ProxiedLocation,
			isnull(sum(case when f.ProxiedProfile = 1 then NumberOfAccounts else null end), 0) as ProxiedProfile,
			isnull(sum(case when f.ProxiedUsage = 1 then NumberOfAccounts else null end), 0) as ProxiedUsage
		from
			#firstCounters f with (nolock)
		where
			f.IsDaily = 0
			and f.Aging > 10
	) as AgingInfo		
	order by Book asc, AgingOrder asc

	drop table #firstCounters

	SET NOCOUNT OFF;
END 
GO