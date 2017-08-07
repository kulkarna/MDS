USE [LibertyPower]
GO

BEGIN TRAN 

/* PBI3569/AddMultiTermCustomProducts.sql */
IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductBrand WHERE Name = 'Custom SmartStep')
	BEGIN
		DECLARE	@ProductBrandID	int,
				@Today			datetime

		SET	@Today = GETDATE()

		INSERT	INTO Libertypower..ProductBrand
		SELECT	7, 'Custom SmartStep', 1, 0, 3, 1, 'libertypower\rideigsler',	@Today, 1

		SET	@ProductBrandID = SCOPE_IDENTITY()

		INSERT	INTO Lp_common..common_product
		SELECT	LTRIM(RTRIM(product_id)) + '_MT', 'Custom SmartStep', product_category, product_sub_category, utility_id, frecuency, 
				db_number, term_months, @Today, 'libertypower\rideigsler', inactive_ind, @Today, 0, default_expire_product_id, 
				requires_profitability, is_flexible, account_type_id, IsCustom, IsDefault, @ProductBrandID
		FROM	Lp_common..common_product
		WHERE	product_descp			= 'CUSTOM FIXED'
		AND		product_sub_category	= 'CUSTOM'
		AND		account_type_id			= 1
		AND		inactive_ind			= 0

		DECLARE	@ProductID		varchar(20),
				@RoleID			int

		DECLARE @ProductIDTable TABLE (ProductID varchar(20))
		DECLARE @RoleIDTable TABLE (RoleID int)

		INSERT	INTO @ProductIDTable
		SELECT	DISTINCT product_id
		FROM	Lp_common..common_product
		WHERE	product_descp			= 'Custom SmartStep'
		AND		product_sub_category	= 'CUSTOM'
		AND		account_type_id			= 1
		AND		inactive_ind			= 0

		WHILE (SELECT COUNT(ProductID) FROM @ProductIDTable) > 0
			BEGIN
				INSERT	INTO @RoleIDTable
				SELECT	DISTINCT role_id
				FROM	Lp_security..security_role_product
				ORDER BY role_id

				SELECT TOP 1 @ProductID = ProductID FROM @ProductIDTable

				WHILE (SELECT COUNT(RoleID) FROM @RoleIDTable) > 0
					BEGIN
						SELECT TOP 1 @RoleID = RoleID FROM @RoleIDTable

						IF NOT EXISTS (SELECT 1 FROM Lp_security..security_role_product WHERE role_id = @RoleID AND product_id = @ProductID)
							BEGIN
								INSERT	INTO Lp_security..security_role_product
								SELECT	@RoleID, @ProductID, 0, 0, 0, 0
							END

						DELETE FROM @RoleIDTable WHERE RoleID = @RoleID
					END
				DELETE FROM @ProductIDTable WHERE ProductID = @ProductID
			END
	END

--  ROLLBACK
COMMIT 
