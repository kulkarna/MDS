USE LibertyPower
GO

BEGIN TRANSACTION;
BEGIN TRY

    DECLARE @ZipUITable TABLE(zipCode VARCHAR(5))	
    DECLARE @ZoneIDForUI int = 58;
    DECLARE @maxID int ;
    
    delete from libertypower..ZIP where UtilityID=46 and ZoneID=58;

    INSERT INTO @ZipUITable VALUES('06484'),
    ('06455'),('06880'),('06607'),('06614'),('06468'),('06883'),('06512'),('06451'),
    ('06492'),('06460'),('06518'),('06461'),('06471'),('06510'),('06472'),('06525'),
    ('06825'),('06606'),('06824'),('06401'),('06470'),('06519'),('06515'),('06437'),
    ('06608'),('06483'),('06615'),('06513'),('06896'),('06517'),('06611'),('06610'),
    ('06478'),('06890'),('06450'),('06516'),('06828'),('06477'),('06604'),('06473'),
    ('06514'),('06524'),('06405'),('06422'),('06418'),('06410'),('06612'),('06605'),
    ('06511'),
	--Additional Zip Codes.
	('06601'),('06602'),('06650'),('06673'),('06699'),('06501'),('06502'),
	('06503'),('06504'),('06505'),('06506'),('06507'),('06508'),('06509'),('06520'),
	('06521'),('06530'),('06531'),('06532'),('06533'),('06534'),('06535'),('06536'),
	('06537'),('06538'),('06540');

    SELECT * INTO #zipNotAvailable from @ZipUITable;
    

   

    Select top 1 [ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] into #FinalUIDetails from ZIP;
if exists (SELECT * from #zipNotAvailable where zipCode='06405')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06405',41.27999115,-72.81064606,'CT','BRANFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06410')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06410',41.50547409,-72.90812683,'CT','CHESHIRE',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06422')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06422',41.46495056,-72.68752289,'CT','DURHAM',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06437')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06437',41.31536865,-72.6967926,'CT','GUILFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06450')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06450',41.53339767,-72.79973602,'CT','MERIDEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06451')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06451',41.53720093,-72.82019806,'CT','MERIDEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06455')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06455',41.51678848,-72.7186203,'CT','MIDDLEFIELD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06468')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06468',41.33116913,-73.22433472,'CT','MONROE',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06470')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06470',41.39309311,-73.31674194,'CT','NEWTOWN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06478')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06478',41.42023849,-73.12960815,'CT','OXFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06483')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06483',41.38620758,-73.08174133,'CT','SEYMOUR',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06524')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06524',41.42619324,-73.0007019,'CT','BETHANY',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06880')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06880',41.14343262,-73.34957886,'CT','WESTPORT',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06883')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06883',41.21949768,-73.37147522,'CT','WESTON',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06896')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06896',41.30691528,-73.39350128,'CT','REDDING',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06401')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06401',41.3427124,-73.07421112,'CT','ANSONIA',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06418')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06418',41.3228569,-73.08003235,'CT','DERBY',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06460')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06460',41.21746445,-73.0549469,'CT','MILFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06461')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06461',41.23897171,-73.06413269,'CT','MILFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06471')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06471',41.32798386,-72.77603149,'CT','NORTH BRANFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06472')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06472',41.39621735,-72.78090668,'CT','NORTHFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06473')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06473',41.38215637,-72.85852051,'CT','NORTH HAVEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06477')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06477',41.28152847,-73.02872467,'CT','ORANGE',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06484')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06484',41.3046875,-73.12944031,'CT','SHELTON',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06492')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06492',41.45999527,-72.8221817,'CT','WALLINGFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06492')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06492',41.45999527,-72.8221817,'CT','WALLINGFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06510')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06510',41.30870056,-72.92706299,'CT','NEW HAVEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06511')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06511',41.31836319,-72.93177032,'CT','NEW HAVEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06512')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06512',41.28052139,-72.87414551,'CT','EAST HAVEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06513')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06513',41.31421661,-72.8825531,'CT','NEW HAVEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06514')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06514',41.36198807,-72.93612671,'CT','HAMDEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06515')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06515',41.32929993,-72.96644592,'CT','NEW HAVEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06516')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06516',41.27008057,-72.9638443,'CT','WEST HAVEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06517')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06517',41.34839249,-72.9116745,'CT','HAMDEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06518')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06518',41.40966415,-72.91100311,'CT','HAMDEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06519')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06519',41.29628372,-72.93730927,'CT','NEW HAVEN',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06525')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06525',41.35166931,-73.01390076,'CT','WOODBRIDGE',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06604')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06604',41.17957306,-73.20185852,'CT','BRIDGEPORT',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06605')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06605',41.16679764,-73.21624756,'CT','BRIDGEPORT',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06606')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06606',41.2090683,-73.20861816,'CT','BRIDGEPORT',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06607')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06607',41.17838287,-73.16504669,'CT','BRIDGEPORT',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06608')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06608',41.18946457,-73.18114471,'CT','BRIDGEPORT',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06610')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06610',41.20050812,-73.16876984,'CT','BRIDGEPORT',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06611')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06611',41.25640869,-73.21105957,'CT','TRUMBULL',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06612')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06612',41.25232697,-73.28710938,'CT','EASTON',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06614')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06614',41.22290039,-73.1312027,'CT','STRATFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06615')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06615',41.1772995,-73.13459778,'CT','STRATFORD',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06890')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06890',41.13639069,-73.28388977,'CT','SOUTHPORT',3,46,58,'NULL');
if exists (SELECT * from #zipNotAvailable where zipCode='06825')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06825',41.196335,-73.244392,'CT','Fairfield',3,46,58,'Fairfield');
if exists (SELECT * from #zipNotAvailable where zipCode='06824')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06824',41.17451,-73.284305,'CT','Fairfield',3,46,58,'Fairfield');
if exists (SELECT * from #zipNotAvailable where zipCode='06828')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06828',41.221616,-73.250735,'CT','Fairfield',3,46,58,'Fairfield');
if exists (SELECT * from #zipNotAvailable where zipCode='06601')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06601',41.1800621,-73.1883898,'CT','BRIDGEPORT',3,46,58,'Fairfield');
if exists (SELECT * from #zipNotAvailable where zipCode='06602')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06602',41.1800362,-73.18824619999999,'CT','BRIDGEPORT',3,46,58,'Fairfield');
if exists (SELECT * from #zipNotAvailable where zipCode='06650')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06650',41.16999999999999,-73.2099999,'CT','BRIDGEPORT',3,46,58,'Fairfield');
if exists (SELECT * from #zipNotAvailable where zipCode='06673')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06673',41.1826405,-73.14604849999999,'CT','BRIDGEPORT',3,46,58,'Fairfield');
if exists (SELECT * from #zipNotAvailable where zipCode='06699')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06699',41.1791791,-73.191707,'CT','BRIDGEPORT',3,46,58,'Fairfield');
if exists (SELECT * from #zipNotAvailable where zipCode='06501')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06501',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06502')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06502',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06503')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06503',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06504')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06504',41.3043344,-72.9368786,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06505')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06505',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06506')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06506',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06507')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06507',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06508')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06508',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06509')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06509',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06520')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06520',41.3065186,-72.9310714,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06521')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06521',41.31,-72.92999999999999,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06530')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06530',41.3,-72.92,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06531')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06531',41.3,-72.92,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06532')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06532',41.3,-72.92,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06533')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06533',41.3,-72.92,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06534')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06534',41.3,-72.92,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06535')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06535',41.3,-72.92,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06536')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06536',41.3,-72.92,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06537')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06537',41.2989425,-72.9189708,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06538')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06538',41.2989425,-72.9189708,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');
if exists (SELECT * from #zipNotAvailable where zipCode='06540')
   Insert into #FinalUIDetails ([ZipCode],[Latitude],[Longitude],[State],[City],[MarketID],[UtilityID],[ZoneID],[County] )
   values('06540',41.2989425,-72.9189708,'CT','NEW HAVEN',3,46,58,'NEW HAVEN');

   
    
    

    select * from #FinalUIDetails;

    if exists (SELECT * from #FinalUIDetails)
	  Insert into Zip ([ZipCode]
	   ,[Latitude]
	   ,[Longitude]
	   ,[State]
	   ,[City]
	   ,[MarketID]
	   ,[UtilityID]
	   ,[ZoneID]
	   ,[County] )
	  select  [ZipCode]
	   ,[Latitude]
	   ,[Longitude]
	   ,[State]
	   ,[City]
	   ,[MarketID]
	   ,[UtilityID]
	   ,[ZoneID]
	   ,[County] 
    from #FinalUIDetails;
    
     

    Drop table #zipNotAvailable;  
    drop table #FinalUIDetails;
    
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
GO
--###################################
--Select ZipCode from Zip where ZipCode in(06825,06824,06828)
--Select * from Price with (nolock) where ZoneID=58
--Select * from Zip z where z.UtilityID=46
--SELECT * into ZIPBACKUP from ZIP;
/*
drop table Zip;
SELECT * into ZIP from ZIPBACKUP;
*/
