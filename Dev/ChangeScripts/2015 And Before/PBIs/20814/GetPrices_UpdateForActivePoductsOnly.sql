
--*****NOTE: Change Database to USE your intended target
/*
USE OnlineEnrollment
Go
*/

/****** 
1) This script is to insert ProductBrands offered by Online Enrollment
2) ProductBrand updated for current Active products
3) usp_GetPrices and usp_GetAvailableStartDates are modified to only select prices from Active ProductBrands
  ******/

/* Product Description Text
National Green-e
Offset your energy usage with Liberty Power’s Liberty Green Plan. Power-Up for the Planet with 100% Green-e Energy Certified Renewable Energy Credits (REC). Enjoy price certainty and protect the environment. Up to 60 month terms available.

IL Wind
Offset your electricity usage with Liberty Power’s Liberty Green Illinois Wind Plan. Enjoy energy credits equal to 100% of your electricity usage. With up to 60 month terms available, protect the environment for future generations.
CT Green
Spearhead the Green Revolution with Liberty Power’s Connecticut Green. With terms up to 60 months, you can ensure support for renewable energy production in your region. 

MD Green
Think Global, Act Local. With Liberty Power’s Maryland Green, you can ensure support for renewable energy production in your region. Up to 60 month terms available. 

PA Green
Pennsylvania Green: The key to a greener future. Sign up now for up to 60 months and ensure support for renewable energy production in your region. 


*/


SET IDENTITY_INSERT [dbo].[ProductBrand] ON

--INSERT [dbo].[ProductBrand] ([ProductBrandID], [ProductTypeID], [Name], [IsCustom], [IsDefaultRollover], [RolloverBrandID], [Active], [Username], [DateCreated], [IsMultiTerm]) 
--select 20, 7, N'Custom SmartStep', 1, 0, 3, 1, N'libertypower\rideigsler', CAST(0x0000A1B900801E7C AS DateTime), 1
--WHERE NOT EXISTS (SELECT * 
--FROM [dbo].[ProductBrand] 
--WHERE ProductBrandID = 20) 

INSERT [dbo].[ProductBrand] ([ProductBrandID], [ProductTypeID], [Name], [IsCustom], [IsDefaultRollover], [RolloverBrandID], [Active], [Username], [DateCreated], [IsMultiTerm],[Description]) 
select 21, 8, N'Fixed CT Green', 0, 0, 3, 1, N'libertypower\rideigsler', CAST(0x0000A23700000000 AS DateTime), 0, 'Spearhead the Green Revolution with Liberty Power’s Connecticut Green. With terms up to 60 months, you can ensure support for renewable energy production in your region.'
WHERE NOT EXISTS (SELECT * 
FROM [dbo].[ProductBrand] 
WHERE ProductBrandID = 21) 

INSERT [dbo].[ProductBrand] ([ProductBrandID], [ProductTypeID], [Name], [IsCustom], [IsDefaultRollover], [RolloverBrandID], [Active], [Username], [DateCreated], [IsMultiTerm],[Description]) 
select 22, 8, N'Fixed MD Green', 0, 0, 3, 1, N'libertypower\rideigsler', CAST(0x0000A23700000000 AS DateTime), 0, 'Think Global, Act Local. With Liberty Power’s Maryland Green, you can ensure support for renewable energy production in your region. Up to 60 month terms available.'
WHERE NOT EXISTS (SELECT * 
FROM [dbo].[ProductBrand] 
WHERE ProductBrandID = 22) 


INSERT [dbo].[ProductBrand] ([ProductBrandID], [ProductTypeID], [Name], [IsCustom], [IsDefaultRollover], [RolloverBrandID], [Active], [Username], [DateCreated], [IsMultiTerm],[Description]) 
select 23, 8, N'Fixed PA Green', 0, 0, 3, 1, N'libertypower\rideigsler', CAST(0x0000A23700000000 AS DateTime), 0,'Pennsylvania Green: The key to a greener future. Sign up now for up to 60 months and ensure support for renewable energy production in your region.'
WHERE NOT EXISTS (SELECT * 
FROM [dbo].[ProductBrand] 
WHERE ProductBrandID = 23) 

SET IDENTITY_INSERT [dbo].[ProductBrand] OFF

--Fixed National Green E (THIS ONE IS TOO LONG!!!!!)
UPDATE ProductBrand SET Description = 'Offset your energy usage with Liberty Power’s Liberty Green Plan. Power-Up for the Planet with 100% Green-e Energy Certified Renewable Energy Credits (REC). Enjoy price certainty and protect the environment. Up to 60 month terms available.' 
WHERE ProductBrandID = 19

--Fixed IL Wind Description
UPDATE ProductBrand SET Description = 'Offset your electricity usage with Liberty Power’s Liberty Green Illinois Wind Plan. Enjoy energy credits equal to 100% of your electricity usage. With up to 60 month terms available, protect the environment for future generations.' 
WHERE ProductBrandID = 18

--Fixed CT Green
UPDATE ProductBrand SET Description = 'Spearhead the Green Revolution with Liberty Power’s Connecticut Green. With terms up to 60 months, you can ensure support for renewable energy production in your region.'
WHERE ProductBrandID = 21

--Fixed MD Green
UPDATE ProductBrand SET Description = 'Think Global, Act Local. With Liberty Power’s Maryland Green, you can ensure support for renewable energy production in your region. Up to 60 month terms available.'
WHERE ProductBrandID = 22

--Fixed PA Green
UPDATE ProductBrand SET Description = 'Pennsylvania Green: The key to a greener future. Sign up now for up to 60 months and ensure support for renewable energy production in your region.'
WHERE ProductBrandID = 23

----------------------------------
update ProductBrand set Active = 0 
UPDATE ProductBrand SET Active = 1 WHERE ProductBrandID IN (1, 2, 18, 19, 23)

SELECT * FROM ProductBrand with (nolock) WHERE Active=1
----------------------------------------------------------------------------------




--------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[usp_GetPrices]    Script Date: 10/03/2013 11:09:19 ******/
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

ALTER PROCEDURE [dbo].[usp_GetPrices]
(
-- Add the parameters for the stored procedure here
	@contractSignedDate DATETIME,
	@startDate DATETIME, -- FLow Start Date
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
    
    IF @contractSignedDate IS NULL
		SET @contractSignedDate = GETDATE();
    
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
    WHERE	 pb.Active = 1 --pb.ProductBrandID IN (1, 2)
			 AND @contractSignedDate BETWEEN p.CostRateEffectiveDate AND p.CostRateExpirationDate
             AND p.StartDate = @startDate
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
    order by #tempPrice.Name DESC, dbo.Price.Term ASC
    ;
    DROP TABLE #tempPrice;
END
--//////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////////////////////////////////////////////////
/****** Object:  StoredProcedure [dbo].[usp_GetAvailableStartDates]    Script Date: 10/03/2013 11:11:47 ******/
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
	@contractSignedDate DATETIME,
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
    
    IF @contractSignedDate IS NULL
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


  