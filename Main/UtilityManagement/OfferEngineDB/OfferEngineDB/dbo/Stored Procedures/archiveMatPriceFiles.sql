CREATE PROCEDURE [dbo].[archiveMatPriceFiles]

AS
BEGIN
-- copies MatPrice files to the archive
-- mvelasco, Jan 10 2008 

   declare @TIME integer, @OldestDate  DateTime
      
	SET @TIME = (select timing from AD_DATA_SET_TIMING where id = 2 ) 
    SET @OldestDate = (select DATEADD ( m , -@TIME, getdate() ))     
    
   -- PRINT  @TIME         
   -- PRINT  @OldestDate
        
	INSERT INTO OfferEngineArchive..oe_matprice_file
	SELECT *
	FROM oe_matprice_file WHERE 
	CREATION_DATE < @OldestDate    
    
    DELETE 
	FROM oe_matprice_file WHERE 
	CREATION_DATE < @OldestDate  
    

END

