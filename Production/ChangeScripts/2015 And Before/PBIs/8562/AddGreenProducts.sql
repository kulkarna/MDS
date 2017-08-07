
DECLARE	@ProductTypeID	int,
		@ProductBrandID	int,
		@Now			datetime
SET	@Now	= GETDATE()
SELECT	@ProductTypeID = ProductTypeID FROM Libertypower..ProductType WITH (NOLOCK) WHERE Name LIKE '%green%'

-- product type  -----------------------------------------------------------------------------
IF @ProductTypeID IS NULL
	BEGIN
		BEGIN TRAN PT	
		
		INSERT INTO Libertypower..ProductType
		SELECT 'Green', 1, 'libertypower\rideigsler', GETDATE()
		
		SET	@ProductTypeID	= SCOPE_IDENTITY()
		
		IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN PT
				PRINT 'Error occurred. No wind product type or green products were created.'
				RETURN
			END
		ELSE 
			BEGIN
				COMMIT TRAN PT
			END			
	END

SELECT @ProductBrandID = ProductBrandID FROM Libertypower..ProductBrand WITH (NOLOCK) WHERE Name = 'Fixed IL Wind'

IF @ProductBrandID IS NULL
	BEGIN
		BEGIN TRAN WIND	
			
		-- wind  ---------------------------------------------------------------------------------------	
		INSERT INTO Libertypower..ProductBrand
		SELECT @ProductTypeID, 'Fixed IL Wind', 0, 0, 3, 1, 'libertypower\rideigsler', GETDATE(), 0
		
		SET	@ProductBrandID	= SCOPE_IDENTITY()
	
		IF NOT EXISTS (SELECT 1 FROM lp_common..common_product WITH (NOLOCK) WHERE ProductBrandID = @ProductBrandID)
			BEGIN
				INSERT	INTO [lp_common].[dbo].[common_product]([product_id],[product_descp],[product_category],[product_sub_category], 
						[utility_id],[frecuency],[db_number],[term_months],[date_created],[username],[inactive_ind],[active_date],[chgstamp], 
						[default_expire_product_id],[requires_profitability],[is_flexible],[account_type_id],[IsCustom],[IsDefault],[ProductBrandID])
				SELECT	REPLACE(product_id, '_MT_', '_G1_'), -- product id for green
						REPLACE([product_descp], 'MULTI-TERM', 'GREEN'), -- product description for green
						[product_category],[product_sub_category],[utility_id],[frecuency],[db_number],[term_months],@Now, 
						p.[username],[inactive_ind],@Now,p.[chgstamp],[default_expire_product_id],[requires_profitability], 
						[is_flexible],[account_type_id],[IsCustom],[IsDefault], 
						@ProductBrandID -- product brand for green
				FROM	[lp_common].[dbo].[common_product] p WITH (NOLOCK)
						INNER JOIN Libertypower..Utility u WITH (NOLOCK)
						ON p.utility_id = u.UtilityCode
				WHERE	1=1
				AND p.inactive_ind = 0
				AND p.iscustom = 0
				AND p.isdefault = 0
				AND p.ProductBrandID = 17
				AND	u.InactiveInd = 0
				ORDER BY 1
			END		
			
		IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN WIND
				PRINT 'Error occurred. No wind products were created.'
			END
		ELSE 
			BEGIN
				COMMIT TRAN WIND
			END					
	END					

SET	@ProductBrandID = NULL
SELECT @ProductBrandID = ProductBrandID FROM Libertypower..ProductBrand WITH (NOLOCK) WHERE Name = 'Fixed National Green E'

IF @ProductBrandID IS NULL
	BEGIN	
		BEGIN TRAN GREENE
					
		-- green-e  ------------------------------------------------------------------------------------
		INSERT INTO Libertypower..ProductBrand
		SELECT @ProductTypeID, 'Fixed National Green E', 0, 0, 3, 1, 'libertypower\rideigsler', GETDATE(), 0
		
		SET	@ProductBrandID	= SCOPE_IDENTITY()

		IF NOT EXISTS (SELECT 1 FROM lp_common..common_product WITH (NOLOCK) WHERE ProductBrandID = @ProductBrandID)
			BEGIN
				INSERT	INTO [lp_common].[dbo].[common_product]([product_id],[product_descp],[product_category],[product_sub_category], 
						[utility_id],[frecuency],[db_number],[term_months],[date_created],[username],[inactive_ind],[active_date],[chgstamp], 
						[default_expire_product_id],[requires_profitability],[is_flexible],[account_type_id],[IsCustom],[IsDefault],[ProductBrandID])
				SELECT	REPLACE(product_id, '_MT_', '_G2_'), -- product id for green
						REPLACE([product_descp], 'MULTI-TERM', 'GREEN'), -- product description for green
						[product_category],[product_sub_category],[utility_id],[frecuency],[db_number],[term_months],@Now, 
						p.[username],[inactive_ind],[active_date],p.[chgstamp],[default_expire_product_id],[requires_profitability], 
						[is_flexible],[account_type_id],[IsCustom],[IsDefault], 
						@ProductBrandID -- product brand for green
				FROM	[lp_common].[dbo].[common_product] p WITH (NOLOCK)
						INNER JOIN Libertypower..Utility u WITH (NOLOCK)
						ON p.utility_id = u.UtilityCode
				WHERE	1=1
				AND p.inactive_ind = 0
				AND p.iscustom = 0
				AND p.isdefault = 0
				AND p.ProductBrandID = 17
				AND	u.InactiveInd = 0
				ORDER BY 1
			END	
			
		IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN GREENE
				PRINT 'Error occurred. No green-e products were created.'
			END
		ELSE 
			BEGIN
				COMMIT TRAN GREENE	
			END			
	END					