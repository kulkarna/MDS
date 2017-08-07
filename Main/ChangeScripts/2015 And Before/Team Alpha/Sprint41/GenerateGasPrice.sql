USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GenerateGasPrice]    Script Date: 10/07/2014 10:18:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name 
= 'usp_GenerateGasPrice' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_GenerateGasPrice;
GO
CREATE PROC [dbo].[usp_GenerateGasPrice](
@DefaultProductCrossPriceSetId INT = NULL,
@TestSimulation BIT = 1
)
as	
begin
Set NOCOUNT ON

/*
Date			 User			Description
10/02/2014	 Satchi Jena		Created Script for generating the prices for natural gas.


EXEC LibertyPower.dbo.[usp_GenerateGasPrice] NULL, 1

*/

BEGIN TRAN

	BEGIN TRY
		declare @channelId int = 1263
		declare @channelGroupId int = 4
		declare @channelTypeId int = 2
		declare @maxProductCrossPriceSet int
		declare @dateExpiration datetime
		declare @productTypeId int =1
		declare @marketId int =7
		declare @segmentId int =3 --RES-3,SMB-2,LCI-1,SOHO-4
		declare @zoneId  int =14
		declare @serviceClassID int =-1
		declare @startDate datetime = '11/01/2014'
		declare @costRateEffectiveDate datetime
		declare @costRateExpirationDate datetime
		declare @isTermRange tinyint = 0	
		declare @priceTier tinyint = 0
		declare @productBrandId int	
		declare @grossMargin int = 0	 
		SELECT * into #AllowedUtilities  from Utility where 
		 ID in(14,18); -- ALLOWED Account Types,ADD more if needed
		SELECT * into #AllowedSegmentList  from AccountType where 
		 ID in(3,2); -- ALLOWED Account Types,ADD more if needed
		
		print  'Start Time :' + convert(varchar, GETDATE(),121)

		--Make sure that the below code executes only if there is a product brand Fixed Gas.
		IF Exists (Select 1 from ProductBrand WITH(NOLOCK) where Name='FIXED GAS')
		BEGIN  
		    set @productBrandId = (Select ProductBrandID from ProductBrand WITH(NOLOCK) where Name='FIXED GAS');			
		    
			SELECT  top 1 @maxProductCrossPriceSet = ProductCrossPriceSetID ,
					@costRateEffectiveDate=EffectiveDate,@costRateExpirationDate=ExpirationDate
					from Libertypower..ProductCrossPriceSet WITH (NOLOCK) Order by ProductCrossPriceSetID Desc;
		    
			IF @DefaultProductCrossPriceSetId IS NULL
			BEGIN
			    SET @DefaultProductCrossPriceSetId = @maxProductCrossPriceSet;
		    END	

		    --Get the Structure of the Pricing Table
		    Select [ChannelID],[ChannelGroupID],[ChannelTypeID],[ProductCrossPriceSetID],[ProductTypeID]
		    ,[MarketID],[UtilityID],[SegmentID],[ZoneID],[ServiceClassID],[StartDate],[Term]
		    ,[Price],[CostRateEffectiveDate],[CostRateExpirationDate],[IsTermRange],[DateCreated]
		    ,[PriceTier],[ProductBrandID],[GrossMargin],[ProductCrossPriceID] 
		    into #tempPrice from libertypower..Price WITH (NOLOCK) where 1=2;
		        		
		    INSERT INTO #tempPrice
		    ([ChannelID],[ChannelGroupID],[ChannelTypeID],[ProductCrossPriceSetID],[ProductTypeID]
		    ,[MarketID],[UtilityID],[SegmentID],[ZoneID],[ServiceClassID],[StartDate],[Term]
		    ,[Price],[CostRateEffectiveDate],[CostRateExpirationDate],[IsTermRange],[DateCreated]
		    ,[PriceTier],[ProductBrandID],[GrossMargin],[ProductCrossPriceID])
		    VALUES
		    (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 3,0.959,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 6,0.959,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 12,0.929,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 24,0.919,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 36,0.919,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 3,0.749,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 6,0.749,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 12,0.679,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 24,0.679,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 36,0.779,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null)

		    Select z.zone_id,u.ID into #zoneDetails from Lp_common..zone z WITH (NOLOCK) 
		    Join libertypower..Utility u WITH (NOLOCK) on U.UtilityCode = z.utility_id
		    where u.ID in (select distinct(UtilityID) from #tempPrice t)
    		
		    UPDATE #tempPrice set ZoneID = (select top 1 zone_id from #zoneDetails zd WITH (NOLOCK) where zd.ID=UtilityID)
    		
		    Select * into #tempData from #tempPrice WITH (NOLOCK);
		    DELETE FROM #tempPrice;
    		
		    DECLARE @tempSegmentId int;
		    DECLARE MY_CURSOR CURSOR 		
		    LOCAL STATIC READ_ONLY FORWARD_ONLY
		    FOR 
		    SELECT DISTINCT id from #AllowedSegmentList ;
		    OPEN MY_CURSOR
		    FETCH NEXT FROM MY_CURSOR INTO @tempSegmentId
		    WHILE @@FETCH_STATUS = 0
		    BEGIN 
			   --Do something with Id here				
			   PRINT @tempSegmentId		    
			   UPDATE #tempData set SegmentID=@tempSegmentId;		   
			   INSERT INTO #tempPrice SELECT * from #tempData WITH (NOLOCK);		    		    
			   FETCH NEXT FROM MY_CURSOR INTO @tempSegmentId
		    END
		    CLOSE MY_CURSOR
		    DEALLOCATE MY_CURSOR
		    DROP TABLE #tempData;
    		
		    IF @TestSimulation = 1
		    BEGIN 
			    PRINT 'This is a simulation';
			    SELECT * FROM #AllowedUtilities 
			    SELECT * FROM #AllowedSegmentList;
			    select * from #zoneDetails;
			    --SELECT * FROM #ChannelList;
			    --SELECT * FROM #MarketList;
			    SELECT * FROM #tempPrice; 
			    --SELECT #tempPrice.*,#AllowedSegmentList.ID as SEGMENT_ID from #tempPrice cross join #AllowedSegmentList;
		    END
		    -- ================================================================================
		    -- INSERTS NEW Prices 
		    -- ================================================================================
		    IF @TestSimulation = 0 
		    BEGIN 
			    IF NOT EXISTS (SELECT * from Price P with(nolock) where 
			    p.ChannelID = @channelId and 
			    p.ProductCrossPriceSetID=@maxProductCrossPriceSet and 
			    p.UtilityID in (Select ID from #AllowedUtilities) and 
				p.ProductBrandID = @productBrandId)
			    BEGIN
				    print 'Inserting Prices....'
				    INSERT INTO Price SELECT * from #tempPrice WITH (NOLOCK);    			 
			    END
				--ELSE
				--BEGIN
				--	 print 'Updating Prices....'
				--	UPDATE Price set CostRateEffectiveDate=@costRateEffectiveDate , CostRateExpirationDate=@costRateExpirationDate
				--	where ChannelID = @channelId and ProductCrossPriceSetID=@maxProductCrossPriceSet and UtilityID in (Select ID from #AllowedUtilities)
				--END
		    END
		    print  'End Time :' + convert(varchar, GETDATE(),121)
	   END
	END TRY

BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;
IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;    
Set NOCOUNT OFF

END





