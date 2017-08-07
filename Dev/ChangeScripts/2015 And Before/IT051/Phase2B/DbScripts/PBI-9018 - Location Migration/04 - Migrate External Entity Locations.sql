--select * FROM LibertyPower.._tmp_RiskCodeMap order by 1 
--select * from LibertyPower..vw_ExternalEntity
--select * from lp_mtm..MtMRetailOfficeZoneMapping 
-- ==================================================================
USE LibertyPower
GO 

--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO 

--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


	DECLARE @propertyValueID int 
	DECLARE @propertyInternalRef int 
	DECLARE @ExtValue varchar (50) 
	DECLARE @ExternalEntityID int 
	DECLARE @PropertyID int 
	DECLARE @PropertyTypeID int 
	
	SET @PropertyID = 1 -- Locations !!!!

	SELECT * 
	INTO #ZoneMap
	FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.MtMRetailOfficeZoneMapping
	--Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9
	-- 'Data Source=LPCNOCSQL9\TRANSACTIONS;Integrated Security=SSPI'

	SELECT * 
	INTO #ZainetZone
	FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.MtMZainetZones
	--Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9
	-- 'Data Source=LPCNOCSQL9\TRANSACTIONS;Integrated Security=SSPI'
	
SELECT * 
INTO #MissingZones
FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.MissingZones

-- /////// ISO SETTLMENT LOCATION MIGRATION 
-- ===========================================================
	DECLARE migr_csr CURSOR FAST_FORWARD FOR 
	
		SELECT DISTINCT PropertyInternalRefID = pir.id  , EntityValue = rm.ISO_SETTLEMENT , EntityID = ee.ID  , PropertyValueID = pv.ID , PropertTypeID = pt.ID 
		FROM LibertyPower.._tmp_RiskCodeMap rm (NOLOCK)
			
			-- internal reference 
			LEFT JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) 
				ON pir.Value = rm.ENROLLMENT_STD			-- internal refernce
				AND pir.propertyId = 1 		
			
			-- Property Type 
			LEFT JOIN LibertyPower..PropertyType pt (NOLOCK) 
				ON  CHARINDEX (pt.name , rm.Location_TYPE ) > 0 
				
			-- external entity value
			JOIN LibertyPower..vw_ExternalEntity ee (NOLOCK) 
				ON ee.Name = rm.iso
				AND ee.EntityTypeID = 1
			LEFT JOIN LibertyPower..ExternalEntityValue ev (NOLOCK) 
				ON ev.ExternalEntityID = ee.ID 
			LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
				ON pv.ID = ev.PropertyValueID
				AND pv.PropertyId = 1 
				AND pv.value =  rm.ISO_SETTLEMENT			-- external entity value 
	
		WHERE pv.ID is null 
			
				
	OPEN migr_csr	
	FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue , @ExternalEntityID , @PropertyValueID , @PropertyTypeID
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
	
	-- Load Property Value 
	-- ================================= 
		SET @propertyValueID = 0 
	
		-- check if value already exists
		SELECT @propertyValueID = ISNULL(pv.ID, 0)
		FROM LibertyPower..PropertyValue pv (NOLOCK)
		WHERE pv.PropertyId = 1 
			And pv.Value = @ExtValue
			And pv.InternalRefId = @propertyInternalRef
		
		IF @propertyValueID = 0 
		BEGIN 
			-- property value does not exist create new one 
			INSERT INTO [LibertyPower].[dbo].[PropertyValue]
			   ([InternalRefID],[Value], [PropertyId] , [PropertyTypeId], [Inactive], [DateCreated], [CreatedBy])
			SELECT @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID ,  0 , getdate() , 0 
	
			SELECT @propertyValueID = SCOPE_IDENTITY()
		END 
		ELSE 
			-- update internal ref values
			UPDATE [LibertyPower].[dbo].[PropertyValue] SET InternalRefID = @propertyInternalRef , Modified = GETDATE() , ModifiedBy = 0 
			WHERE ID  = @propertyValueID 
				AND ISNULL (InternalRefID , 0)= 0 
	-- =====================================
	
	-- Load ISO Entity Value mapping 
	-- ================================
		INSERT INTO [LibertyPower].[dbo].[ExternalEntityValue] 
			([ExternalEntityID] ,[PropertyValueID] ,[Inactive],[DateCreated] ,[CreatedBy] ) 
		SELECT @ExternalEntityID, @propertyValueID, 0 , getdate() , 0 
		WHERE NOT EXISTS ( SELECT * 
								FROM [LibertyPower].[dbo].[ExternalEntityValue] eev (NOLOCK)
								WHERE eev.ExternalEntityID = @ExternalEntityID 
									AND eev.PropertyValueID = @propertyValueID
							 ) 
	-- ==============================
	
		FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue , @ExternalEntityID , @PropertyValueID , @PropertyTypeID
	END 
	CLOSE migr_csr
	DEALLOCATE migr_csr

	/******* U P A T E    E X T E R N A L    V A L U E S    F R O M    M I S S I N G   Z O N E S *********/
	DECLARE migr_MissingZones CURSOR FAST_FORWARD FOR 

	SELECT	DISTINCT PropertyInternalRefID = pir.id  , EntityValue = rm.ZoneCode , EntityID = ee.ID  , PropertyValueID = pv.ID , PropertTypeID = 1
	FROM	#MissingZones rm
	LEFT	JOIN PropertyInternalRef pir (NOLOCK) 
	ON		pir.Value = rm.UtilityCode + '-' + rm.InternalValue
	AND		pir.propertyId = 1 		
	JOIN	vw_ExternalEntity ee (NOLOCK)
	ON		ee.Name = rm.ISO
	AND		ee.EntityTypeID = 1
	LEFT	JOIN ExternalEntityValue ev (NOLOCK) 
	ON		ev.ExternalEntityID = ee.ID 
	LEFT	JOIN PropertyValue pv (NOLOCK) 
	ON		pv.ID = ev.PropertyValueID
	AND		pv.PropertyId = 1 
	AND		pv.value =  rm.ZoneCode
	WHERE	pv.ID is null 

	OPEN migr_MissingZones	
	FETCH NEXT FROM migr_MissingZones INTO @propertyInternalRef, @ExtValue , @ExternalEntityID , @PropertyValueID , @PropertyTypeID
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		SET @propertyValueID = 0 
	
		SELECT	@propertyValueID = ISNULL(pv.ID, 0)
		FROM	PropertyValue pv (NOLOCK)
		WHERE	pv.PropertyId = 1 
		And		pv.Value = @ExtValue
		And		pv.InternalRefId = @propertyInternalRef
		
		IF @propertyValueID = 0 
		BEGIN 
			-- property value does not exist create new one 
			INSERT INTO [PropertyValue]
			   ([InternalRefID],[Value], [PropertyId] , [PropertyTypeId], [Inactive], [DateCreated], [CreatedBy])
			SELECT @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID ,  0 , getdate() , 0 
	
			SELECT @propertyValueID = SCOPE_IDENTITY()
		END 
		
		INSERT INTO [ExternalEntityValue] 
			([ExternalEntityID] ,[PropertyValueID] ,[Inactive],[DateCreated] ,[CreatedBy] ) 
		SELECT @ExternalEntityID, @propertyValueID, 0 , getdate() , 0 
		WHERE NOT EXISTS (	SELECT * 
							FROM	[ExternalEntityValue] eev (NOLOCK)
							WHERE	eev.ExternalEntityID = @ExternalEntityID 
							AND		eev.PropertyValueID = @propertyValueID	 ) 

		FETCH NEXT FROM migr_MissingZones INTO @propertyInternalRef, @ExtValue , @ExternalEntityID , @PropertyValueID , @PropertyTypeID
	END 
	CLOSE migr_MissingZones
	DEALLOCATE migr_MissingZones

	/****************************************************************************************************/


-- /////// RETAIL OFFICE LOCATION MIGRATION 
-- ===========================================================
	SET @ExternalEntityID = 8 -- Retail Office  
	SET @PropertyTypeID = 1 -- Zone 
	 -- CAN BE BY UTILITY !!!!!!!!!!!!!!!
	 
	DECLARE migr_csr CURSOR FAST_FORWARD FOR 
	
	SELECT DISTINCT pir.id PropertyInternalRefID , mro.ServicePointExternalID
	FROM #ZoneMap mro -- lp_mtm.dbo.MtMRetailOfficeZoneMapping
		
		-- internal reference 
		LEFT JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) 
			ON pir.Value = mro.UtilityId + '-' + mro.Zone						-- internal refernce
			AND pir.propertyId = 1 		

		-- external entity value
		LEFT JOIN LibertyPower..ExternalEntityValue ev (NOLOCK) 
			ON ev.ExternalEntityID = @ExternalEntityID			-- external entity 
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = ev.PropertyValueID
			AND pv.PropertyId = 1 
			AND pv.value = mro.ServicePointExternalID	-- external entity value 
				
	WHERE pv.ID is null 	
			
	OPEN migr_csr	
	FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue 
	 	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
	
	-- Load Property Value 
	-- ================================= 
		SET @propertyValueID = 0 
	
		-- check if value already exists
		SELECT @propertyValueID = ISNULL(pv.ID, 0)
		FROM LibertyPower..PropertyValue pv (NOLOCK)
		WHERE pv.PropertyId = 1 
			And pv.Value = @ExtValue
		
		IF @propertyValueID = 0 
		BEGIN 
			-- property value does not exist create new one 
			INSERT INTO [LibertyPower].[dbo].[PropertyValue]
			   ([InternalRefID],[Value], [PropertyId] , [PropertyTypeId], [Inactive], [DateCreated], [CreatedBy])
			SELECT @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID ,  0 , getdate() , 0 
	
			SELECT @propertyValueID = SCOPE_IDENTITY()
		END 
		ELSE 
			-- update internal ref values
			UPDATE [LibertyPower].[dbo].[PropertyValue] SET InternalRefID = @propertyInternalRef , Modified = GETDATE() , ModifiedBy = 0 
			WHERE ID  = @propertyValueID 
				AND ISNULL (InternalRefID , 0)= 0 
	-- =====================================
	
	-- Load RO Entity Value mapping 
	-- ================================
		INSERT INTO [LibertyPower].[dbo].[ExternalEntityValue] 
			([ExternalEntityID] ,[PropertyValueID] ,[Inactive],[DateCreated] ,[CreatedBy] ) 
		SELECT @ExternalEntityID, @propertyValueID, 0 , getdate() , 0 
		WHERE NOT EXISTS ( SELECT * 
								FROM [LibertyPower].[dbo].[ExternalEntityValue] eev (NOLOCK)
								WHERE eev.ExternalEntityID = @ExternalEntityID 
									AND eev.PropertyValueID = @propertyValueID
							 ) 
	-- ==============================
	
		FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue 
	END 
	CLOSE migr_csr
	DEALLOCATE migr_csr

	

-- /////// ZAINET LOCATION MIGRATION 
-- ===========================================================
	SET @ExternalEntityID = 9 -- Zainet 
	SET @PropertyTypeID = 1  -- Zone 
	
	DECLARE migr_csr CURSOR FAST_FORWARD FOR 
	
	SELECT DISTINCT pir.id PropertyInternalRefID , rm.ZAINET 
	FROM LibertyPower.._tmp_RiskCodeMap rm (NOLOCK)
		
		-- internal reference 
		LEFT JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) 
			ON pir.Value = rm.ENROLLMENT_STD					-- internal refernce
			AND pir.propertyId = 1 		

		-- external entity value
		LEFT JOIN LibertyPower..ExternalEntityValue ev (NOLOCK) 
			ON ev.ExternalEntityID = 9 -- @ExternalEntityID			-- external entity 
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = ev.PropertyValueID
			AND pv.PropertyId = 1 
			AND pv.value = rm.ZAINET				-- external entity value 
			
	WHERE pv.ID is null  
	
	UNION 
	
	SELECT DISTINCT pir.id PropertyInternalRefID , mz.ZainetZone 
	FROM #ZainetZone mz (NOLOCK) -- lp_mtm..MtMZainetZones mz
	
	INNER	Join Utility u
	On		mz.UtilityId = u.ID
	
		-- internal reference 
		LEFT JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) 
			ON pir.Value =  u.UtilityCode + '-'+ mz.Zone						-- internal refernce
			AND pir.propertyId = 1 		

		-- external entity value
		LEFT JOIN LibertyPower..ExternalEntityValue ev (NOLOCK) 
			ON ev.ExternalEntityID = 9--@ExternalEntityID			-- external entity 
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = ev.PropertyValueID
			AND pv.PropertyId = 1 
			AND pv.value = mz.ZainetZone				-- external entity value 
			
	WHERE pv.ID is null  
			
	OPEN migr_csr	
	FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue 
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
	
	-- Load Property Value 
	-- ================================= 
		SET @propertyValueID = 0 
	
		-- check if value already exists
		SELECT @propertyValueID = ISNULL(pv.ID, 0)
		FROM LibertyPower..PropertyValue pv (NOLOCK)
		WHERE pv.PropertyId = 1 
			And pv.Value = @ExtValue
			And pv.InternalRefId = @propertyInternalRef
		
		IF @propertyValueID = 0 
		BEGIN 
			-- property value does not exist create new one 
			INSERT INTO [LibertyPower].[dbo].[PropertyValue]
			   ([InternalRefID],[Value], [PropertyId] , [PropertyTypeId], [Inactive], [DateCreated], [CreatedBy])
			SELECT @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID ,  0 , getdate() , 0 
	
			SELECT @propertyValueID = SCOPE_IDENTITY()
		END 
		ELSE 
			-- update internal ref values
			UPDATE [LibertyPower].[dbo].[PropertyValue] SET InternalRefID = @propertyInternalRef , Modified = GETDATE() , ModifiedBy = 0 
			WHERE ID  = @propertyValueID 
				AND ISNULL (InternalRefID , 0)= 0 
	-- =====================================
	
	-- Load Zainet Entity Value mapping 
	-- ================================
		INSERT INTO [LibertyPower].[dbo].[ExternalEntityValue] 
			([ExternalEntityID] ,[PropertyValueID] ,[Inactive],[DateCreated] ,[CreatedBy] ) 
		SELECT @ExternalEntityID, @propertyValueID, 0 , getdate() , 0 
			WHERE NOT EXISTS ( SELECT * 
								FROM [LibertyPower].[dbo].[ExternalEntityValue] eev (NOLOCK)
								WHERE eev.ExternalEntityID = @ExternalEntityID 
									AND eev.PropertyValueID = @propertyValueID
							 ) 
							 
	-- ==============================
	
		FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue 
	END 
	CLOSE migr_csr
	DEALLOCATE migr_csr
		

-- /////// MATPRICE LOCATION MIGRATION 
-- ===========================================================
	SET @ExternalEntityID = 10 -- MatPrice 
	SET @PropertyTypeID = 1  -- Zone 
	
	
	DECLARE migr_csr CURSOR FAST_FORWARD FOR 
	
	SELECT DISTINCT pir.id PropertyInternalRefID , rm.MATPRICE 
	FROM LibertyPower.._tmp_RiskCodeMap rm (NOLOCK)
	
		-- internal reference 
		LEFT JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) 
			ON pir.Value = rm.ENROLLMENT_STD					-- internal refernce
			AND pir.propertyId = 1 		

		-- external entity value
		LEFT JOIN LibertyPower..ExternalEntityValue ev (NOLOCK) 
			ON ev.ExternalEntityID = 10 -- @ExternalEntityID			-- external entity 
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = ev.PropertyValueID
			AND pv.PropertyId = 1 
			AND pv.value = rm.MATPRICE				-- external entity value 
		
	WHERE pv.ID is null   
			
	OPEN migr_csr	
	FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue 
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
	
	-- Load Property Value 
	-- ================================= 
		SET @propertyValueID = 0 
	
		-- check if value already exists
		SELECT @propertyValueID = ISNULL(pv.ID, 0)
		FROM LibertyPower..PropertyValue pv (NOLOCK)
		WHERE pv.PropertyId = 1 
			And pv.Value = @ExtValue
			And pv.InternalRefId = @propertyInternalRef
		
		IF @propertyValueID = 0 
		BEGIN 
			-- property value does not exist create new one 
			INSERT INTO [LibertyPower].[dbo].[PropertyValue]
			   ([InternalRefID],[Value], [PropertyId] , [PropertyTypeId], [Inactive], [DateCreated], [CreatedBy])
			SELECT @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID ,  0 , getdate() , 0 
	
			SELECT @propertyValueID = SCOPE_IDENTITY()
		END 
		ELSE 
			-- update internal ref values
			UPDATE [LibertyPower].[dbo].[PropertyValue] SET InternalRefID = @propertyInternalRef , Modified = GETDATE() , ModifiedBy = 0 
			WHERE ID  = @propertyValueID 
				AND ISNULL (InternalRefID , 0)= 0 
	-- =====================================
	
	-- Load MATPRICE Entity Value mapping 
	-- ================================
		INSERT INTO [LibertyPower].[dbo].[ExternalEntityValue] 
			([ExternalEntityID] ,[PropertyValueID] ,[Inactive],[DateCreated] ,[CreatedBy] ) 
		SELECT @ExternalEntityID, @propertyValueID, 0 , getdate() , 0 
			WHERE NOT EXISTS ( SELECT * 
							FROM [LibertyPower].[dbo].[ExternalEntityValue] eev (NOLOCK)
							WHERE eev.ExternalEntityID = @ExternalEntityID 
								AND eev.PropertyValueID = @propertyValueID
						 ) 
	-- ==============================
	
		FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue 
	END 
	CLOSE migr_csr
	DEALLOCATE migr_csr
	
	-- /////// PRICING/KIODEX LOCATION MIGRATION 
-- ===========================================================
	SET @ExternalEntityID = 11 -- Pricing 
	SET @PropertyTypeID = 1  -- Zone 
	
	
	DECLARE migr_csr CURSOR FAST_FORWARD FOR 
	
	SELECT DISTINCT pir.id PropertyInternalRefID , rm.KIODEX 
	FROM LibertyPower.._tmp_RiskCodeMap rm (NOLOCK)
	
		-- internal reference 
		LEFT JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) 
			ON pir.Value = rm.ENROLLMENT_STD					-- internal refernce
			AND pir.propertyId = 1 		

		-- external entity value
		LEFT JOIN LibertyPower..ExternalEntityValue ev (NOLOCK) 
			ON ev.ExternalEntityID = @ExternalEntityID				-- external entity 
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = ev.PropertyValueID
			AND pv.PropertyId = 1 
			AND pv.value = rm.KIODEX					-- external entity value 
		
	WHERE pv.ID is null  
	
	OPEN migr_csr	
	FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue 
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		SET @propertyValueID = 0 
		
	-- Load Property Value 
	-- ================================= 
		SET @propertyValueID = 0 
	
		-- check if value already exists
		SELECT @propertyValueID = ISNULL(pv.ID, 0)
		FROM LibertyPower..PropertyValue pv (NOLOCK)
		WHERE pv.PropertyId = 1 
			And pv.Value = @ExtValue
			And pv.InternalRefId = @propertyInternalRef
		
		IF @propertyValueID = 0 
		BEGIN 
			-- property value does not exist create new one 
			INSERT INTO [LibertyPower].[dbo].[PropertyValue]
			   ([InternalRefID],[Value], [PropertyId] , [PropertyTypeId], [Inactive], [DateCreated], [CreatedBy])
			SELECT @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID ,  0 , getdate() , 0 
	
			SELECT @propertyValueID = SCOPE_IDENTITY()
		END 
		ELSE 
			-- update internal ref values
			UPDATE [LibertyPower].[dbo].[PropertyValue] SET InternalRefID = @propertyInternalRef , Modified = GETDATE() , ModifiedBy = 0 
			WHERE ID  = @propertyValueID 
				AND ISNULL (InternalRefID , 0)= 0 
	-- =====================================
	
	-- Load Zainet Entity Value mapping 
	-- ================================
		INSERT INTO [LibertyPower].[dbo].[ExternalEntityValue] 
			([ExternalEntityID] ,[PropertyValueID] ,[Inactive],[DateCreated] ,[CreatedBy] ) 
		SELECT @ExternalEntityID, @propertyValueID, 0 , getdate() , 0 
		WHERE NOT EXISTS ( SELECT * 
								FROM [LibertyPower].[dbo].[ExternalEntityValue] eev (NOLOCK)
								WHERE eev.ExternalEntityID = @ExternalEntityID 
									AND eev.PropertyValueID = @propertyValueID
							 ) 
	-- ==============================
	
		FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue 
	END 
	CLOSE migr_csr
	DEALLOCATE migr_csr