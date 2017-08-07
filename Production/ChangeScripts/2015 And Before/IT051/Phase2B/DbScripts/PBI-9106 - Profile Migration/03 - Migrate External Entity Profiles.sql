USE LibertyPower
GO 

-- ////// Retail Office Profile List 
-- =======================================

		-- 'O&R - First 5 Chars' , '' ) ,
		--('CONED' - ConEd SC + rateClass + , + StratumStart + , + StartumEnd
		--('NYSEG -  0 + [LoadProfile]' , '' ) ,
		--('NIMO -  NMP-E_ + [LoadProfile] + _06_CALENDAR' , '' ) ,
		--('PEPCO -  PEPCO MDND' , '' ) , -- if profile is an interger
		--('PEPCO -  PEPCO MMGTL2' , '' ) , -- if profile is MMGTL2A or MMGTL2B
		--('PEPCO -  PEPCO + [LoadProfile]' , '' ) , 

	SELECT * 
	INTO #CalMap
	FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.MtMRetailOfficeCalendarMapping
	--Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9
	-- 'Data Source=LPCNOCSQL9\TRANSACTIONS;Integrated Security=SSPI'

	SELECT * 
	INTO #ProfileLookUp
	FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.ProfileLookUp
	--Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9
	-- 'Data Source=LPCNOCSQL9\TRANSACTIONS;Integrated Security=SSPI'

	-- FRom the profileLookup, for each Ercot entry, add all the ERCOT utilities
	insert into 	#ProfileLookUp
	select	p.ID, 'U' as ListType, u.UtilityCode as UtilityId, ISO, ProfileId, null, EffectiveDAte, Created, CreatedBy, Null, Null
	from	#ProfileLookUp p
	inner	join Libertypower..Utility u (NOLOCK)
	on		p.ISO = u.WholeSaleMktID
	Where	p.ListType = 'I'

	--remove the records with list type I and ID as those are already covered by list type U
	delete	#ProfileLookUp where	ListType in ('I','ID')

	--remove the records with list type UD, only those that are covered by list type U
	select * into #1 from #ProfileLookUp where ListType = 'UD'

	delete t from #1 t 
	inner	join #ProfileLookUp p 
	on		t.ProfileId = p.ProfileId 
	and		t.UtilityId = p.UtilityId 
	where	p.ListType = 'U' 

	delete	#ProfileLookUp where ListType in ('UD') AND ID NOT in (SELECT ID FROM #1)
	drop	TABLE #1
			
	--DECLARE @propertyValueID int 
	--DECLARE @propertyInternalRef int 
	--DECLARE @ExtValue varchar (50) 
	--DECLARE @ExtEntityID int 
	DECLARE @PropertyID int 
	DECLARE @PropertyTypeID int 
	--DECLARE @IntValue varchar (50) 
	
	SET @PropertyID = 2 -- Profiles !!!!
	SET @PropertyTypeID = null 

	--DROP TABLE #ExtEntity_Values
	CREATE Table #ExtEntity_Values ( ExtEntityID int , ExtValue varchar(100), IntRefValue varchar(100), RoValue varchar(100) ) 
	
-- /// Get Utility Values from 	MtMRetailOfficeCalendarMapping
-- ======================================================================
	INSERT INTO #ExtEntity_Values ( ExtEntityID  , ExtValue , IntRefValue, RoValue ) 
	
	SELECT DISTINCT 
		ExtEntityID = ee.ID ,   
		ExtValue = mro.ProfileRateClass , 
		IntRefValue = mro.UtilityId + '-'+ mro.ProfileRateClass, --mro.CalendarNameInternal
		RoValue = mro.CalendarName
	FROM #CalMap mro --  lp_mtm..MtMRetailOfficeCalendarMapping mro (nolock)

		INNER JOIN LibertyPower..Utility u (NOLOCK) 
			ON case when mro.UtilityID = 'ALLEGHENY' then 'ALLEGMD' 
					when mro.UtilityID = 'CLP' then 'CL&P'
				else mro.UtilityID end = u.UtilityCode -- valid utilities 
		
		INNER JOIN LibertyPower..ExternalEntity ee (NOLOCK) 
			ON ee.EntityKey = u.ID
			AND ee.EntityTypeID = 2
			
	WHERE Determinant <> 'RateClass' -- rate code is used instead of load profile when determinant = RateClass ???? 			
		AND u.ID <> 18 -- CONED 

-- /// Get Utility Values from Profile LookUp
-- =====================================================================
	INSERT INTO #ExtEntity_Values ( ExtEntityID  , ExtValue , IntRefValue, RoValue ) 
		
	SELECT DISTINCT 
		ExtEntityID = ee.ID ,     
		ExtValue = pl.ProfileID , 
		IntRefValue = pl.UtilityID + '-' + pl.ProfileID,
		RoValue = case when u.UtilityCode = 'NYSEG' then '0' + pl.ProfileID
						   when u.UtilityCode = 'NIMO' then 'NMP-E_' + pl.ProfileID + '_06_CALENDAR'
						   when u.UtilityCode like 'PEPCO%' and ISNUMERIC (pl.ProfileID) = 1 then 'PEPCO MDND'
						   when u.UtilityCode like 'PEPCO%' and (pl.ProfileID = 'MMGTL2A' OR pl.ProfileID = 'MMGTL2B')  then 'PEPCO MMGTL2' 
						   when u.UtilityCode like 'PEPCO%' then 'PEPCO ' + pl.ProfileID 
						   when u.UtilityCode like 'O&R%' then Substring(pl.ProfileID , 0 , 5 ) 
						   when u.WholeSaleMktID = 'ERCOT' then pl.ProfileID
					  else  pl.ProfileID --LTRIM(replace(replace(u.UtilityCode , '&', '') , '-', '')) + '_' + ltrim(rtrim(pl.ProfileID))
					  end 

	FROM #ProfileLookUp pl --  lp_mtm..ProfileLookup pl (nolock)

		INNER JOIN LibertyPower..Utility u (NOLOCK) 
			ON case when pl.UtilityID = 'ALLEGHENY' then 'ALLEGMD' 
					when pl.UtilityID = 'CLP' then 'CL&P'
				else pl.UtilityID end = u.UtilityCode -- valid utilities 
	
		INNER JOIN LibertyPower..ExternalEntity ee (NOLOCK) 
			ON ee.EntityKey = u.ID
			AND ee.EntityTypeID = 2

		LEFT JOIN #CalMap mroc --  lp_mtm..MtMRetailOfficeCalendarMapping mroc (nolock)
			ON mroc.ProfileRateClass = pl.ProfileID
				AND pl.UtilityID = mroc.UtilityID
						
	WHERE u.ID <> 18 -- CONED 
		AND mroc.ID is null 
				
-- /// Get RO Values from 	MtMRetailOfficeCalendarMapping
-- ======================================================================
	INSERT INTO #ExtEntity_Values ( ExtEntityID  , ExtValue , IntRefValue ) 
	
	SELECT DISTINCT 
		ExtEntityID = 8 ,   
		ExtValue = RoValue,
					/*case when ltrim(rtrim(isnull(mroc.CalendarName, ''))) <> '' then mroc.CalendarName
		
						   when u.UtilityCode = 'NYSEG' then '0' + mroc.ProfileRateClass
						   when u.UtilityCode = 'NIMO' then 'NMP-E_' +  mroc.ProfileRateClass + '_06_CALENDAR'
						   when u.UtilityCode like 'PEPCO%' and ISNUMERIC ( mroc.ProfileRateClass) = 1 then 'PEPCO MDND'
						   when u.UtilityCode like 'PEPCO%' and ( mroc.ProfileRateClass = 'MMGTL2A' OR  mroc.ProfileRateClass = 'MMGTL2B')  then 'PEPCO MMGTL2' 
						   when u.UtilityCode like 'PEPCO%' then 'PEPCO ' +  mroc.ProfileRateClass 
						   when u.UtilityCode like 'O&R%' then Substring( mroc.ProfileRateClass , 0 , 5 ) 
						   when u.WholeSaleMktID = 'ERCOT' then pl.ProfileID
						 else ''
					  end */
		IntRefValue /*= case when ltrim(rtrim(isnull(mroc.CalendarNameInternal, ''))) <> '' then mroc.CalendarNameInternal
		
						   when u.UtilityCode = 'NYSEG' then '0' +  mroc.ProfileRateClass
						   when u.UtilityCode = 'NIMO' then 'NMP-E_' +  mroc.ProfileRateClass + '_06_CALENDAR'
						   when u.UtilityCode like 'PEPCO%' and ISNUMERIC ( mroc.ProfileRateClass) = 1 then 'PEPCO MDND'
						   when u.UtilityCode like 'PEPCO%' and ( mroc.ProfileRateClass = 'MMGTL2A' OR  mroc.ProfileRateClass = 'MMGTL2B')  then 'PEPCO MMGTL2' 
						   when u.UtilityCode like 'PEPCO%' then 'PEPCO ' +  mroc.ProfileRateClass 
						   when u.UtilityCode like 'O&R%' then Substring( mroc.ProfileRateClass , 0 , 5 ) 
						   
						   else ''
					  end */
	FROM #ExtEntity_Values
	/*#CalMap mroc -- lp_mtm..MtMRetailOfficeCalendarMapping mroc (nolock)

		LEFT JOIN LibertyPower..Utility u 
			ON case when mroc.UtilityID = 'ALLEGHENY' then 'ALLEGMD' 
					when mroc.UtilityID = 'CLP' then 'CL&P'
				else mroc.UtilityID end = u.UtilityCode -- valid utilities 
		
		LEFT JOIN LibertyPower..ExternalEntity ee 
			ON ee.EntityKey = u.ID
			AND ee.EntityTypeID = 2
			
	WHERE Determinant <> 'RateClass' -- rate code is used instead of load profile when determinant = RateClass ???? 			
		AND u.ID <> 18 -- CONED */

-- Get UtilityStratumRange
	-- copy stratum range into temp table to avoid scientific notation
	CREATE TABLE #CopyRange ( ServiceRateClass varchar(max) , StratumStart varchar(max) , StratumEnd varchar(max) ) 
	INSERT INTO #CopyRange
	SELECT ServiceRateClass ,  convert ( decimal(24,0), StratumStart ) , convert ( decimal(24,0), StratumEnd ) 
	FROM LibertyPower..UtilityStratumRange 
-- ================================================

-- /// Get RO Values fro CONED from UtilityStratumRange
-- ======================================================================
	INSERT INTO #ExtEntity_Values ( ExtEntityID  , ExtValue , IntRefValue ) 
	
	SELECT DISTINCT ExtEntityID = 8
				, 'ConEd SC' + ltrim(rtrim(ust.ServiceRateClass)) + ',' +  ltrim(rtrim(ust.StratumStart)) + ',' + ltrim(rtrim(ust.StratumEnd)) 
				, IntRefValue =  ltrim(rtrim(ust.ServiceRateClass)) + '-' +  ltrim(rtrim(ust.StratumEnd)) 
	
	FROM  #CopyRange ust 
	
-- /// Get CONED Values from UtilityStratumRange
-- ======================================================================
	DECLARE @CONEDEntity INT 
	SELECT @CONEDEntity = ID	
	FROM LibertyPower..ExternalEntity 
	WHERE EntityKey = 18 and EntityTypeID = 2 
	
	INSERT INTO #ExtEntity_Values ( ExtEntityID  , ExtValue , IntRefValue ) 
	
	SELECT DISTINCT 	@CONEDEntity
				, ExtValue =  ltrim(rtrim(ust.ServiceRateClass)) + '-' +  ltrim(rtrim(ust.StratumEnd)) 
				, IntRefValue =  ltrim(rtrim(ust.ServiceRateClass)) + '-' +  ltrim(rtrim(ust.StratumEnd)) 
	
	FROM  #CopyRange ust 
		

-- /////// Insert Missing Property Internal Reference values 
-- ===========================================================
	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])
	SELECT eev.IntRefValue , 0 , GETDATE() , 0 ,@PropertyID , @PropertyTypeID
	FROM #ExtEntity_Values eev 
		LEFT JOIN libertypower..PropertyInternalRef pir (NOLOCK) ON eev.IntRefValue = pir.Value AND pir.propertyId = 2
	WHERE	pir.Value is null
	and		eev.ExtEntityID <> 8
				
-- /////// ALL Utility Values Profile MIGRATION 
-- ===========================================================
	DECLARE @propertyInternalRef int 
	DECLARE @ExtValue varchar (50) 
	DECLARE @ExtEntityID int 
	DECLARE @propertyValueID int 
	DECLARE @IntValue varchar (50) 
		
	DECLARE migr_csr CURSOR FAST_FORWARD FOR 
	
	SELECT DISTINCT pir.id PropertyInternalRefID, eev.ExtValue , eev.ExtEntityID , eev.IntRefValue
		
	FROM #ExtEntity_Values eev
	
		Inner JOIN LibertyPower..PropertyInternalRef PIR (NOLOCK) 
			ON pir.Value = eev.IntRefValue
				AND pir.propertyId = @PropertyID					-- internal reference
		
		left JOIN LibertyPower.dbo.ExternalEntityValue ev (NOLOCK) 
			ON ev.ExternalEntityID = eev.ExtEntityID			-- external entity 			
			
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = ev.PropertyValueID
			AND pv.PropertyId = @PropertyID
			AND pv.value = eev.ExtValue			-- external entity value 
				
	WHERE pv.ID is null 	
		
			
	OPEN migr_csr	
	FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue , @ExtEntityID , @IntValue
	 	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 

	-- ==================================			
	-- Load Property Value 
	-- ================================== 
		SET @propertyValueID = 0 
	
		-- property value does not exist create new one 
		INSERT INTO [LibertyPower].[dbo].[PropertyValue]
		   ([InternalRefID],[Value], [PropertyId] , [PropertyTypeId], [Inactive], [DateCreated], [CreatedBy])
		SELECT @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID ,  0 , getdate() , 0
		
		SELECT @propertyValueID = SCOPE_IDENTITY() 
					
	-- ===================================
	-- Load External Entity Value mapping 
	-- ===================================
		INSERT INTO LibertyPower.dbo.[ExternalEntityValue] 
			([ExternalEntityID] ,[PropertyValueID] ,[Inactive],[DateCreated] ,[CreatedBy] ) 
		SELECT @ExtEntityID, @propertyValueID, 0 , getdate() , 1 
		WHERE NOT EXISTS ( SELECT * 
							FROM LibertyPower.dbo.[ExternalEntityValue] (NOLOCK)  
							WHERE ExternalEntityID = @ExtEntityID AND PropertyValueID = @propertyValueID 
						) 
				AND @propertyValueID IS NOT NULL 
				
	-- ==============================
	
		FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue , @ExtEntityID , @IntValue
	END 
	CLOSE migr_csr
	DEALLOCATE migr_csr
		
