/*******************************************************************************
 * usp_PriceDuplication
 * For duplicating prices for a different effective date.
 *
 * @DateToDuplicate - Effective date you want to pull prices from.
 * @EffectiveDate - Date you want prices for.
 *
 * NOTE -	To duplicate Monday prices for a given @EffectiveDate, 
 *			you need to use a @DateToDuplicate date of preceding Saturday.
 *
 * History
 *******************************************************************************
 * 6/27/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceDuplication]
	@DateToDuplicate	datetime,
	@EffectiveDate		datetime
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE	@ProductCrossPriceSetID		int,
			@WorkflowQueueHeaderID		int,
			@ExpirationDate				datetime,
			@Today						datetime,
			@DayOfWeek					int,
			@Count						int,
			@IsWorkDay					tinyint
			
	SET		@Today						= GETDATE()
	SET		@DayOfWeek					= DATEPART ( dw , @EffectiveDate )			
			
	SELECT	@WorkflowQueueHeaderID = h.ID, @IsWorkDay = IsWorkDay
	FROM	LibertyPower..DailyPricingWorkflowQueueHeader h WITH (NOLOCK)
			INNER JOIN LibertyPower..DailyPricingCalendar c WITH (NOLOCK)
			ON h.DailyPricingCalendarIdentity = c.ID
	WHERE	@EffectiveDate BETWEEN EffectiveDate AND ExpirationDate	
	
	IF @WorkflowQueueHeaderID IS NOT NULL
		BEGIN
			-- if effective date is not a workday (holiday, etc.), find next workday
			IF @IsWorkDay = 0
				BEGIN
					SELECT	@WorkflowQueueHeaderID = h.ID, @EffectiveDate = h.EffectiveDate
					FROM	LibertyPower..DailyPricingWorkflowQueueHeader h WITH (NOLOCK)
							INNER JOIN LibertyPower..DailyPricingCalendar c WITH (NOLOCK)
							ON h.DailyPricingCalendarIdentity = c.ID
							INNER JOIN
							(
								SELECT	MIN(h.ID) AS ID
								FROM	LibertyPower..DailyPricingWorkflowQueueHeader h WITH (NOLOCK)
										INNER JOIN LibertyPower..DailyPricingCalendar c WITH (NOLOCK)
										ON h.DailyPricingCalendarIdentity = c.ID
								WHERE	h.ID > @WorkflowQueueHeaderID
								AND		c.IsWorkDay = 1
							)z ON h.ID = z.ID
				END
						
			-- make expiration date end of same day as effective date
			SET		@ExpirationDate	= DATEADD(ss, 59, DATEADD(mi, 59, DATEADD(hh, 23, @EffectiveDate)))

			PRINT 'Getting prices for ' + CAST(@DateToDuplicate AS varchar(50)) + '.'

			SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
			FROM	LibertyPower..Price WITH (NOLOCK)
			WHERE	@DateToDuplicate BETWEEN CostRateEffectiveDate AND CostRateExpirationDate 
			AND		ProductCrossPriceSetID	> 0

			SELECT	ChannelID, ChannelGroupID, ChannelTypeID, ProductCrossPriceSetID, ProductTypeID, MarketID, 
					UtilityID, SegmentID, ZoneID, ServiceClassID, StartDate, Term, Price, CostRateEffectiveDate, 
					CostRateExpirationDate, IsTermRange, DateCreated, PriceTier, ProductBrandID, GrossMargin
			INTO	#Price
			FROM	LibertyPower..Price WITH (NOLOCK)
			WHERE	ProductCrossPriceSetID	= @ProductCrossPriceSetID
			AND		@DateToDuplicate BETWEEN CostRateEffectiveDate AND CostRateExpirationDate 

			SELECT @Count = COUNT(ProductCrossPriceSetID) FROM #Price

			IF @Count = 0
				BEGIN
					PRINT 'No prices were found for ' + CAST(@DateToDuplicate AS varchar(50)) + '. No prices were created.'
				END
			ELSE IF EXISTS 
						(	SELECT	NULL 
							FROM	LibertyPower..Price WITH (NOLOCK) 
							WHERE	CostRateEffectiveDate	= @EffectiveDate
							AND		CostRateExpirationDate	= @ExpirationDate
						)
			BEGIN
				PRINT 'Prices already exist for effective date ' + CAST(@EffectiveDate AS varchar(50)) + '. No prices were duplicated.'
			END
			ELSE
				BEGIN
					PRINT 'Updating effective and expiration dates.'
					
					UPDATE	#Price
					SET		CostRateEffectiveDate	= @EffectiveDate,
							CostRateExpirationDate	= @ExpirationDate,
							DateCreated				= @Today
							
					PRINT 'Inserting prices.'
					
					INSERT INTO	LibertyPower..Price 
							(ChannelID, ChannelGroupID, ChannelTypeID, ProductCrossPriceSetID, ProductTypeID, MarketID, 
							UtilityID, SegmentID, ZoneID, ServiceClassID, StartDate, Term, Price, CostRateEffectiveDate, 
							CostRateExpirationDate, IsTermRange, DateCreated, PriceTier, ProductBrandID, GrossMargin)
					SELECT	ChannelID, ChannelGroupID, ChannelTypeID, ProductCrossPriceSetID, ProductTypeID, MarketID, 
							UtilityID, SegmentID, ZoneID, ServiceClassID, StartDate, Term, Price, CostRateEffectiveDate, 
							CostRateExpirationDate, IsTermRange, DateCreated, PriceTier, ProductBrandID, GrossMargin 
					FROM	#Price
					
					--PRINT 'Reindexing Price table.'
					
					--DBCC	DBREINDEX('Price',' ',90)
					
					IF @WorkflowQueueHeaderID IS NOT NULL
						BEGIN
							PRINT 'Updating Daily Pricing workflow records.'
							
							UPDATE	LibertyPower..DailyPricingWorkflowQueueHeader
							SET		[Status]			= 2
							WHERE	ID					= @WorkflowQueueHeaderID
							
							UPDATE	LibertyPower..DailyPricingWorkflowQueueDetail
							SET		[Status]			= 4
							WHERE	WorkflowHeaderID	= @WorkflowQueueHeaderID					
						END		
					
					PRINT CAST(@Count AS varchar(20)) + ' prices were duplicated using prices from ' + CAST(@DateToDuplicate AS varchar(50)) + ' having an effective date of ' + CAST(@EffectiveDate AS varchar(50)) + ' and an expiration date of ' + CAST(@ExpirationDate AS varchar(50)) + '.'
				END
				
			DROP TABLE #Price    				
		END
	ELSE
		BEGIN
			PRINT 'Workflow record not found for effective date of ' + CAST(@EffectiveDate AS varchar(50)) + '. No prices were created.'
		END

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
