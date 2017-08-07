


/*********
 * 7/27/2011 - Eric Hernandez
 * Found an account with a service class that is not longer priced, for this reason 
 * code was changed to look for an exact match first, then if that fails, to use closest match.
 *********/
CREATE PROCEDURE [dbo].[usp_AccountEtfMarketRateUtilityPricingZoneServiceClassSelect] 
	@EffectiveDate datetime,
	@EffectiveDateStart datetime = NULL,
	@RetailMarket char(2),
	@Utility varchar(20),
	@Zone varchar(50) = NULL,
	@ServiceClass varchar(50) = NULL,
	@Term int,
	@DropMonthIndicator int,
	@AccountType char(3)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@EffectiveDateStart IS NULL)
		SET @EffectiveDateStart = dateadd(dd,datediff(dd,0,getdate()),0) -- today's date
		
	
	--Find zone mapping
	DECLARE @MappedZoneID INT
	EXEC @MappedZoneID = usp_ZoneMapper @Utility,@Zone
	SELECT @Zone = z.Zone FROM lp_common..zone z (NOLOCK)
	WHERE zone_id = @MappedZoneID AND @Zone IS NOT NULL -- If no zone was passed in, don't overwrite that value.

	--Find service class mapping
	DECLARE @MappedClassID INT
	EXEC @MappedClassID = usp_ServiceClassMapper @Utility,@ServiceClass
	SELECT @ServiceClass = sc.service_rate_class FROM lp_common..service_rate_class sc (NOLOCK)
	WHERE service_rate_class_id = @MappedClassID AND @ServiceClass IS NOT NULL -- If no class was passed in, don't overwrite that value.

--	SET @ServiceClassMapping = ufn_ServiceClassMapper(@Utility,@ServiceClass)

	
	--Find the rate that is equal to or closest to the DropMonthIndicator
	SELECT TOP 1 [Rate] FROM
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

	SET NOCOUNT OFF;

	/* for troubleshooting
	declare	@EffectiveDate datetime
	declare	@EffectiveDateStart datetime
	declare	@RetailMarket char(2)
	declare	@Utility varchar(20)
	declare	@Zone varchar(5)
	declare	@ServiceClass varchar(5)
	declare	@Term int
	declare	@DropMonthIndicator int
	declare	@AccountType char(3)

	set @EffectiveDate = '2010-09-27'
	set @EffectiveDateStart = '2010-09-21'
	set @RetailMarket = 'MD'
	set @Utility = 'BGE'
	set @Zone = null
	set @ServiceClass = 'G'
	set @Term = 5
	set @DropMonthIndicator = 1
	set @AccountType = 'SMB'
	*/
END






GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfMarketRateUtilityPricingZoneServiceClassSelect';

