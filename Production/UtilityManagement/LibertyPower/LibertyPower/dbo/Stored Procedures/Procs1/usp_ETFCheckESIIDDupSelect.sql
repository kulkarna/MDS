





-- =============================================
-- Created: Alejandro Iturbe 7/30/2012
-- Checks for Utility AccountNumbers accross multiple Utilities
-- 
-- =============================================

CREATE PROCEDURE [dbo].[usp_ETFCheckESIIDDupSelect]
	@utilityAccountNumber varchar(250)
AS
BEGIN

	select
	ac.AccountNumber,
	ac.AccountIdLegacy,
	ac.UtilityID,
	u.DunsNumber,
	u.InactiveInd,
	dup.Utilities,
	case 
	when dup.Utilities = 1 and InactiveInd = 1 then 'Inactive Utility'
	when dup.Utilities > 1 then 'Duplicate Account accross multiple Utilities'
	else 'No Error'
	end as ErrorDesc
	from libertypower..account (nolock) ac
	join
	(
		select
		ac.AccountNumber,
		count(distinct ac.UtilityID) as Utilities
		from libertypower..account (nolock) ac
		join libertypower..utility (nolock) u on ac.UtilityId = u.Id
		--where u.InactiveInd = 0
		group by ac.AccountNumber
	) dup on ac.AccountNumber = dup.AccountNumber
	
	join libertypower..utility (nolock) u on ac.UtilityId = u.Id --and u.InactiveInd = 0	
	
	where ac.AccountNumber in (@utilityAccountNumber)

END




