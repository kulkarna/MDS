CREATE PROC usp_AccountAccountInfoFieldRequired_GetAsGrid
AS
BEGIN

CREATE TABLE #Data 
(
UtilityCode NVARCHAR(255),
NameUserFriendly NVARCHAR(255),
IsRequired INT
)

DECLARE @List NVARCHAR(2000)
SET @List = [Lp_UtilityManagement].[dbo].[GetAccountFieldInfoUserFriendlyNames] ()
DECLARE @Zero INT
SET @Zero = 0

INSERT INTO #Data
select
	uc.UtilityCode, 
	aif.NameUserFriendly, 
	CAST(ISNULL(aifr.IsRequired,0) AS INT) IsRequired
from
	dbo.UtilityCompany (nolock) uc
	left outer join dbo.AccountInfoFieldRequired (nolock) aifr
		on aifr.UtilityCompanyId = uc.id
	left outer join dbo.AccountInfoField (nolock) aif
		on aifr.AccountInfoFieldId = aif.id or aifr.AccountInfoFieldId = null
order by
	uc.UtilityCode
	
SELECT 
	UtilityCode, 
	Grid, 
	[I-Cap], 
	[Lbmp Zone], 
	[Load Profile],
	[Meter Owner],
	[Meter Type],
	[Rate Class],
	[Tariff Code],
	[T-Cap],
	[Voltage],
	[Zone]
FROM #Data
PIVOT
	( 
	SUM(IsRequired)
	FOR NameUserFriendly IN ([Grid],[I-Cap],[Lbmp Zone],[Load Profile],[Meter Owner],[Meter Type],[Rate Class],[Tariff Code],[T-Cap],[Voltage],[Zone])
)
AS P

END

--exec usp_AccountAccountInfoFieldRequired_GetAsGrid
