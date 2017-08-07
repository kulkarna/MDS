USE lp_MtM
GO

-- Attrition
UPDATE	a
SET		a.SettlementLocationRefId = p.ID
FROM	MtMAttrition a
Inner	Join Properties p
on		a.Zone = p.ZainetValue

select	Distinct FileLogID, Zone
from	MtMAttrition
where	SettlementLocationRefID IS NULL

select	*
from	MtMZainetZones
where	ZainetZone in ('CIPI','MISO')

DELETE	MtMAttrition
WHERE	SettlementLocationRefID IS NULL
AND		Zone in ('CIPI','MISO')

--Intraday
UPDATE	a
SET		a.SettlementLocationRefId = p.ID
FROM	MtMIntraday a
Inner	Join Properties p
on		a.Zone = p.ZainetValue

select	Distinct FileLogID, Zone
from	MtMIntraday
where	SettlementLocationRefID IS NULL

-- Shaping
UPDATE	a
SET		a.SettlementLocationRefId = p.ID
FROM	MtMShaping a
Inner	Join Properties p
on		a.Zone = p.ZainetValue

select	Distinct FileLogID, Zone
from	MtMShaping
where	SettlementLocationRefID IS NULL

--Supplier Premiums
select distinct filelogid from MtMSupplierPremiums order by FileLogID

UPDATE	a
SET		a.SettlementLocationRefId = p.ID
FROM	MtMSupplierPremiums a
Inner	Join Properties p
on		a.Zone = p.ZainetValue
WHERE	a.SettlementLocationRefId IS NULL
--AND		a.FileLogID < 350 --350,355,359,376,530

select	Distinct FileLogID, Zone
from	MtMSupplierPremiums
where	SettlementLocationRefID IS NULL

select	*
from	MtMZainetZones
where	ZainetZone in ('CIPI','AMIL')

DELETE	MtMSupplierPremiums
WHERE	SettlementLocationRefID IS NULL
AND		Zone in ('CIPI','AMIL')

--Energy Curves
DECLARE	@FileLogID INT
DECLARE CursorFILE CURSOR FAST_FORWARD
FOR
select	distinct filelogid 
from	MtMEnergyCurvesMostRecentEffectiveDate 
order	by FileLogID

OPEN	CursorFILE
FETCH	NEXT FROM CursorFILE
INTO	@FileLogID
	
WHILE @@FETCH_STATUS = 0
BEGIN	
	UPDATE	a
	SET		a.SettlementLocationRefId = p.ID
	FROM	MtMEnergyCurves a
	Inner	Join Properties p
	on		a.Zone = p.ZainetValue
	WHERE	a.SettlementLocationRefId IS NULL
	AND		a.FileLogID = @FileLogID

	FETCH	NEXT FROM CursorFILE
	INTO	@FileLogID
END

CLOSE	CursorFILE
DEALLOCATE CursorFILE

GO

select	Distinct FileLogID, Zone
from	MtMEnergyCurves
where	SettlementLocationRefID IS NULL

select	*
from	MtMZainetZones
where	ZainetZone in ('CIPI','MISO')

DELETE	MtMEnergyCurves
WHERE	SettlementLocationRefID IS NULL
AND		Zone in ('CIPI','MISO')