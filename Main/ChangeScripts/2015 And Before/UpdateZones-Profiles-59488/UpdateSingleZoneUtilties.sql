USE Libertypower
GO

-- Get all the Utilities with a single Zone
select z.utility_id, u.ID as UtilityID, u.UtilityCode, max(zone) as zone
into #Single_Zone_Utility
from lp_common..zone z
join libertypower..utility u on z.utility_id = u.UtilityCode
group by z.utility_id, u.ID, u.UtilityCode
having count(*) = 1

-- Update the accounts with a single zone utility
UPDATE a
SET		a.Zone = u.Zone,
		a.DeliveryLocationRefID = p.ID,
		a.Modified = GETDATE()
--SELECT	distinct a.*
FROM	LibertyPower..Account a
JOIN	#Single_Zone_Utility u 
on		a.UtilityID = u.UtilityID
INNER	Join Libertypower..PropertyInternalRef p  (nolock)
on		p.PropertyID = 1
AND		p.Value = u.UtilityCode + '-' + u.Zone
WHERE	(a.Zone = '' or A.Zone is null)
and		a.DeliveryLocationRefID = 0