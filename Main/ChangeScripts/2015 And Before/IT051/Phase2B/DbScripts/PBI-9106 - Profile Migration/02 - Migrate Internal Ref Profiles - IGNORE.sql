USE LibertyPower
GO 

	SELECT * 
	INTO #CalMap
	FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.MtMRetailOfficeCalendarMapping
	--Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9
	-- 'Data Source=LPCNOCSQL9\TRANSACTIONS;Integrated Security=SSPI'

update #CalMap 
SET		CalendarName = UtilityID + '-'+ CalendarName

-- profiles from lp_mtm..MtMRetailOfficeCalendarMapping
-- ============================================================
		-- 'O&R - First 5 Chars' , '' ) ,
		--('CONED' - ConEd SC + rateClass + , + StratumStart + , + StartumEnd
		--('NYSEG -  0 + [LoadProfile]' , '' ) ,
		--('NIMO -  NMP-E_ + [LoadProfile] + _06_CALENDAR' , '' ) ,
		--('PEPCO -  PEPCO MDND' , '' ) , -- if profile is an interger
		--('PEPCO -  PEPCO MMGTL2' , '' ) , -- if profile is MMGTL2A or MMGTL2B
		--('PEPCO -  PEPCO + [LoadProfile]' , '' ) , 
		
		
	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])

	SELECT DISTINCT mro.CalendarName	, 0 , GETDATE() , 0 , 2 , 0		
	--case when u.WholeSaleMktID = 'ERCOT' then mro.ProfileRateClass 
	--		else  LTRIM( replace ( replace (  u.UtilityCode , '&', '') , '-', '')) + '_' + ltrim(rtrim(mro.ProfileRateClass))
	--		end 
	
	FROM #CalMap mro -- lp_mtm..MtMRetailOfficeCalendarMapping mro (nolock)
		LEFT JOIN LibertyPower..Utility u 
			ON case when mro.UtilityID = 'ALLEGHENY' then 'ALLEGMD' 
					when mro.UtilityID = 'CLP' then 'CL&P'
			   else mro.UtilityID 
			   end = u.UtilityCode -- valid utilities 
		
		LEFT JOIN LibertyPower..PropertyInternalRef PIR 
			ON pir.Value = mro.CalendarName
			 --case when u.WholeSaleMktID = 'ERCOT' then mro.ProfileRateClass 
				--		   else  LTRIM( replace ( replace (  u.UtilityCode , '&', '') , '-', '')) + '_' + ltrim(rtrim(mro.ProfileRateClass))
				--		   end 
				AND pir.propertyId = 2	
			
	WHERE Determinant <> 'RateClass' -- rate code is used instead of load profile when determinant = RateClass ???? 
		AND ltrim(ISNULL(mro.CalendarName, '')) <> ''
		AND pir.ID is null 



-- CONED Profiles => "ConEd SC" + RateClass + "," + Stratum Range Start + Statum Range End
-- =========================================================================

	-- copy stratum range into temp table to avoid scientific notation
	CREATE TABLE #CopyRange ( ServiceRateClass varchar(max) , StratumStart varchar(max) , StratumEnd varchar(max) ) 
	INSERT INTO #CopyRange
	SELECT ServiceRateClass ,  convert ( decimal(24,0), StratumStart ) , convert ( decimal(24,0), StratumEnd ) 
	FROM LibertyPower..UtilityStratumRange 
	
	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])
			   
	SELECT DISTINCT ltrim(rtrim(ust.ServiceRateClass)) + '-' +  ltrim(rtrim(ust.StratumEnd)) --'ConEd SC' + ltrim(rtrim(ust.ServiceRateClass)) + ',' +  ltrim(rtrim(ust.StratumStart)) + ',' + ltrim(rtrim(ust.StratumEnd)) 
			, 0 , GETDATE() , 0 , 2 , 0		
	
	FROM  #CopyRange ust 
		LEFT JOIN LibertyPower..PropertyInternalRef PIR 
			ON pir.Value = ltrim(rtrim(ust.ServiceRateClass)) + '-' +  ltrim(rtrim(ust.StratumEnd))  --'ConEd SC' + ltrim(rtrim(ust.ServiceRateClass)) + ',' +  ltrim(rtrim(ust.StratumStart)) + ',' + ltrim(rtrim(ust.StratumEnd)) 
				AND pir.propertyId = 2				
		
	WHERE pir.ID is null 


-- NYSEG Profiles = >  0 + [LoadProfile]' 
-- =========================================================================

	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])
			   
	SELECT DISTINCT  '0' + a.LoadProfile , 0 , GETDATE() , 0 , 2 , 0		
	FROM LibertyPower..Account a 
		JOIN LibertyPower..Utility u 
			ON a.UtilityID = u.id

		LEFT JOIN LibertyPower..PropertyInternalRef PIR 
			ON pir.Value = '0' + a.LoadProfile
				AND pir.propertyId = 2	
	WHERE pir.ID is NULL 
		AND u.UtilityCode = 'NYSEG'
		AND ltrim(isnull(a.LoadProfile , '')) <> ''
		


-- NIMO Profiles = >  ('NIMO -  NMP-E_ + [LoadProfile] + _06_CALENDAR' , '' ) 
-- =========================================================================

	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])
			   
	SELECT DISTINCT  'NMP-E_' + a.LoadProfile + '_06_CALENDAR', 0 , GETDATE() , 0 , 2 , 0		
	FROM LibertyPower..Account a 
		JOIN LibertyPower..Utility u 
			ON a.UtilityID = u.id

		LEFT JOIN LibertyPower..PropertyInternalRef PIR 
			ON pir.Value = 'NMP-E_' + a.LoadProfile + '_06_CALENDAR'
				AND pir.propertyId = 2	
	WHERE pir.ID is NULL 
		AND u.UtilityCode = 'NIMO'
		AND ltrim(isnull(a.LoadProfile , '')) <> ''
				
		
		
-- PEPCO Profiles = >  
	--('PEPCO -  PEPCO MDND' , '' ) , -- if profile is an interger
	--('PEPCO -  PEPCO MMGTL2' , '' ) , -- if profile is MMGTL2A or MMGTL2B
	--('PEPCO -  PEPCO + [LoadProfile]' , '' ) , 
-- =========================================================================

	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])
			   
	SELECT DISTINCT case when ISNUMERIC (a.LoadProfile) = 1 then 'PEPCO MDND'
						 when a.LoadProfile = 'MMGTL2A' OR a.LoadProfile = 'MMGTL2B'  then 'PEPCO MMGTL2' 
						 else 'PEPCO ' + a.LoadProfile
					end 
					, 0 , GETDATE() , 0 , 2 , 0		
	FROM LibertyPower..Account a 
		JOIN LibertyPower..Utility u 
			ON a.UtilityID = u.id

		LEFT JOIN LibertyPower..PropertyInternalRef PIR 
			ON pir.Value = case when ISNUMERIC (a.LoadProfile) = 1 then 'PEPCO MDND'
						 when a.LoadProfile = 'MMGTL2A' OR a.LoadProfile = 'MMGTL2B'  then 'PEPCO MMGTL2' 
						 else 'PEPCO ' + a.LoadProfile
						end 
				AND pir.propertyId = 2	
	WHERE pir.ID is NULL 
		AND u.UtilityCode like 'PEPCO%'
		AND ltrim(isnull(a.LoadProfile , '')) <> ''
				