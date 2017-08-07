CREATE PROCEDURE [dbo].[archivePricingRequests]

AS
BEGIN
-- copies all pricing request info to the archive
-- mvelasco, Jan 10 2008 

   declare @TIME integer, @OldestDate  DateTime
      
	SET @TIME = (select timing from AD_DATA_SET_TIMING where id = 1 ) 
    SET @OldestDate = (select DATEADD ( m , -@TIME, getdate() ))     
      
   -- just for testing
   --DELETE FROM OfferEngineArchive..oe_pricing_request  
   --DELETE FROM OfferEngineArchive..oe_offer    
   --DELETE FROM OfferEngineArchive..oe_account   
   --DELETE FROM OfferEngineArchive..oe_contracted_offers
   --DELETE FROM OfferEngineArchive..oe_epr_logs  
   --DELETE FROM OfferEngineArchive..oe_offer_accounts    
   --DELETE FROM OfferEngineArchive..oe_offer_flow_dates
   --DELETE FROM OfferEngineArchive..oe_prices
   --DELETE FROM OfferEngineArchive..OE_PRICING_REQUEST_ACCOUNTS
   --DELETE FROM OfferEngineArchive..OE_PRICING_REQUEST_FILES
   --DELETE FROM OfferEngineArchive..oe_pricing_request_offer
   --DELETE FROM OfferEngineArchive..OE_REFRESH_PRICE_REQUEST_LOG
   --DELETE FROM OfferEngineArchive..OE_TERMS_AND_PRICES   
   --DELETE FROM OfferEngineArchive..OE_OFFER_MARKET_PRICES_DETAIL
   -- end of just for testing   
   
   INSERT INTO OfferEngineArchive..oe_pricing_request
	SELECT *
	FROM oe_pricing_request WHERE 
	CREATION_DATE < @OldestDate     
    
    INSERT INTO OfferEngineArchive..oe_contracted_offers
    SELECT co.*
    FROM  oe_pricing_request pr, oe_contracted_offers co WHERE
    co.request_id collate SQL_Latin1_General_CP1_CI_AS = 
    pr.request_id collate SQL_Latin1_General_CP1_CI_AS and
    pr.creation_date < @OldestDate        
       
    INSERT INTO OfferEngineArchive..oe_epr_logs
    SELECT temp.*
    FROM  oe_pricing_request pr, oe_epr_logs temp WHERE
    temp.request_id collate SQL_Latin1_General_CP1_CI_AS = 
    pr.request_id collate SQL_Latin1_General_CP1_CI_AS and
    pr.creation_date < @OldestDate       
    
    INSERT INTO OfferEngineArchive..OE_OFFER_MARKET_PRICES_DETAIL
    SELECT temp.*
    FROM  oe_pricing_request pr, OE_OFFER_MARKET_PRICES_DETAIL temp WHERE
    temp.request_id = pr.request_id and
    pr.creation_date < @OldestDate 
                                      
    INSERT INTO OfferEngineArchive..oe_pricing_request_accounts
    SELECT temp.*
    FROM  oe_pricing_request pr, oe_pricing_request_accounts temp WHERE
    temp.pricing_request_id = pr.request_id and
    pr.creation_date < @OldestDate 
                                               
    INSERT INTO OfferEngineArchive..oe_pricing_request_files
    SELECT temp.*
    FROM  oe_pricing_request pr, oe_pricing_request_files temp WHERE
    temp.request_id = pr.request_id and
    pr.creation_date < @OldestDate 
    
    INSERT INTO OfferEngineArchive..oe_pricing_request_offer
    SELECT temp.*
    FROM  oe_pricing_request pr, oe_pricing_request_offer temp WHERE
    temp.request_id = pr.request_id and
    pr.creation_date < @OldestDate  
                                           
    INSERT INTO OfferEngineArchive..oe_refresh_price_request_log
    SELECT temp.*
    FROM  oe_pricing_request pr, oe_refresh_price_request_log temp WHERE
    temp.request_id = pr.request_id and
    pr.creation_date < @OldestDate  
    
    INSERT INTO OfferEngineArchive..oe_account
    SELECT ac.*
    FROM  oe_pricing_request pr, OE_ACCOUNT ac, OE_PRICING_REQUEST_ACCOUNTS pra WHERE
    ac.account_id = pra.account_id and 
    pra.PRICING_REQUEST_ID = pr.request_id  and
    pr.creation_date < @OldestDate         
            
   INSERT INTO OfferEngineArchive..oe_offer
   SELECT ofr.*
   FROM oe_offer ofr, oe_pricing_request pr, oe_pricing_request_offer pra WHERE
   ofr.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate  
                                          
   INSERT INTO OfferEngineArchive..oe_offer_accounts
   SELECT temp.*
   FROM oe_offer_accounts temp, oe_pricing_request pr, oe_pricing_request_offer pra WHERE
   temp.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate       
   
   INSERT INTO OfferEngineArchive..oe_offer_flow_dates
   SELECT temp.*
   FROM oe_offer_flow_dates temp, oe_pricing_request pr, oe_pricing_request_offer pra WHERE
   temp.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate   
   
   INSERT INTO OfferEngineArchive..oe_prices
   SELECT temp.*
   FROM oe_prices temp, oe_pricing_request pr, oe_pricing_request_offer pra WHERE
   temp.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate    
   
   INSERT INTO OfferEngineArchive..oe_terms_and_prices
   SELECT tp.*
   FROM oe_terms_and_prices tp, oe_pricing_request pr, 
   oe_pricing_request_offer pra, OE_OFFER_FLOW_DATES ofd WHERE
   ofd.flow_start_date_id = tp.flow_start_date_id and
   ofd.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate     
   
   --now delete the copied data
   
   delete from oe_terms_and_prices where terms_and_prices_id in (
   SELECT tp.terms_and_prices_id
   FROM oe_terms_and_prices tp, oe_pricing_request pr, 
   oe_pricing_request_offer pra, OE_OFFER_FLOW_DATES ofd WHERE
   ofd.flow_start_date_id = tp.flow_start_date_id and
   ofd.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate  )
   
   delete from oe_offer_flow_dates where flow_start_date_id in (
   SELECT temp.flow_start_date_id
   FROM oe_offer_flow_dates temp, oe_pricing_request pr, oe_pricing_request_offer pra WHERE
   temp.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate  )        
      
    delete from  oe_pricing_request_accounts where account_id in (
    SELECT temp.account_id
    FROM  oe_pricing_request pr, oe_pricing_request_accounts temp WHERE
    temp.pricing_request_id = pr.request_id and
    pr.creation_date < @OldestDate  )      
    
    delete from  OE_OFFER_MARKET_PRICES_DETAIL where request_id in (
    SELECT temp.request_id
    FROM  oe_pricing_request pr, OE_OFFER_MARKET_PRICES_DETAIL temp WHERE
    temp.request_id = pr.request_id and
    pr.creation_date < @OldestDate  )  
    
   delete from  oe_offer_accounts  where account_id in (
   SELECT temp.account_id
   FROM oe_offer_accounts temp, oe_pricing_request pr, oe_pricing_request_offer pra WHERE
   temp.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate)
   
    delete from  oe_account   where account_id in (
    SELECT ac.account_id
    FROM  oe_pricing_request pr, OE_ACCOUNT ac, OE_PRICING_REQUEST_ACCOUNTS pra WHERE
    ac.account_id = pra.account_id and 
    pra.PRICING_REQUEST_ID collate SQL_Latin1_General_CP1_CI_AS
    = pr.request_id collate SQL_Latin1_General_CP1_CI_AS and
    pr.creation_date < @OldestDate)    
    
    delete from   oe_contracted_offers      where offer_id in (
    SELECT co.offer_id
    FROM  oe_pricing_request pr, oe_contracted_offers co WHERE
    co.request_id collate SQL_Latin1_General_CP1_CI_AS 
    = pr.request_id collate SQL_Latin1_General_CP1_CI_AS and
    pr.creation_date < @OldestDate)    
    
   delete from   oe_prices  where offer_id in (
   SELECT temp.offer_id
   FROM oe_prices temp, oe_pricing_request pr, oe_pricing_request_offer pra WHERE
   temp.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate)       
   
   delete from   oe_offer where offer_id in (
   SELECT ofr.offer_id
   FROM oe_offer ofr, oe_pricing_request pr, oe_pricing_request_offer pra WHERE
   ofr.offer_id = pra.offer_id and pra.request_id = pr.request_id and
   pr.creation_date < @OldestDate)    
   
   delete from   oe_refresh_price_request_log    where request_id in(
    SELECT temp.request_id
    FROM  oe_pricing_request pr, oe_refresh_price_request_log temp WHERE
    temp.request_id collate SQL_Latin1_General_CP1_CI_AS 
    = pr.request_id collate SQL_Latin1_General_CP1_CI_AS and
    pr.creation_date < @OldestDate)      
    
    delete from   oe_epr_logs  where request_id in(
    SELECT temp.request_id
    FROM  oe_pricing_request pr, oe_epr_logs temp WHERE
    temp.request_id collate SQL_Latin1_General_CP1_CI_AS 
    = pr.request_id collate SQL_Latin1_General_CP1_CI_AS and
    pr.creation_date < @OldestDate    )
    
    delete from   oe_pricing_request_files    where request_id in(
    SELECT temp.request_id
    FROM  oe_pricing_request pr, oe_pricing_request_files temp WHERE
    temp.request_id = pr.request_id and
    pr.creation_date < @OldestDate      )
    
    delete from   oe_pricing_request_offer  where request_id in(
    SELECT temp.request_id
    FROM  oe_pricing_request pr, oe_pricing_request_offer temp WHERE
    temp.request_id = pr.request_id and
    pr.creation_date < @OldestDate   )      
    
    delete from   oe_pricing_request  where request_id in(
	SELECT request_id
	FROM oe_pricing_request WHERE 
	CREATION_DATE < @OldestDate   )
   
END

