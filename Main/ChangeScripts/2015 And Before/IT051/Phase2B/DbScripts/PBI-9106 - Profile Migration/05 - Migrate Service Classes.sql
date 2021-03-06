USE LibertyPower
GO

	-- select * from vw_ExternalEntity
	-- select * from [Lp_risk].[dbo].[ServiceClassLoadShapeIDMapping]

	DECLARE @PropertyID int 
	DECLARE @ExtEntityID int 
	DECLARE @propertyValueID int 
	DECLARE @ExtValue varchar(100) 
	DECLARE @propertyInternalRef int 
	DECLARE @PropertyTypeID int 
	
	SET @ExtEntityID = 31 -- CONED Entity ID 
	SET @PropertyID = 3 -- Service Class 
	SET @PropertyTypeID = 0 
	
	-- in case the new property type does not exist - will fail if it does	
	-- =============================================
	IF NOT EXISTS (SELECT * FROM [dbo].[PropertyName] WHERE [ID] = 3 ) 
	BEGIN 
		SET IDENTITY_INSERT [dbo].[PropertyName] ON
		INSERT [dbo].[PropertyName] ([ID], [Name], [Inactive], [DateCreated], [CreatedBy]) VALUES (3, N'Service Class', 0, GETDATE(), 0)
		SET IDENTITY_INSERT [dbo].[PropertyName] OFF
	END 
	
	-- Add Internal References
  	-- ==============================================
  	INSERT INTO [LibertyPower].[dbo].[PropertyInternalRef]
			   ([Value],[Inactive],[DateCreated],[CreatedBy],[propertyId],[propertytypeId])

	SELECT DISTINCT [LoadShapeServiceClass]	, 0 , GETDATE() , 0 , @PropertyID , @PropertyTypeID
	FROM [Lp_risk].[dbo].[ServiceClassLoadShapeIDMapping] (nolock)
		LEFT JOIN LibertyPower..PropertyInternalRef PIR (NOLOCK) 
			ON pir.Value = [LoadShapeServiceClass]
				AND pir.propertyId = 3	-- Service Class
			
	WHERE pir.ID is null 
	
	-- Add CONED references 
	-- ================================================
				
				
-- /////// ALL Utility Values Profile MIGRATION 
-- ===========================================================
  	DECLARE migr_csr CURSOR FAST_FORWARD FOR 
	SELECT DISTINCT pir.id PropertyInternalRefID , sc.LoadShapeServiceClass , @ExtEntityID
		
	FROM [Lp_risk].[dbo].[ServiceClassLoadShapeIDMapping] sc (NOLOCK)
	
		LEFT JOIN LibertyPower..PropertyInternalRef PIR (NOLOCK) 
			ON pir.Value = sc.CustomerServiceClass
				AND pir.propertyId = @PropertyID					-- internal reference
		
		LEFT JOIN LibertyPower.dbo.ExternalEntityValue ev (NOLOCK) 
			ON ev.ExternalEntityID = @ExtEntityID			-- external entity 			
			
		LEFT JOIN LibertyPower..PropertyValue pv (NOLOCK) 
			ON pv.ID = ev.PropertyValueID
			AND pv.PropertyId = @PropertyID
			AND pv.value = sc.CustomerServiceClass		-- external entity value 
				
	WHERE pv.ID is null 	
		
			
	OPEN migr_csr	
	FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue , @ExtEntityID 
	 	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		DECLARE @CurrIntRef int 
		
		-- Load Property Value 
		-- ================================= 
		SET @propertyValueID = 0 
	
		-- check if value already exists
		SELECT @propertyValueID = ISNULL(pv.ID, 0) , @CurrIntRef = ISNULL(pv.InternalRefID, 0) 
		FROM LibertyPower..PropertyValue pv (NOLOCK)
		WHERE pv.PropertyId = @PropertyID 
			And pv.Value = @ExtValue
			And pv.InternalReferenceId = @propertyInternalRef

		IF ISNULL(@propertyValueID , 0) = 0  AND @ExtValue IS NOT NULL 
		BEGIN 
			-- property value does not exist create new one 
			INSERT INTO [LibertyPower].[dbo].[PropertyValue]
			   ([InternalRefID],[Value], [PropertyId] , [PropertyTypeId], [Inactive], [DateCreated], [CreatedBy])
			SELECT @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID ,  0 , getdate() , 0
	
			--SELECT @propertyValueID = @@IDENTITY -- SCOPE_IDENTITY()  --- does not return id ??
			
			SELECT @propertyValueID = ISNULL(pv.ID, 0)
			FROM LibertyPower..PropertyValue pv (NOLOCK)
			WHERE pv.PropertyId = @PropertyID 
				And pv.Value = @ExtValue
---- debug 			
--select ' inserted prop value: ' , pir =  @propertyInternalRef , val = @ExtValue , id = @propertyValueID
		END 
---- debbug 
--else 
--select ' found prop value: ' , pir =  @propertyInternalRef , val = @ExtValue , id = @propertyValueID
	
--IF ISNULL(@propertyValueID , 0) = 0 
--	SELECT  @propertyInternalRef , @ExtValue, @PropertyID , @PropertyTypeID 
-- --end debug

			
	-- =====================================
	-- Load RO Entity Value mapping 
	-- ================================
		INSERT INTO LibertyPower.dbo.[ExternalEntityValue] 
			([ExternalEntityID] ,[PropertyValueID] ,[Inactive],[DateCreated] ,[CreatedBy] ) 
		SELECT @ExtEntityID, @propertyValueID, 0 , getdate() , 0 
		WHERE NOT EXISTS ( SELECT * 
							FROM LibertyPower.dbo.[ExternalEntityValue] (NOLOCK)  
							WHERE ExternalEntityID = @ExtEntityID AND PropertyValueID = @propertyValueID 
						) 
				AND @propertyValueID IS NOT NULL 
	-- ==============================
	
		FETCH NEXT FROM migr_csr INTO @propertyInternalRef, @ExtValue , @ExtEntityID 
	END 
	CLOSE migr_csr
	DEALLOCATE migr_csr
		
		


		