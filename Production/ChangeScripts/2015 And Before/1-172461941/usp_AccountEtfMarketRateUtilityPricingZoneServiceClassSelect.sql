USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountEtfMarketRateUtilityPricingZoneServiceClassSelect]    Script Date: 08/09/2013 10:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********

 * 7/27/2011 - Eric Hernandez

 * Found an account with a service class that is not longer priced, for this reason 

 * code was changed to look for an exact match first, then if that fails, to use closest match.

 *********/

 /*********
 * 8/9/2013 -  Sadiel Jarvis (updated SP per ticket SR1-172461941)

 * 1.- Encapsulated query returning the rate into a function "ufn_ClosesRateToDropMonthIndicator". To be able to use it more than once passing different terms.
 * 2.- If Term is not found, then nearest lower and higher terms are obtained and their corresponding rates. These rates are averaged and final result returned.
	   If Term is found, then previous logic is reused. Rate corresponding to this term is obtained and returned.

 *********/

ALTER PROCEDURE [dbo].[usp_AccountEtfMarketRateUtilityPricingZoneServiceClassSelect] 

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

	--**  SR1-172461941  BEGIN **--
	DECLARE @LowerTerm int
	DECLARE @HigherTerm int
	DECLARE @LowerTermRate float
	DECLARE @HigherTermRate float

	EXEC usp_GetBoundaryApplicableTerms @Term,@EffectiveDate,@EffectiveDateStart,@RetailMarket,@Utility,@AccountType, @LowerApplicableTerm = @LowerTerm output, @HigherApplicableTerm = @HigherTerm output

	IF @Term = @LowerTerm
	-- This means the term was found
		BEGIN
			SET @LowerTermRate = dbo.ufn_ClosesRateToDropMonthIndicator(@Zone,@EffectiveDate,@EffectiveDateStart,@RetailMarket,	@Utility,
											@Term,@AccountType,	@DropMonthIndicator)

			SELECT @LowerTermRate
		END
	ELSE
	-- The term was not found. Nearest lower and higher terms need to be obtained and their corresponding rates. Their average will be returned..
		BEGIN 
			SET @LowerTermRate = dbo.ufn_ClosesRateToDropMonthIndicator(@Zone,@EffectiveDate,@EffectiveDateStart,@RetailMarket,	@Utility,
											@LowerTerm,@AccountType,	@DropMonthIndicator)
			
		
			SET @HigherTermRate = dbo.ufn_ClosesRateToDropMonthIndicator(@Zone,@EffectiveDate,@EffectiveDateStart,@RetailMarket,	@Utility,
											@HigherTerm,@AccountType,	@DropMonthIndicator)

			SELECT (@HigherTermRate + @LowerTermRate) / 2
			
			
		END

	--**  SR1-172461941 END  **--

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










