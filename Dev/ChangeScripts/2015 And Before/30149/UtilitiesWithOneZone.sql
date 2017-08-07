USE Libertypower
GO

-- Get the Utilities with one zone
Select	z.utility_id, u.ID as UtilityID, max(zone) as zone, COUNT(*) as CT
into	#Single_Zone_Utility
from	lp_common..zone z (nolock)
join	libertypower..utility u (nolock)
on		z.utility_id = u.UtilityCode
group	by z.utility_id, u.ID
having	count(*) = 1

--Check the number of accounts to update
select	a.*, u.zone
FROM	LibertyPower..Account a (nolock)
JOIN	#Single_Zone_Utility u on a.UtilityID = u.UtilityID
WHERE	a.Zone <> u.Zone 

-- Make sure all the zones has a location ID reference
SELECT	z.*, p.ID as DeliveryLocationRefID
INTO	#Zones
FROM	#Single_Zone_Utility z
Inner	Join PropertyInternalRef p (nolock)
ON		utility_id + '-' + z.zone = p.Value

--Update the Account table
UPDATE	a
SET		Zone = u.Zone,
		DeliveryLocationRefID = u.DeliveryLocationRefID
FROM	LibertyPower..Account a
JOIN	#Zones u on a.UtilityID = u.UtilityID
WHERE	a.Zone <> u.Zone 


-- HardCode AMEREN Zones to AMIL
SELECT	AccountID 
INTO	#A
FROM	Account a (nolock)
WHERE	a.UtilityID = 11 -- AMEREN
AND		a.Zone <> 'AMIL'

UPDATE	a
SET		a.ZONE = 'AMIL',
		a.DeliveryLocationRefID = 9,
		a.Modified = GETDATE ()
FROM	Account a
Inner	Join #A z
ON		a.AccountID = z.AccountID

		