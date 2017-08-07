-- NOTE !!!! some queries depend on importing spreadsheets 
-- ==================================================================
USE LibertyPower
GO 

-- //////   Load internal Location List 
-- ======================================

	-- ================================================================================================
	-- Step 1
	-- Get Distinct Enrollment Zone from Util_ID_Zone -- This is Master List / Map Everything else to this
	-- ================================================================================================
	-- FROM Pricing UTIL_Zone_map  --- dependent on importing risk mapping!!!
	-- =============================
	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])
	SELECT distinct t.EnrollmentZone, 0 , GETDATE() , 0 , 1 ,1 
	FROM LibertyPower.._tmp_UtilIDZone  t (NOLOCK) 
		LEFT JOIN [LibertyPower].[dbo].[PropertyInternalRef] pir (NOLOCK) ON pir.Value = t.EnrollmentZone  
			AND pir.propertyid = 1 
	WHERE pir.ID is null 
		AND ltrim(ISNULL(t.EnrollmentZone, '')) <> ''
		
	-- ===========================================================================================	
	-- Step 2
	-- Add Missing Enrollment Name to Master List 
	-- ===========================================================================================
	-- FROM Pricing Code map --- dependent on importing risk mapping!!!
	-- ==============================
	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])
	           
	SELECT distinct rm.ENROLLMENT_STD, 0 , GETDATE() , 0 , 1 , ISNULL(pt.ID,1) 
	FROM LibertyPower.._tmp_RiskCodeMap  rm (NOLOCK) 
		LEFT JOIN Libertypower..PropertyInternalRef pir (NOLOCK)on rm.ENROLLMENT_STD = pir.Value
		LEFT JOIN LIbertyPower..PropertyType pt (NOLOCK) on  CHARINDEX (pt.name , rm.Location_TYPE ) > 0 
	WHERE pir.ID is null 
		AND ltrim(ISNULL(rm.ENROLLMENT_STD, '')) <> ''
		
			
/**** Get the zones from the Missing Zones tables ****/
SELECT * 
INTO #MissingZones
FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.MissingZones

GO

INSERT INTO [PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])
SELECT	distinct m.UtilityCode + '-' + m.InternalValue, 0 , GETDATE() , 0 , 1 ,1 
FROM	#MissingZones  m (NOLOCK) 
LEFT	JOIN [PropertyInternalRef] pir (NOLOCK) ON pir.Value = UtilityCode + '-' + m.InternalValue
AND		pir.propertyid = 1 
WHERE	pir.ID is null 

/***************************************************************/
-- Ignores Zones found in lp_common..common_zone 
-- Ignores Zones found in lp_mtm.dbo.MtMRetailOfficeZoneMapping
-- Ignores zones found in lp_mtm.dbo.MtMZainetZones		
