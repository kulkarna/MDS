Use LibertyPower
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sadiel Jarvis
-- Create date: July 30th, 2013
-- Description:	Find rate closest to the DropMonthIndicator
-- =============================================
CREATE FUNCTION ufn_ClosesRateToDropMonthIndicator
(
	@Zone varchar(25),
	@EffectiveDate datetime,
	@EffectiveDateStart datetime,
	@RetailMarket char(2),
	@Utility varchar(20),
	@Term int,
	@AccountType char(3),
	@DropMonthIndicator int
)
RETURNS float
AS
BEGIN
	--Find the rate that is equal to or closest to the DropMonthIndicator
	DECLARE @Result float

	SELECT TOP 1 @Result = Rate FROM

	( 

	   -- Get the top 3 market rates with the lowest drop month indicator 

	   SELECT TOP 3 

			ZoneMatch = case when Zone = substring(@Zone,1,5) then 1 else 0 end

			,ServiceClassMatch = case when ServiceClass = substring(ServiceClass,1,5) then 1 else 0 end

			, *

		FROM [AccountEtfMarketRate] WITH (NOLOCK)

		WHERE 

			([EffectiveDate] = @EffectiveDate or ([EffectiveDate] between @EffectiveDateStart and @EffectiveDate))

			AND [RetailMarket] = @RetailMarket

			AND [Utility] = @Utility

			--AND (@Zone IS NULL OR Zone = substring(@Zone,1,5))

			--AND (@ServiceClass IS NULL OR ServiceClass = substring(@ServiceClass,1,5))

			AND Term = @Term

			AND AccountType = @AccountType

		ORDER BY EffectiveDate desc, DropMonthIndicator ASC, 1 desc, 2 desc ) AS i

	WHERE DropMonthIndicator >= @DropMonthIndicator

	ORDER BY DropMonthIndicator

	RETURN @Result
END
GO

