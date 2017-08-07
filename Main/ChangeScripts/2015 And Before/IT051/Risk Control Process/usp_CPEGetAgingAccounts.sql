USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 11/04/2013
-- Description:	Get the aging information of proxied accounts
-- =============================================
create procedure usp_CPEGetAgingAccounts
(
	@minAging as int,
	@maxAging as int,
	@isDaily as bit,
	@proxiedLocation as bit = null,
	@proxiedUsage as bit = null,
	@proxiedProfile as bit = null	
)
AS
BEGIN
	SET NOCOUNT ON;

	IF @proxiedProfile = 1
	BEGIN
		select 
			i.isDaily,
			i.AccountNumber,
			i.UtilityCode,
			i.ISO,
			i.StartDate,
			i.EndDate,
			m.ProxiedLocation,
			m.ProxiedProfile,
			m.ProxiedUsage,
			l.Value as ProxyValue,
			DATEDIFF(DD, m.DateCreated, GETDATE()) as ProxyAging
		from 
			MtMZainetAccountInfo i with (nolock) -- this table gets updated every morning before we start the Zainet process
			INNER JOIN MtMAccount m with (nolock) ON (i.AccountID=m.AccountID AND i.ContractID=m.ContractID)
			LEFT JOIN LibertyPower..PropertyInternalRef l with (nolock) ON (m.LoadProfileRefID = l.ID)
		where 
			ProxiedLocation = ISNULL(@proxiedLocation, ProxiedLocation)
			AND ProxiedProfile = ISNULL(@proxiedProfile, ProxiedProfile)
			AND ProxiedUsage = ISNULL(@proxiedUsage, ProxiedUsage)
			AND DATEDIFF(DD, m.DateCreated, GETDATE()) >= @minAging
			AND DATEDIFF(DD, m.DateCreated, GETDATE()) <= @maxAging
			AND IsDaily = @isDaily
			and m.Status = 'ETPd'
	END
	ELSE
		IF @proxiedLocation = 1
		BEGIN
			select 
				i.isDaily,
				i.AccountNumber,
				i.UtilityCode,
				i.ISO,
				i.StartDate,
				i.EndDate,
				m.ProxiedLocation,
				m.ProxiedProfile,
				m.ProxiedUsage,
				l.Value as ProxyValue,
				DATEDIFF(DD, m.DateCreated, GETDATE()) as ProxyAging
			from 
				MtMZainetAccountInfo i with (nolock) -- this table gets updated every morning before we start the Zainet process
				INNER JOIN MtMAccount m with (nolock) ON (i.AccountID=m.AccountID AND i.ContractID=m.ContractID)
				LEFT JOIN LibertyPower..PropertyInternalRef l with (nolock) ON (m.SettlementLocationRefID = l.ID)
			where 
				ProxiedLocation = ISNULL(@proxiedLocation, ProxiedLocation)
				AND ProxiedProfile = ISNULL(@proxiedProfile, ProxiedProfile)
				AND ProxiedUsage = ISNULL(@proxiedUsage, ProxiedUsage)
				AND DATEDIFF(DD, m.DateCreated, GETDATE()) >= @minAging
				AND DATEDIFF(DD, m.DateCreated, GETDATE()) <= @maxAging
				AND IsDaily = @isDaily
				and m.Status = 'ETPd'
		END
		ELSE
			select 
				i.isDaily,
				i.AccountNumber,
				i.UtilityCode,
				i.ISO,
				i.StartDate,
				i.EndDate,
				m.ProxiedLocation,
				m.ProxiedProfile,
				m.ProxiedUsage,
				null as ProxyValue,
				DATEDIFF(DD, m.DateCreated, GETDATE()) as ProxyAging
			from 
				MtMZainetAccountInfo i with (nolock) -- this table gets updated every morning before we start the Zainet process
				INNER JOIN MtMAccount m with (nolock) ON (i.AccountID=m.AccountID AND i.ContractID=m.ContractID)
			where 
				ProxiedLocation = ISNULL(@proxiedLocation, ProxiedLocation)
				AND ProxiedProfile = ISNULL(@proxiedProfile, ProxiedProfile)
				AND ProxiedUsage = ISNULL(@proxiedUsage, ProxiedUsage)
				AND DATEDIFF(DD, m.DateCreated, GETDATE()) >= @minAging
				AND DATEDIFF(DD, m.DateCreated, GETDATE()) <= @maxAging
				AND IsDaily = @isDaily
				and m.Status = 'ETPd'

	SET NOCOUNT OFF;
END