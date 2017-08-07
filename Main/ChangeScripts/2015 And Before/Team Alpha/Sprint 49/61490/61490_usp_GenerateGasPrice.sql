USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GenerateGasPrice]    Script Date: 11/26/2014 13:49:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[usp_GenerateGasPrice](
@DefaultProductCrossPriceSetId INT = NULL,
@TestSimulation BIT = 1
)
as	
begin
Set NOCOUNT ON

/*
Date			 User			Description
10/02/2014	 Satchi Jena		Created Script for generating the prices for natural gas.
10/13/2014   Satchi Jena		Added logic for NJ prices.	
10/23/2014   Satchi Jena		Include TDM Channel.	
10/31/2014   Satchi Jena		Extended the StartDate to 12/01/2014. 
11/05/2014   Satchi Jena      Added Channel NSL
11/26/2014   Satchi Jena      Addeed December and Jan prices. PBI 55826
01/02/2015   Satchi Jena      Addeed New prices for JAN. PBI 55826
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
		declare @marketIdNJ int =9
		declare @segmentId int =3 --RES-3,SMB-2,LCI-1,SOHO-4
		declare @zoneId  int =1
		declare @serviceClassID int =-1
		declare @startDate datetime = '01/01/1900'
		declare @costRateEffectiveDate datetime
		declare @costRateExpirationDate datetime
		declare @isTermRange tinyint = 0	
		declare @priceTier tinyint = 0
		declare @productBrandId int	
		declare @grossMargin int = 0
		declare @allowedStartDate table (StartDate DateTime)	 
		SELECT * into #AllowedUtilities  from Utility with(nolock) where 
			ID in(14,18,38); -- ALLOWED Account Types,ADD more if needed
		select ChannelID  into #AllowedSalesChannels from SalesChannel with(nolock) where 
			channelname in('NFG','YSM','CMG','EG1','UPI','TDM', 'NSL' ) -- ALLOWED Sales Channels.
		SELECT * into #AllowedSegmentList  from AccountType with(nolock) where 
			ID in(3); -- ALLOWED Account Types,ADD more if needed
		insert into @allowedStartDate values ('03/01/2015')
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
			 3,0.709,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 6,0.739,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 12,0.769,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 24,0.789,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,14,@segmentId,@zoneId,@serviceClassID,@startDate,
			 36,0.809,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 3,0.619,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 6,0.699,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 12,0.569,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 24,0.579,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketId,18,@segmentId,@zoneId,@serviceClassID,@startDate,
			 36,0.689,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 /*###########################################
						Insert NJ Prices
			 ###########################################*/
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketIdNJ,38,@segmentId,@zoneId,@serviceClassID,@startDate,
			 3,0.399,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketIdNJ,38,@segmentId,@zoneId,@serviceClassID,@startDate,
			 6,0.399,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketIdNJ,38,@segmentId,@zoneId,@serviceClassID,@startDate,
			 12,0.649,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketIdNJ,38,@segmentId,@zoneId,@serviceClassID,@startDate,
			 24,0.649,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketIdNJ,38,@segmentId,@zoneId,@serviceClassID,@startDate,
			 36,0.669,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null),
			 (@channelId,@channelGroupId,@channelTypeId,@DefaultProductCrossPriceSetId,@productTypeId,
			 @marketIdNJ,38,@segmentId,@zoneId,@serviceClassID,@startDate,
			 60,0.709,@costRateEffectiveDate,@costRateExpirationDate,@isTermRange,GetDate(),
			 @priceTier,@productBrandId,@grossMargin,null)

		    Select z.zone_id,u.ID into #zoneDetails from Lp_common..zone z WITH (NOLOCK) 
		    Join libertypower..Utility u WITH (NOLOCK) on U.UtilityCode = z.utility_id
		    where u.ID in (select distinct(UtilityID) from #tempPrice t  WITH (NOLOCK))
    		
		    UPDATE #tempPrice set ZoneID = (select top 1 zone_id from #zoneDetails zd WITH (NOLOCK) where zd.ID=UtilityID)

    		/*Duplicate all prices for each Segment*/
		    Select * into #tempData from #tempPrice WITH (NOLOCK);
		    DELETE FROM #tempPrice;
    		
		    DECLARE @tempSegmentId int;
		    DECLARE MY_CURSOR CURSOR 		
		    LOCAL STATIC READ_ONLY FORWARD_ONLY
		    FOR 
		    SELECT DISTINCT id from #AllowedSegmentList with(nolock);
		    OPEN MY_CURSOR
		    FETCH NEXT FROM MY_CURSOR INTO @tempSegmentId
		    WHILE @@FETCH_STATUS = 0
		    BEGIN 
			   --Do something with Id here				
			   PRINT 'Segment ID ' + Cast(@tempSegmentId AS VARCHAR (10))		    
			   UPDATE #tempData set SegmentID=@tempSegmentId;		   
			   INSERT INTO #tempPrice SELECT * from #tempData WITH (NOLOCK);		    		    
			   FETCH NEXT FROM MY_CURSOR INTO @tempSegmentId
		    END
		    CLOSE MY_CURSOR
		    DEALLOCATE MY_CURSOR
		    DROP TABLE #tempData;

			/*Duplicate all prices for channel*/
    		Select * into #tempDataChannel from #tempPrice WITH (NOLOCK);
		    DELETE FROM #tempPrice;
    		
		    DECLARE @tempChannelId int;
		    DECLARE MY_CURSOR CURSOR 		
		    LOCAL STATIC READ_ONLY FORWARD_ONLY
		    FOR 
		    SELECT DISTINCT ChannelID from #AllowedSalesChannels with(nolock) ;
		    OPEN MY_CURSOR
		    FETCH NEXT FROM MY_CURSOR INTO @tempChannelId
		    WHILE @@FETCH_STATUS = 0
		    BEGIN 
			   --Do something with Id here				
			   PRINT 'Channel ID ' + CAST(@tempChannelId AS VARCHAR(10))		    
			   UPDATE #tempDataChannel set ChannelID=@tempChannelId;		   
			   INSERT INTO #tempPrice SELECT * from #tempDataChannel WITH (NOLOCK);		    		    
			   FETCH NEXT FROM MY_CURSOR INTO @tempChannelId
		    END
		    CLOSE MY_CURSOR
		    DEALLOCATE MY_CURSOR
		    DROP TABLE #tempDataChannel;

		    --Create duplicate details for each start Date.
		    Select * into #tempStartDatePrice from #tempPrice WITH (NOLOCK);
		    DELETE FROM #tempPrice;		    
		    DECLARE @tempStartDate DateTime;
		    DECLARE MY_CURSOR CURSOR 		
		    LOCAL STATIC READ_ONLY FORWARD_ONLY
		    FOR 
		    SELECT DISTINCT StartDate from @allowedStartDate;
		    OPEN MY_CURSOR
		    FETCH NEXT FROM MY_CURSOR INTO @tempStartDate
		    WHILE @@FETCH_STATUS = 0
		    BEGIN 
			   --Do something with Id here				
			   PRINT 'StartDate ' + CAST(@tempStartDate AS VarChar(10))		    
			   UPDATE #tempStartDatePrice set StartDate=@tempStartDate;		   
			   INSERT INTO #tempPrice SELECT * from #tempStartDatePrice WITH (NOLOCK);		    		    
			   FETCH NEXT FROM MY_CURSOR INTO @tempStartDate
		    END
		    CLOSE MY_CURSOR
		    DEALLOCATE MY_CURSOR
		    DROP TABLE #tempStartDatePrice;


		    IF @TestSimulation = 1
		    BEGIN 
			    PRINT 'This is a simulation';
			    SELECT * FROM #AllowedUtilities with(nolock) 
			    SELECT * FROM #AllowedSegmentList with(nolock);
			    select * from #zoneDetails with(nolock);
			    SELECT * FROM #AllowedSalesChannels with(nolock);
			    --SELECT * FROM #MarketList;
			    SELECT * FROM #tempPrice with(nolock);
			    SELECT * from @allowedStartDate;
			    --SELECT #tempPrice.*,#AllowedSegmentList.ID as SEGMENT_ID from #tempPrice cross join #AllowedSegmentList;
		    END
		    -- ================================================================================
		    -- INSERTS NEW Prices 
		    -- ================================================================================
		    IF @TestSimulation = 0 
		    BEGIN 
			    IF NOT EXISTS (SELECT * from Price P with(nolock) where 
			    p.ChannelID in  (Select ChannelID from #AllowedSalesChannels with(nolock)) and
			    p.ProductCrossPriceSetID=@maxProductCrossPriceSet and 
			    p.UtilityID in (Select ID from #AllowedUtilities with(nolock)) and 
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

GO

Print 'Generating Gas Prices...'
EXEC LibertyPower.dbo.[usp_GenerateGasPrice] NULL, 0
Print 'Generating Gas Prices...Done'

 






