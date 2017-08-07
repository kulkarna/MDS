USe Libertypower
GO 

SELECT * 
INTO #ProfileLookUp
FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.ProfileLookup


-- update existing defaults 
-- ===========================================
Update u set DefaultProfileRefID = pir.ID
-- SELECT * 
FROM LibertyPower..Utility u
	JOIN #ProfileLookUp p on u.UtilityCode = p.UtilityID and p.ListType = 'UD' 
	JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) on p.ProfileID = pir.Value and pir.propertyId = 2
WHERE u.DefaultProfileRefID is null 
