USE [Libertypower]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetWeightedAverageForGrossMargin]    Script Date: 11/07/2012 09:41:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_GetWeightedAverageForGrossMargin]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_GetWeightedAverageForGrossMargin]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetWeightedAverageForGrossMargin]    Script Date: 11/07/2012 09:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_GetWeightedAverageForGrossMargin]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[ufn_GetWeightedAverageForGrossMargin] (@AccountId char(12))
RETURNS @WeightedAverage Table
(
	Rate			decimal(18,6),
	Term			int,
	GrossMargin		decimal(18,6),
	ContractEndDate	datetime
)
AS
BEGIN
	DECLARE	@MtTable TABLE (ID int, ProductCrossPriceID int, StartDate datetime, Term int, MarkupRate decimal(13,5), Price decimal(13,5))

	DECLARE	@PriceID				bigint,
			@ProductCrossPriceID	int,
			@ID						int, 
			@StartDate				datetime, 
			@Term					int, 
			@MarkupRate				decimal(13,5), 
			@Price					decimal(13,5),
			@TotalTerm				decimal(13,5),
			@RateNumerator			decimal(18,6),
			@GrossMarginNumerator	decimal(13,5),
			@RateWtAvg				decimal(18,6),
			@GrossMarginWtAvg		decimal(13,5),
			@ContractEndDate		datetime

	SET @RateWtAvg				= 0
	SET @GrossMarginWtAvg		= 0				
	SET @TotalTerm				= 0
	SET	@RateNumerator			= 0	
	SET	@GrossMarginNumerator	= 0				

	SELECT	DISTINCT @PriceID = r.PriceID
	FROM	Libertypower..Account a WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract c WITH (NOLOCK) ON a.AccountID = c.AccountID
			INNER JOIN Libertypower..AccountContractRate r WITH (NOLOCK) ON c.AccountContractID = r.AccountContractID
	WHERE	a.AccountIdLegacy = @AccountId

	SELECT	@ProductCrossPriceID = ProductCrossPriceID
	FROM	Libertypower..Price
	WHERE	ID = @PriceID

	INSERT	INTO @MtTable
	SELECT	ProductCrossPriceMultiID, ProductCrossPriceID, StartDate, Term, MarkupRate, Price
	FROM	Libertypower..ProductCrossPriceMulti WITH (NOLOCK)
	WHERE	ProductCrossPriceID = @ProductCrossPriceID

	WHILE (SELECT COUNT(ID) FROM @MtTable) > 0
		BEGIN
			SELECT	TOP 1 @ID = ID, @ProductCrossPriceID = ProductCrossPriceID, @StartDate = StartDate, @Term = Term, @MarkupRate = MarkupRate, @Price = Price
			FROM	@MtTable
			ORDER BY StartDate
			
			SET @TotalTerm = @TotalTerm + @Term
			SET @RateNumerator = @RateNumerator + (@Term * @Price)
			SET @GrossMarginNumerator = @GrossMarginNumerator + (@Term * @MarkupRate)
			
			DELETE FROM @MtTable WHERE ID = @ID
		END
	
	IF @TotalTerm > 0
		BEGIN
			SET @RateWtAvg = (@RateNumerator / @TotalTerm)
			SET @GrossMarginWtAvg = (@GrossMarginNumerator / @TotalTerm)
			SET @ContractEndDate = DATEADD(dd, -1, DATEADD(mm, @Term, @StartDate))
		END
	
	INSERT	INTO @WeightedAverage
	SELECT	@RateWtAvg, @TotalTerm, @GrossMarginWtAvg, @ContractEndDate
		
	RETURN
END

' 
END
GO
