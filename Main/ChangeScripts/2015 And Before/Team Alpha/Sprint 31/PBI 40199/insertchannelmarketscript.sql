	Begin TRY
	Begin tran
--start of bae channel

	DECLARE @market INT,@PARTNERMARKETID INT,@partnerid INT;
	
--if channel name bae does not exist then insert into lk_partner table

	if not exists(select * from LK_Partner where PartnerName='BAE')
	INSERT INTO [Genie].[dbo].[LK_Partner]
           ([PartnerName]
           ,[PartnerDescription]
           ,[MarginLimit]
           ,[EmailAddress]
           ,[EnableTemplateType])
     VALUES
           ('BAE'
           ,'Best Alternative Energy'
           ,0.0000
           ,'bestalternativeenergy@gmail.com'
           ,0)
           
    
    SET @partnerid=(select PartnerID from LK_Partner where PartnerName='BAE')
    SET @PARTNERMARKETID=(select MAX(PartnerMarketID) FROM LK_PartnerMarket)
    
    SET @market=(SELECT [MarketID]
	FROM [Genie].[dbo].[LK_Market] where MarketCode='NJ')
 --if this market nj is not present for channel bae then insert this market for channel bae
  
   if not exists(select * from LK_PartnerMarket where PartnerID=@partnerid and MarketID=@market)
   INSERT INTO [Genie].[dbo].[LK_PartnerMarket]
           ([PartnerMarketID]
           ,[PartnerID]
           ,[MarketID])
     VALUES
           (@PARTNERMARKETID+1,@partnerid,@market)
           
  SET @PARTNERMARKETID=(select MAX(PartnerMarketID) FROM LK_PartnerMarket)
  SET @market=(SELECT  [MarketID]
  FROM [Genie].[dbo].[LK_Market] where MarketCode='NY')
  
 --if this market ny is not present for channel bae then insert this market for channel bae
 
  if not exists(select * from LK_PartnerMarket where PartnerID=@partnerid and MarketID=@market)
   INSERT INTO [Genie].[dbo].[LK_PartnerMarket]
           ([PartnerMarketID]
           ,[PartnerID]
           ,[MarketID])
     VALUES
           (@PARTNERMARKETID+1,@partnerid,@market)
  -- end of BAE Channel
 
 --start of fin channel
 
 --if channel name fin does not exist then insert into lk_partner table
 
    if not exists(select * from LK_Partner where PartnerName='FIN')
	INSERT INTO [Genie].[dbo].[LK_Partner]
           ([PartnerName]
           ,[PartnerDescription]
           ,[MarginLimit]
           ,[EmailAddress]
           ,[EnableTemplateType])
     VALUES
           ('FIN'
           ,'Fauma Innovative Incorporated'
           ,0.0000
           ,'fauma@faumainc.com'
           ,0)
     SET @partnerid=(select PartnerID from LK_Partner where PartnerName='FIN')
	 SET @PARTNERMARKETID=(select MAX(PartnerMarketID) FROM LK_PartnerMarket)
    
    SET @market=(SELECT [MarketID]
	FROM [Genie].[dbo].[LK_Market] where MarketCode='NY')
	
   --if this market ny is not present for channel fin then insert this market for channel fin
   
   if not exists(select * from LK_PartnerMarket where PartnerID=@partnerid and MarketID=@market)
   INSERT INTO [Genie].[dbo].[LK_PartnerMarket]
           ([PartnerMarketID]
           ,[PartnerID]
           ,[MarketID])
     VALUES
           (@PARTNERMARKETID+1,@partnerid,@market)
           
    --end of fin channel
    
    --begin of eag channel
    
    --if channel name eag does not exist then insert into lk_partner table
    
    if not exists(select * from LK_Partner where PartnerName='EAG')
	INSERT INTO [Genie].[dbo].[LK_Partner]
           ([PartnerName]
           ,[PartnerDescription]
           ,[MarginLimit]
           ,[EmailAddress]
           ,[EnableTemplateType])
     VALUES
           ('EAG'
           ,'Energy Acquisitions Group LLC'
           ,0.0000
           ,'eagcareers@gmail.com'
           ,0)
    SET @partnerid=(select PartnerID from LK_Partner where PartnerName='EAG')
    SET @PARTNERMARKETID=(select MAX(PartnerMarketID) FROM LK_PartnerMarket)
    
    SET @market=(SELECT [MarketID]
	FROM [Genie].[dbo].[LK_Market] where MarketCode='PA')
	
   --if this market pa is not present for channel eag then insert this market for channel eag
   
   if not exists(select * from LK_PartnerMarket where PartnerID=@partnerid and MarketID=@market)
   INSERT INTO [Genie].[dbo].[LK_PartnerMarket]
           ([PartnerMarketID]
           ,[PartnerID]
           ,[MarketID])
     VALUES
           (@PARTNERMARKETID+1,@partnerid,@market)
           
    --end of eag channel
    
    --begin of agrd channel
    
    --if channel name agrd does not exist then insert into lk_partner table
           
    if not exists(select * from LK_Partner where PartnerName='AGRD')
	INSERT INTO [Genie].[dbo].[LK_Partner]
           ([PartnerName]
           ,[PartnerDescription]
           ,[MarginLimit]
           ,[EmailAddress]
           ,[EnableTemplateType])
     VALUES
           ('AGRD'
           ,'AGR, LLC'
           ,0.0000
           ,'mmiller@agrgroupinc.com'
           ,0)
     
     SET @partnerid=(select PartnerID from LK_Partner where PartnerName='AGRD')
	 SET @PARTNERMARKETID=(select MAX(PartnerMarketID) FROM LK_PartnerMarket)
    
    SET @market=(SELECT [MarketID]
    FROM [Genie].[dbo].[LK_Market] where MarketCode='MD')
    
   --if this market md is not present for channel agrd then insert this market for channel agrd
   
   if not exists(select * from LK_PartnerMarket where PartnerID=@partnerid and MarketID=@market)
   INSERT INTO [Genie].[dbo].[LK_PartnerMarket]
           ([PartnerMarketID]
           ,[PartnerID]
           ,[MarketID])
     VALUES
           (@PARTNERMARKETID+1,@partnerid,@market)
           
    --end of agrd channel
    
    --begin of usd channel
    
    --if channel name usd does not exist then insert into lk_partner table
    
    if not exists(select * from LK_Partner where PartnerName='USD')
	INSERT INTO [Genie].[dbo].[LK_Partner]
           ([PartnerName]
           ,[PartnerDescription]
           ,[MarginLimit]
           ,[EmailAddress]
           ,[EnableTemplateType])
     VALUES
           ('USD'
           ,'US Direct Marketing'
           ,0.0000
           ,'lpagreements@usdirectmarketingcorp.com'
           ,0)
           
    SET @partnerid=(select PartnerID from LK_Partner where PartnerName='USD')
    SET @PARTNERMARKETID=(select MAX(PartnerMarketID) FROM LK_PartnerMarket)
    
    SET @market=(SELECT [MarketID]
    FROM [Genie].[dbo].[LK_Market] where MarketCode='NY')
    
   --if this market ny is not present for channel usd then insert this market for channel usd
   
   if not exists(select * from LK_PartnerMarket where PartnerID=@partnerid and MarketID=@market)
   INSERT INTO [Genie].[dbo].[LK_PartnerMarket]
           ([PartnerMarketID]
           ,[PartnerID]
           ,[MarketID])
     VALUES
           (@PARTNERMARKETID+1,@partnerid,@market)
           
    --end of usd channel
    
    --begin of nfg channel
    
    --if channel name nfg does not exist then insert into lk_partner table  
        
    if not exists(select * from LK_Partner where PartnerName='NFG')
	INSERT INTO [Genie].[dbo].[LK_Partner]
           ([PartnerName]
           ,[PartnerDescription]
           ,[MarginLimit]
           ,[EmailAddress]
           ,[EnableTemplateType])
     VALUES
           ('NFG'
           ,'NFG Marketing'
           ,0.0000
           ,'kfan1911@gmail.com'
           ,0)
	SET @partnerid=(select PartnerID from LK_Partner where PartnerName='NFG')
    SET @PARTNERMARKETID=(select MAX(PartnerMarketID) FROM LK_PartnerMarket)
    
    SET @market=(SELECT [MarketID]
	FROM [Genie].[dbo].[LK_Market] where MarketCode='NJ')
	
   --if this market nj is not present for channel nfg then insert this market for channel nfg
   
   if not exists(select * from LK_PartnerMarket where PartnerID=@partnerid and MarketID=@market)
   INSERT INTO [Genie].[dbo].[LK_PartnerMarket]
           ([PartnerMarketID]
           ,[PartnerID]
           ,[MarketID])
     VALUES
           (@PARTNERMARKETID+1,@partnerid,@market)
   
   SET @PARTNERMARKETID=(select MAX(PartnerMarketID) FROM LK_PartnerMarket)
  SET @market=(SELECT  [MarketID]
  FROM [Genie].[dbo].[LK_Market] where MarketCode='PA')
  
   --if this market pa is not present for channel nfg then insert this market for channel nfg
   
  if not exists(select * from LK_PartnerMarket where PartnerID=@partnerid and MarketID=@market)
   INSERT INTO [Genie].[dbo].[LK_PartnerMarket]
           ([PartnerMarketID]
           ,[PartnerID]
           ,[MarketID])
     VALUES
           (@PARTNERMARKETID+1,@partnerid,@market)        
   --end of nfg channel
           
	COMMIT tran -- Transaction Success!
	END TRY
	BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK TRAN --RollBack in case of Error

    -- you can Raise ERROR with RAISEERROR() Statement including the details of the exception
    --RAISERROR(ERROR_MESSAGE(''), ERROR_SEVERITY(''), 1)
	END CATCH





