--USE [OnlineEnrollment]
--GO


/****** Object:  StoredProcedure [dbo].[usp_GetAvailableStartDates]    Script Date: 10/21/2013 10:59:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--	Author:		Satchidannada Jena
--	Create date: 07/19/2013
--	Description:	This procedure is used to fetch price for online enrollment based on below criterias
--	costRateEffectiveDate ,startDate ,channelID,utilityId,marketID ,SegmentID,serviceClassID,channelTypeID,
--	CostRateExpirationDate,zoneID,zipCode,priceTierId
-- =============================================
/**

-- TEST CASES:

DECLARE @contractSignedDate DATETIME, @startDate DATETIME, @channelID INT,@utilityId INT,@marketID INT, @SegmentID INT = 2, @serviceClassID INT = -1, 
	@channelTypeID INT = 2, @zipCode VARCHAR (5), @priceTierId INT ;
	
set @contractSignedDate=  null; --'7/18/2013' ;
set @startDate ='8/1/2013';
set @channelID =1163;
set @utilityId =18;
set @marketID =7;
set @SegmentID =2;
set @serviceClassID =-1;
set @channelTypeID =2;
set @zipCode = '10003';

EXEC [usp_GetPrices] @contractSignedDate, @startDate,@channelID, @utilityId,  @marketID, @SegmentID, 
		@serviceClassID, @channelTypeID,@zipCode; 



*/

ALTER PROCEDURE [dbo].[usp_GetAvailableStartDates]
(
-- Add the parameters for the stored procedure here
	--@contractSignedDate DATETIME,
	@channelID INT,
	@utilityId INT,
	@marketID INT,
	@SegmentID INT = 2, -- SMB
	@serviceClassID INT = -1, -- DEFAULT Service class
	@channelTypeID INT = 2,
	@zipCode VARCHAR (5),
	@priceTierId INT = NULL
)
AS
BEGIN
	DECLARE @contractSignedDate DATETIME;
	DECLARE @zoneID int;
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    --set @costRateEffectiveDate= '7/18/2013' ;
    --set @startDate ='8/1/2013';
    --set @channelID =1163;
    --set @utilityId =18;
    --set @marketID =7;
    --set @SegmentID =2;
    --set @serviceClassID =-1;
    --set @channelTypeID =2;
    --set @CostRateExpirationDate ='7/18/2013';
    --set @zipCode = '10003';
    
    --Selects the Zone Id based on the zipcode.
    
    --IF @contractSignedDate IS NULL
		SET @contractSignedDate = GETDATE();
    
  --   IF @startDate = '2013-09-01'
		--SET @startDate = '2013-10-01';
   
    
    
    SELECT @zoneID = ZoneID
    FROM   Zipcode
    WHERE  ZipCode.UtilityID = @utilityId
           AND ZipCode.ZipCode = @zipCode;
           
    DECLARE @UtililityGRT  decimal(12,5);      
    SELECT @UtililityGRT = COALESCE(u.PriceComparison,0)
    FROM Utility u WITH (NOLOCK)
    WHERE u.UtilityID = @utilityId       

    --Selects the resultset for all pricetiers.
    SELECT   DISTINCT p.PriceID,
                      p.Term,
                      ZoneID,
                      p.PriceTier,
                      MIN(p.Price) AS minPrice,
                      pb.Name,
                      dpt.MaxMwh, pb.Description,
                      PriceToCompare = (@UtililityGRT * p.Price) + p.Price
    INTO     #tempPrice
    FROM     Price AS p WITH (NOLOCK)
             JOIN ProductBrand AS pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
             JOIN DailyPricingPriceTier AS dpt WITH (NOLOCK) ON p.PriceTier = dpt.PriceTierID
    WHERE	 pb.Active=1	 --pb.ProductBrandID IN (1, 2)
			 AND @contractSignedDate BETWEEN p.CostRateEffectiveDate AND p.CostRateExpirationDate
             --AND p.StartDate = @startDate
             AND p.ChannelID = @channelID
             AND p.UtilityID = @utilityId
             AND p.MarketID = @marketID
             AND p.SegmentID = @SegmentID
             AND p.ChannelTypeID = @ChannelTypeID
             AND p.ZoneID = @zoneID
             --AND p.ServiceClassID = @serviceClassID
             AND ((p.SegmentID=2 and p.ServiceClassID=-1) or p.SegmentID<>2)
             
    GROUP BY pb.Name, p.Term, p.ZoneID, p.PriceID, p.PriceTier, dpt.MaxMwh,pb.Description,p.Price;
    
    
    
    IF @priceTierId IS NULL
        --selects the price tier having min range of consumption
        SELECT   TOP 1 @priceTierId = tp.PriceTier
        FROM     #tempPrice tp
        ORDER BY tp.MaxMwh ASC;
        
        
    --select * from #tempPrice;    
	--select @priceTierId;
    print 'Price Tier :' + Cast(@priceTierId as varchar(5));
    
    SELECT	*,
			Price as Price1, 
			#tempPrice.Name, 
			#tempPrice.Description as ProductDescription,
			#tempPrice.PriceToCompare as PriceToCompare	
    FROM   Price WITH (NOLOCK)    
    JOIN #tempPrice on price.PriceID = #tempPrice.PriceID AND price.PriceTier = @priceTierId
    WHERE price.StartDate > GETDATE()
    order by #tempPrice.Name DESC, dbo.Price.Term ASC
    ;
    DROP TABLE #tempPrice;
END


  