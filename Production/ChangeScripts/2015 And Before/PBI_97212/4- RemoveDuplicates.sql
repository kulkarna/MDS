USE LIBERTYPOWER
GO

IF OBJECT_ID('tempdb..#Dupes') IS NOT NULL  
begin
drop table #Dupes
end


SELECT	AccountNumber, UtilityCode, FromDAte, TODate, TotalKWH, COUNT(distinct MeterNumbeR) as CountMeters, MAX(ID) AS ID, MIN(MeterNumber) as MinM, MAX(MeterNumber) as MaxM
INTO	#Dupes
FRom	UsageConsolidated u (nolock)
Where	Active = 1
Group	by AccountNumber, UtilityCode, FromDAte, TODate, TotalKWH
Having	COUNT(distinct MeterNumbeR) > 1

--SELECT	SUM(totalKWH)*0.001
--FROM	#Dupes

--select	*
--from	#Dupes

--order	by MinM desc

DELETE	U
FRom	UsageConsolidated U (nolock)
INNER	JOIN #Dupes D
ON		U.AccountNumber = D.AccountNumber
AND		U.UtilityCode=D.UtilityCode
AND		U.FromDAte=D.FromDAte
AND		U.TODate=D.TODate
--AND		U.TotalKWH=D.TotalKWH
Where	U.Active = 0
AND		U.ID < D.ID

Update	U
SET		U.Active = 0
FRom	UsageConsolidated U (nolock)
INNER	JOIN #Dupes D
ON		U.AccountNumber = D.AccountNumber
AND		U.UtilityCode=D.UtilityCode
AND		U.FromDAte=D.FromDAte
AND		U.TODate=D.TODate
AND		U.TotalKWH=D.TotalKWH
Where	U.Active = 1
AND		U.ID < D.ID
