/*******************************************************************************
 * usp_InsertEtfRates
 * Inserts ETF rates for specified product cross price set
 *
 * History
 *******************************************************************************
 * 4/22/2013 - Rick Deigsler
 * Created.
 *******************************************************************************/
 
CREATE PROCEDURE [dbo].[usp_InsertEtfRates]
	@ProductCrossPriceSetID	int
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
		
		DECLARE	@ChannelGroupID			int,
				@Count					int,
				@CostRateEffectiveDate	datetime, 
				@RetailMarket			varchar(2), 
				@Utility				varchar(20), 
				@Zone					varchar(5), 
				@ServiceClass			varchar(50), 
				@Term					int, 
				@DropMonthIndicator		int, 
				@AccountType			varchar(3),
				@Rate					decimal(18,10),
				@ID						int,
				@EffectiveDate			datetime,
				@Message				varchar(MAX)
				
		-- will get current price set
		IF @ProductCrossPriceSetID <= 0
			BEGIN
				SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID), @EffectiveDate = MAX(EffectiveDate)
				FROM	ProductCrossPriceSet WITH (NOLOCK)
				WHERE	EffectiveDate < '9999-12-31' 			
			END
		ELSE
			BEGIN
				SELECT	@EffectiveDate = EffectiveDate
				FROM	ProductCrossPriceSet WITH (NOLOCK)
				WHERE	ProductCrossPriceSetID = @ProductCrossPriceSetID		
			END

		IF NOT EXISTS (SELECT TOP 1 EtfMarketRateID FROM AccountEtfMarketRate WITH (NOLOCK) WHERE EffectiveDate = @EffectiveDate)
			BEGIN
				SELECT	@ChannelGroupID = MIN(ChannelGroupID) FROM ProductCrossPrice WITH (NOLOCK) WHERE ProductCrossPriceSetID	= @ProductCrossPriceSetID AND ProductTypeID = 1

				CREATE TABLE #CppTable (CostRateEffectiveDate datetime, MarketID int, UtilityID int, ZoneID int, ServiceClassID int, Term int, 
										StartDate datetime, MarkupRate decimal (18,10), CostRate decimal (18,10), CommissionsRate decimal (18,10), 
										POR decimal (18,10), GRT decimal (18,10), SUT decimal (18,10), SegmentID int)
										
				CREATE TABLE #EtfRawTable (CostRateEffectiveDate datetime, RetailMarket varchar(2), Utility varchar(20), Zone varchar(25),
										ServiceClass varchar(50), Term int, DropMonthIndicator int, Rate float, AccountType varchar(3))
				CREATE CLUSTERED INDEX CIDX ON #EtfRawTable(CostRateEffectiveDate, RetailMarket, Utility, Zone, ServiceClass) -- << LUCA
										
				CREATE TABLE #EtfDistinctTable (ID int IDENTITY(1,1) PRIMARY KEY, CostRateEffectiveDate datetime, RetailMarket varchar(2), Utility varchar(20), Zone varchar(25),
										ServiceClass varchar(50), Term int, DropMonthIndicator int, AccountType varchar(3))
										
				CREATE TABLE #EtfFinalTable (CostRateEffectiveDate datetime, RetailMarket varchar(2), Utility varchar(20), Zone varchar(25),
										ServiceClass varchar(50), Term int, DropMonthIndicator int, Rate float, AccountType varchar(3))														


				INSERT	INTO #CppTable					
				SELECT	CostRateEffectiveDate, MarketID, UtilityID, ZoneID, ServiceClassID, Term, StartDate, 
						MarkupRate, CostRate, CommissionsRate, POR, GRT, SUT, SegmentID
				FROM	ProductCrossPrice WITH (NOLOCK)
				WHERE	ProductCrossPriceSetID	= @ProductCrossPriceSetID
				AND		ProductTypeID			= 1 -- only add "fixed" product types to etf.
				AND		ChannelGroupID			= @ChannelGroupID -- we only need to send the prices for one channel group.
				
				-- CREATE INDEX IDX_CppTable ON #CppTable(MarketID, UtilityID, ZoneID, ServiceClassID, SegmentID) -- << LUCA, no need here, no direct access used 

				INSERT	INTO #EtfRawTable
				SELECT	c.CostRateEffectiveDate, LEFT(m.MarketCode, 2), LEFT(u.UtilityCode, 20), LEFT(z.zone, 5), CASE WHEN s.service_rate_class IS NULL THEN '*' ELSE s.service_rate_class END, c.Term, 
						-- calculate the relative start month by 1st subtracting months then add the product of year difference and 12
						((DATEPART(mm, c.StartDate) - DATEPART(mm, GETDATE())) + ((DATEPART(yyyy, c.StartDate) - DATEPART(yyyy, GETDATE())) * 12)) AS DropMonthIndicator,
						((c.MarkupRate + c.CostRate + c.CommissionsRate + c.POR + c.GRT + c.SUT) / 1000) AS Rate, 
						LEFT(a.AccountType, 3)
				FROM	#CppTable c
						INNER JOIN Libertypower..Market m WITH (NOLOCK) ON c.MarketID = m.ID
						INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON c.UtilityID = u.ID
						INNER JOIN lp_common..zone z WITH (NOLOCK) ON c.ZoneID = z.zone_id
						LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON c.ServiceClassID = s.service_rate_class_id
						INNER JOIN Libertypower..AccountType a WITH (NOLOCK) ON c.SegmentID = a.ID
				order by 1, 2, 3, 4, 5, 6 -- << LUCA
				
						
				INSERT	INTO #EtfDistinctTable	
				SELECT	DISTINCT CostRateEffectiveDate, RetailMarket, Utility, Zone, ServiceClass, Term, DropMonthIndicator, AccountType
				FROM	#EtfRawTable
				order by 	CostRateEffectiveDate, RetailMarket, Utility, Zone, ServiceClass, Term, DropMonthIndicator, AccountType -- << LUCA
					
				SELECT	@Count = COUNT(ID) FROM #EtfDistinctTable			
						
				-- there will be records that will violate table constraint 
				-- so loop through and take max etf rate for each constraint
				WHILE (SELECT COUNT(ID) FROM #EtfDistinctTable) > 0
					BEGIN
						SELECT	TOP 1 
								@ID						= ID,
								@CostRateEffectiveDate	= CostRateEffectiveDate, 
								@RetailMarket			= RetailMarket, 
								@Utility				= Utility, 
								@Zone					= Zone, 
								@ServiceClass			= ServiceClass, 
								@Term					= Term, 
								@DropMonthIndicator		= DropMonthIndicator, 
								@AccountType			= AccountType
						FROM	#EtfDistinctTable
						ORDER by ID 		-- << LUCA
						
						SELECT	@Rate = MAX(Rate)
						FROM	#EtfRawTable
						WHERE	@CostRateEffectiveDate	= CostRateEffectiveDate
						AND		@RetailMarket			= RetailMarket
						AND		@Utility				= Utility
						AND		@Zone					= Zone
						AND		@ServiceClass			= ServiceClass
						AND		@Term					= Term
						AND		@DropMonthIndicator		= DropMonthIndicator
						AND		@AccountType			= AccountType
						
						INSERT	INTO #EtfFinalTable
						SELECT	@CostRateEffectiveDate, @RetailMarket, @Utility, @Zone, @ServiceClass, @Term, 
								@DropMonthIndicator, @Rate, @AccountType
								
						DELETE
						FROM	#EtfDistinctTable
						WHERE	ID = @ID
					END
					
				INSERT	INTO Libertypower..AccountEtfMarketRate
				SELECT	CostRateEffectiveDate, RetailMarket, Utility, Zone, ServiceClass, Term, DropMonthIndicator, Rate, AccountType
				FROM	#EtfFinalTable
				order by CostRateEffectiveDate, RetailMarket, Utility, Zone, ServiceClass, Term, DropMonthIndicator, AccountType -- << LUCA
				
				COMMIT TRAN
						SET @Message = 'ETF Rate Process - Insert succceeded. ' + CAST(@Count AS varchar(20)) + ' records inserted.'	
						EXEC usp_DailyPricingLogInsert_New 3, 5, @Message, NULL, 0	
			END	
		ELSE -- etf records already exist for effective date
			BEGIN
				SET @Message = 'ETF Rate Process - Effective date of ' + CAST(@EffectiveDate AS varchar(50)) + ' already exists. No records inserted.'	
				EXEC usp_DailyPricingLogInsert_New 1, 5, @Message, NULL, 0				
			END	
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Message =  'ETF Rate Process - Error occurred. No records inserted. ' +  ERROR_MESSAGE()
		EXEC usp_DailyPricingLogInsert_New 1, 5, @Message, NULL, 0			
	END CATCH
END
