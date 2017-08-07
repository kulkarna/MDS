Select	*
from	MtMReportZkey
order by ZkeyID


Select	*
from	MtMReportZkeyDetail

Select	*
from	Zkey

truncate table MtMReportZkeyDetail
truncate table MtMReportZkey


Select	*
from	Zkey

Select	*
from	Zkey z
Inner	Join MtMReportCounterParty p
On		z.CounterParty = p.CounterPartyID

UPDATE	z
SET		z.CounterParty = p.CounterPartyID
From	Zkey z
Inner	Join MtMReportCounterParty p
On		z.CounterParty = p.CounterParty


INSERT	INTO MtMReportZkey
SELECT	DISTINCT 
		ISO, Zone, YEAR, GETDATE(), 'cghazal',null,null
FROM	Zkey



INSERT	INTO MtMReportZkeyDetail
SELECT	rz.ZkeyID, z.CounterParty, z.Zkey, GETDATE(), 'cghazal', null, null
FROM	Zkey z
Inner	Join MtMReportZkey rz
ON		z.ISO = rz.ISO
AND		z.ZOne = rz.Zone
AND		z.Year = rz.Year