/*******************************************************************************
 * usp_ProductOffersActiveForDateSelect
 * Gets active product offers for specified date
 *
 * History
 *******************************************************************************
 * 3/20/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductOffersActiveForDateSelect]
	@Date	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE	@OfferActivationID		int,
			@IsActive				tinyint,
			@DateUpdatedActive		datetime,
			@DateUpdatedInactive	datetime,
			@Count					int

	--SET		@Date = convert(datetime, '03/20/2012', 101)

	DECLARE @OaIDs TABLE (OfferActivationID int, IsActive tinyint)
	DECLARE @ProductOffers TABLE (	OfferActivationID int, ProductConfigurationID int, SegmentID int, 
									ChannelTypeID int, ProductTypeID int, ProductName varchar(200), 
									MarketID int, UtilityID int, ZoneID int, ServiceClassID int, 
									Term int, IsActive int, LowerTerm int, UpperTerm int, 
									IsTermRange tinyint, CreatedBy int, DateCreated datetime, 
									RelativeStartMonth int, ProductBrandID int)

	INSERT INTO @OaIDs
	SELECT	o.OfferActivationID, o.IsActive
	FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK)
			ON p.ProductConfigurationID = o.ProductConfigurationID		
	ORDER BY o.OfferActivationID

	WHILE (SELECT COUNT(OfferActivationID) FROM @OaIDs) > 0
		BEGIN
			SET	@DateUpdatedActive		= NULL
			SET	@DateUpdatedInactive	= NULL
			
			SELECT TOP 1 @OfferActivationID = OfferActivationID, @IsActive = IsActive FROM @OaIDs
			
			IF EXISTS (SELECT NULL FROM LibertyPower..OfferActivationHistory WITH (NOLOCK) WHERE OfferActivationID = @OfferActivationID)
				BEGIN
					SELECT @DateUpdatedActive = MAX(DateUpdated) FROM LibertyPower..OfferActivationHistory WITH (NOLOCK) WHERE OfferActivationID = @OfferActivationID AND IsActive = 1 AND DateUpdated <= @Date
					
					IF @DateUpdatedActive IS NOT NULL
						BEGIN
							SELECT @DateUpdatedInactive = MAX(DateUpdated) FROM LibertyPower..OfferActivationHistory WITH (NOLOCK) WHERE OfferActivationID = @OfferActivationID AND IsActive = 0 AND DateUpdated <= @Date
							
							IF @DateUpdatedInactive IS NOT NULL
								BEGIN
									IF @DateUpdatedActive >= @DateUpdatedInactive -- latest update for date is active
										BEGIN
											INSERT INTO @ProductOffers
											SELECT	o.OfferActivationID, p.ProductConfigurationID, p.SegmentID, p.ChannelTypeID, 
													p.ProductTypeID, p.ProductName, p.MarketID, p.UtilityID, p.ZoneID, 
													p.ServiceClassID, o.Term, o.IsActive, o.LowerTerm, o.UpperTerm, p.IsTermRange, 
													p.CreatedBy, p.DateCreated, p.RelativeStartMonth, p.ProductBrandID
											FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
													INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK)
													ON p.ProductConfigurationID = o.ProductConfigurationID		
											WHERE	o.OfferActivationID = @OfferActivationID	
										END			
								END	
							ELSE -- only active record in history
								BEGIN
									INSERT INTO @ProductOffers
									SELECT	o.OfferActivationID, p.ProductConfigurationID, p.SegmentID, p.ChannelTypeID, 
											p.ProductTypeID, p.ProductName, p.MarketID, p.UtilityID, p.ZoneID, 
											p.ServiceClassID, o.Term, o.IsActive, o.LowerTerm, o.UpperTerm, p.IsTermRange, 
											p.CreatedBy, p.DateCreated, p.RelativeStartMonth, p.ProductBrandID
									FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
											INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK)
											ON p.ProductConfigurationID = o.ProductConfigurationID		
									WHERE	o.OfferActivationID = @OfferActivationID								
								END					
						END	
					ELSE IF @IsActive = 1 -- no active record in history, go with current status
						BEGIN
							INSERT INTO @ProductOffers
							SELECT	o.OfferActivationID, p.ProductConfigurationID, p.SegmentID, p.ChannelTypeID, 
									p.ProductTypeID, p.ProductName, p.MarketID, p.UtilityID, p.ZoneID, 
									p.ServiceClassID, o.Term, o.IsActive, o.LowerTerm, o.UpperTerm, p.IsTermRange, 
									p.CreatedBy, p.DateCreated, p.RelativeStartMonth, p.ProductBrandID
							FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
									INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK)
									ON p.ProductConfigurationID = o.ProductConfigurationID		
							WHERE	o.OfferActivationID = @OfferActivationID				
						END	
				END
			ELSE IF @IsActive = 1 -- no record in history, go with current status
				BEGIN
					INSERT INTO @ProductOffers
					SELECT	o.OfferActivationID, p.ProductConfigurationID, p.SegmentID, p.ChannelTypeID, 
							p.ProductTypeID, p.ProductName, p.MarketID, p.UtilityID, p.ZoneID, 
							p.ServiceClassID, o.Term, o.IsActive, o.LowerTerm, o.UpperTerm, p.IsTermRange, 
							p.CreatedBy, p.DateCreated, p.RelativeStartMonth, p.ProductBrandID
					FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
							INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK)
							ON p.ProductConfigurationID = o.ProductConfigurationID		
					WHERE	o.OfferActivationID = @OfferActivationID				
				END
					
			DELETE FROM @OaIDs WHERE OfferActivationID = @OfferActivationID
		END

	SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
			ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
			ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
			CreatedBy, DateCreated, RelativeStartMonth, ProductBrandID
	FROM	@ProductOffers
	ORDER BY OfferActivationID DESC    

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
