
---- This is part of a 3 step process to transfer rates from DailyPricing to our legacy tables.
---- Step 1 sets up some temporary tables that will be used in later steps.  One of these tables has the SuperSaver calculations in it.
---- Step 2 takes the DailyPricing data and transforms it into legacy format using a mapping table.
---- Step 3 updates the production legacy tables.  There is an option to update the main table or just the history table.  
----        For the history table, there is an option to replace the history that is already there, or only fill in missing records.
----
---- All steps are safely re-runnable, but avoid skipping steps.


--EXEC usp_CreateProductRate_Step3 '2011-11-24', @TableToUpdate = 'common_product_rate'
--EXEC usp_CreateProductRate_Step3 '2011-11-24', @ReplaceHistory = 1
CREATE PROCEDURE usp_CreateProductRate_Step3 (
	@EffDate DATETIME
  , @TableToUpdate VARCHAR(100) = 'product_rate_history'
  , @ReplaceHistory INT = 0
  )
AS

DECLARE @MarketID		int,
		@UtilityID		int,
		@ProductID		varchar(20),
		@DueDate		datetime

SET	@DueDate = dateadd(mi,-1,dateadd(dd,1,@EffDate))

-- We make a copy of the temp_product_rate and remove records if the option of ReplaceHistory is set to 0.
IF EXISTS (SELECT * FROM sys.tables WHERE [name] = 'temp_product_rate2')
	DROP TABLE LibertyPower..temp_product_rate2

SELECT *
INTO temp_product_rate2
FROM temp_product_rate

IF @ReplaceHistory = 0
BEGIN
	DELETE FROM t2
	FROM temp_product_rate2 t2
	JOIN lp_common..product_rate_history ph (NOLOCK) ON ph.product_id = t2.product_id and ph.rate_id = t2.rate_id and ph.eff_date = t2.eff_date
END







---- Loop starts here.
DECLARE CurrUtility CURSOR FOR
SELECT	DISTINCT m.ID, u.ID
FROM Utility u
JOIN Market m ON u.MarketID = m.ID
ORDER BY m.ID

OPEN CurrUtility
FETCH NEXT FROM CurrUtility INTO @MarketID, @UtilityID

WHILE (@@FETCH_STATUS <> -1)
BEGIN

	print 'processing market id ' + convert(varchar(6), @MarketId)
	print 'processing utility id ' + convert(varchar(6), @UtilityId)

	IF @TableToUpdate = 'product_rate_history'
	BEGIN
		IF @ReplaceHistory = 1
		BEGIN
			DELETE FROM h
			FROM lp_common..product_rate_history h
			JOIN lp_common..common_product p ON h.product_id = p.product_id
			JOIN libertypower..utility u ON p.utility_id = u.utilitycode
			WHERE p.iscustom = 0
			AND u.ID = @UtilityId
			AND eff_date = @EffDate
		END
		
		INSERT INTO lp_common..product_rate_history (
				product_id					-- char(20)
				,rate_id					-- int
				,rate						-- float
				,eff_date					-- datetime
				,date_created				-- datetime
				,username					-- nchar(200)
				,contract_eff_start_date	-- datetime
				,GrossMargin				-- decimal
				,term_months				-- int
				,inactive_ind)				-- char(1)
		SELECT distinct pr.product_id 
			,pr.rate_id
			,pr.rate
			,pr.eff_date
			,pr.date_created
			,pr.username
			,pr.contract_eff_start_date
			,pr.GrossMargin
			,pr.term_months
			,pr.inactive_ind
		FROM temp_product_rate2 pr
		JOIN lp_common..common_product p ON pr.product_id = p.product_id
		JOIN libertypower..utility u ON p.utility_id = u.utilitycode
		WHERE u.ID = @UtilityId
	END
	ELSE IF @TableToUpdate = 'common_product_rate'
	BEGIN
		UPDATE pr
		SET rate = t.rate
			, contract_eff_start_date = t.contract_eff_start_date
			, GrossMargin = t.GrossMargin
			, term_months = t.term_months
			, eff_date = @EffDate
			, due_date = @DueDate
			, inactive_ind = 0
		FROM lp_common..common_product_rate pr
		JOIN temp_product_rate t on pr.product_id = t.product_id AND pr.rate_id = t.rate_id
		JOIN lp_common..common_product p ON pr.product_id = p.product_id
		JOIN libertypower..utility u ON p.utility_id = u.utilitycode
		WHERE u.ID = @UtilityId
		--AND pr.eff_date = @EffDate
		--AND inactive_ind <> 
	END


	FETCH NEXT FROM CurrUtility INTO @MarketID, @UtilityId
END
CLOSE CurrUtility
DEALLOCATE CurrUtility


print 'copying into production -  may the lord bless us all ' 
