
/*******************************************************************************
 * usp_AccountEventHistoryInsert
 * Insert account event record
 *
 * History
 *******************************************************************************
 * 4/8/2009 - Rick Deigsler
 * Created.
 *
 * 5/5/2010 - Rick Deigsler
 * Added is numeric check on @AccountId to ensure legacy account id gets inserted
 *******************************************************************************
  * 11/6/2012 - Rick Deigsler
 * Added weighted average for gross margin function
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountEventHistoryInsert]                                                                                    
	@ContractNumber			char(12),
	@AccountId				char(12),
	@ProductId				char(20),
	@RateID					int,
	@Rate					decimal(18,6),
	@RateEndDate			datetime,
	@EventID				int,
	@EventEffectiveDate		datetime,
	@ContractType			varchar(50),
	@ContractDate			datetime,
	@ContractEndDate		datetime,
	@DateFlowStart			datetime,
	@Term					smallint,
	@AnnualUsage			int,
	@GrossMarginValue		decimal(18,6),
	@AnnualGrossProfit		decimal(18,4),
	@TermGrossProfit		decimal(18,4),
	@AnnualGrossProfitAdj	decimal(18,4),
	@TermGrossProfitAdj		decimal(18,4),
	@AnnualRevenue			decimal(18,4),
	@TermRevenue			decimal(18,4),
	@AnnualRevenueAdj		decimal(18,4),
	@TermRevenueAdj			decimal(18,4),
	@AdditionalGrossMargin	decimal(18,6),	
	@SubmitDate				datetime,
	@DealDate				datetime,
	@SalesChannelId			varchar(100),
	@SalesRep				varchar(100),
	@ProductTypeID			int	= null
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@Id				int,
			@TotalTerm				decimal(13,5),
			@RateWtAvg				decimal(18,6),
			@GrossMarginWtAvg		decimal(13,5),
			@EndDate				datetime
	
	-- 11/25/2009 - unidentified bug for rate change event, temporary workaround
	IF @EventID = 11 OR @EventID = 1 OR @EventID = 2
		BEGIN
			SET @AnnualRevenue = CAST(@AnnualUsage AS decimal(18,4)) * @Rate
		END
	
	-- 5/5/2010 - added to ensure legacy account id gets inserted
	IF ISNUMERIC(@AccountId) = 1
		BEGIN
			SELECT @AccountId = account_id FROM lp_account..account WHERE AccountID = @AccountId
		END
		
	IF @EventID = 1 OR @EventID = 2
		BEGIN
			SELECT	@RateWtAvg			= Rate, 
					@TotalTerm			= Term, 
					@GrossMarginWtAvg	= GrossMargin, 
					@EndDate			= ContractEndDate 
			FROM	dbo.ufn_GetWeightedAverageForGrossMargin (@AccountId)
			
			SET @Rate = CASE WHEN @RateWtAvg = 0 OR @RateWtAvg IS NULL THEN @Rate ELSE @RateWtAvg END
			SET @GrossMarginValue = CASE WHEN @GrossMarginWtAvg = 0 OR @GrossMarginWtAvg IS NULL THEN @GrossMarginValue ELSE @GrossMarginWtAvg END
			SET @Term = CASE WHEN @TotalTerm = 0 OR @TotalTerm IS NULL THEN @Term ELSE @TotalTerm END
			SET @ContractEndDate = CASE WHEN @EndDate IS NULL OR @EndDate < @ContractEndDate THEN @ContractEndDate ELSE @EndDate END
		END 

	INSERT INTO	AccountEventHistory (ContractNumber, AccountId, ProductId, RateID, Rate, 
				RateEndDate, EventID, EventEffectiveDate, ContractType, ContractDate, 
				ContractEndDate, DateFlowStart, Term, AnnualUsage, GrossMarginValue, 
				AnnualGrossProfit, TermGrossProfit, AnnualGrossProfitAdjustment, TermGrossProfitAdjustment,
				AnnualRevenue, TermRevenue, AnnualRevenueAdjustment, TermRevenueAdjustment,
				SubmitDate, DealDate, SalesChannelId, SalesRep, AdditionalGrossMargin, ProductTypeID)
	VALUES		(@ContractNumber, @AccountId, @ProductId, @RateID, @Rate, 
				@RateEndDate, @EventID, @EventEffectiveDate, @ContractType, @ContractDate, 
				@ContractEndDate, @DateFlowStart, @Term, @AnnualUsage, @GrossMarginValue, 
				@AnnualGrossProfit, @TermGrossProfit, @AnnualGrossProfitAdj, @TermGrossProfitAdj,
				@AnnualRevenue, @TermRevenue, @AnnualRevenueAdj, @TermRevenueAdj,
				@SubmitDate, @DealDate, @SalesChannelId, @SalesRep, @AdditionalGrossMargin, @ProductTypeID)

	--SET		@Id = @@IDENTITY

	--SELECT	ID, ContractNumber, AccountId, ProductId, RateID, Rate, 
	--		RateEndDate, EventID, EventEffectiveDate, ContractType, ContractDate, 
	--		ContractEndDate, DateFlowStart, Term, AnnualUsage, GrossMarginValue, 
	--		AnnualGrossProfit, TermGrossProfit, AnnualGrossProfitAdjustment, TermGrossProfitAdjustment,
	--		AnnualRevenue, TermRevenue, AnnualRevenueAdjustment, TermRevenueAdjustment, EventDate,
	--		SubmitDate, DealDate, SalesChannelId, SalesRep, AdditionalGrossMargin
	--FROM	AccountEventHistory WITH (NOLOCK)
	--WHERE	ID = @Id

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

