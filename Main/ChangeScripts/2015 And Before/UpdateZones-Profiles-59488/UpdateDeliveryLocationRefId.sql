USE Libertypower
GO

--2851 internal ref
SELECT	distinct a.*, p.ID, p.Value
INTO	#Internal
FROM	Libertypower..Account a (nolock)
Inner	Join Libertypower..Utility u (nolock)
on		a.UtilityId = u.ID
INNER	Join Libertypower..PropertyInternalRef p  (nolock)
on		p.PropertyID = 1
AND		p.Value = u.UtilityCode + '-' + a.Zone
where	a.DeliveryLocationRefId = 0
AND		a.Zone <> ''

UPDATE	a
SET		a.DeliveryLocationRefId = i.ID,
		a.Modified = GETDATE()
FROM	Libertypower..Account a 
INNER	Join #Internal i
ON		i.AccountID = a.AccountID

-- external Ref
SELECT	distinct a.*, pir.ID
Into	#External
from	Libertypower..Account a (nolock)
Inner	Join Libertypower..Utility u (NOLOCK) 
ON		a.UtilityID = u.ID
Inner	Join Libertypower..WholesaleMarket w (NOLOCK) 
ON		u.WholesaleMktId = w.WholesaleMktID
INNER	JOIN LibertyPower..ExternalEntityValue eev (NOLOCK) 
ON		eev.ExternalEntityID = w.ID
INNER	JOIN LibertyPower..PropertyValue pv (NOLOCK) 
ON		eev.PropertyValueID = pv.ID
AND		pv.Value = a.Zone
INNER	Join LibertyPower..PropertyInternalRef pir (NOLOCK) 
ON		pir.ID = pv.InternalRefID
AND		pir.Value like u.UtilityCode + '-%'
AND		pir.PropertyId = 1
where	a.DeliveryLocationRefId = 0
AND		a.Zone <> ''

UPDATE	a
SET		a.DeliveryLocationRefId = i.ID,
		a.Modified = GETDATE()
FROM	Libertypower..Account a 
INNER	Join #External i
ON		i.AccountID = a.AccountID