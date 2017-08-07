USE GENIE
GO
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
if not exists(Select * from sys.all_columns where object_id =  
(select object_id from sys.objects where  name='LK_MARKET') and name='LPMarketID') 
    begin 
	    BEGIN TRAN
		  ALTER TABLE dbo.LK_Market ADD
			  LPMarketID int NULL
		  ALTER TABLE dbo.LK_Market SET (LOCK_ESCALATION = TABLE)
	   COMMIT
    end 
GO

if not exists(Select * from sys.all_columns where object_id =  
(select object_id from sys.objects where  name='LK_UTILITY') and name='LPUtilityID') 
    begin 
	    BEGIN TRAN
		  ALTER TABLE dbo.LK_UTILITY ADD
			  LPUtilityID int NULL
		  ALTER TABLE dbo.LK_UTILITY SET (LOCK_ESCALATION = TABLE)
	   COMMIT
    end 
GO

if not exists(Select * from sys.all_columns where object_id =  
(select object_id from sys.objects where  name='LK_BRAND') and name='LPBrandID') 
    begin 
	    BEGIN TRAN
		  ALTER TABLE dbo.LK_BRAND ADD
			  LPBrandID int NULL
		  ALTER TABLE dbo.LK_BRAND SET (LOCK_ESCALATION = TABLE)
	   COMMIT
    end 
GO

BEGIN TRANSACTION;
BEGIN TRY
--UPDATE LK_AccountType 
--SMB
UPDATE  LK_AccountType set LPAccountTypeID = 2 where AccountTypeID=1
--RESIDENTIAL
UPDATE  LK_AccountType set LPAccountTypeID = 2 where AccountTypeID=2
--SOHO
UPDATE  LK_AccountType set LPAccountTypeID = 2 where AccountTypeID=4

--UPDATE LK_MARKET
UPDATE  LK_Market set LPMarketID = MarketID 
UPDATE  LK_Market set LPMarketID = 16 where MarketID=15

--UPDATE LK_UTILITY
UPDATE  LK_Utility set LPUtilityID = UtilityID 

--UPDATE LK_BRAND
Update LK_BRAND set LPBrandID=10 Where BrandId =1 AND Brand ='BLOCK INDEX'
Update LK_BRAND set LPBrandID=8 Where BrandId =2 AND Brand ='CUSTOM FIXED'
Update LK_BRAND set LPBrandID=11 Where BrandId =3 AND Brand ='CUSTOM FIXED ADDER'
Update LK_BRAND set LPBrandID=15 Where BrandId =4 AND Brand ='CUSTOM HYBRID'
Update LK_BRAND set LPBrandID=9 Where BrandId =5 AND Brand ='CUSTOM INDEX'
Update LK_BRAND set LPBrandID=13 Where BrandId =6 AND Brand ='FREEDOM TO SAVE (ABC)'
Update LK_BRAND set LPBrandID=13 Where BrandId =7 AND Brand ='FREEDOM TO SAVE. (ABC)'
Update LK_BRAND set LPBrandID=1 Where BrandId =8 AND Brand ='HOME INDEPENDENCE (ABC)'
Update LK_BRAND set LPBrandID=14 Where BrandId =9 AND Brand ='HYBRID'
Update LK_BRAND set LPBrandID=1 Where BrandId =10 AND Brand ='INDEPENDENCE PLAN (ABC)'
Update LK_BRAND set LPBrandID=1 Where BrandId =11 AND Brand ='INDEPENDENCE PLAN NOMC (ABC)'
Update LK_BRAND set LPBrandID=1 Where BrandId =12 AND Brand ='INDEPENDENCE PLAN. (ABC)'
Update LK_BRAND set LPBrandID=1 Where BrandId =13 AND Brand ='INDEPENDENCE PLAN. NOMC (ABC)'
Update LK_BRAND set LPBrandID=2 Where BrandId =14 AND Brand ='SUPERSAVER (ABC)'
Update LK_BRAND set LPBrandID=4 Where BrandId =15 AND Brand ='FLEX VARIABLE (ABC)'
Update LK_BRAND set LPBrandID=4 Where BrandId =16 AND Brand ='LIBERTY FLEX (ABC)'
Update LK_BRAND set LPBrandID=3 Where BrandId =17 AND Brand ='VARIABLE'
Update LK_BRAND set LPBrandID=1 Where BrandId =18 AND Brand ='HOME INDEPENDENCE'
Update LK_BRAND set LPBrandID=2 Where BrandId =19 AND Brand ='SUPERSAVER'
Update LK_BRAND set LPBrandID=2 Where BrandId =20 AND Brand ='COMED SUPER SAVER PLAN FIXED'
Update LK_BRAND set LPBrandID=13 Where BrandId =21 AND Brand ='FREEDOM TO SAVE'
Update LK_BRAND set LPBrandID=1 Where BrandId =22 AND Brand ='INDEPENDENCE PLAN'
Update LK_BRAND set LPBrandID=18 Where BrandId =23 AND Brand ='100% Illinois Wind (ABC) '
Update LK_BRAND set LPBrandID=18 Where BrandId =24 AND Brand ='100% Illinois Wind'
Update LK_BRAND set LPBrandID=19 Where BrandId =25 AND Brand ='Fixed Liberty Green Plan 100% Green E '
Update LK_BRAND set LPBrandID=19 Where BrandId =26 AND Brand ='Fixed Liberty Green Plan 100% Green E (ABC)'
Update LK_BRAND set LPBrandID=4 Where BrandId =27 AND Brand ='FLEX VARIABLE'
Update LK_BRAND set LPBrandID=4 Where BrandId =28 AND Brand ='LIBERTY FLEX'
Update LK_BRAND set LPBrandID=23 Where BrandId =29 AND Brand ='100% PA GREEN '
Update LK_BRAND set LPBrandID=23 Where BrandId =30 AND Brand ='FIXED PA GREEN'
Update LK_BRAND set LPBrandID=22 Where BrandId =31 AND Brand ='100% MD GREEN '
Update LK_BRAND set LPBrandID=23 Where BrandId =32 AND Brand ='100% PA GREEN (ABC)'
Update LK_BRAND set LPBrandID=22 Where BrandId =33 AND Brand ='FIXED MD GREEN'
Update LK_BRAND set LPBrandID=22 Where BrandId =34 AND Brand ='100% MD GREEN (ABC)'
Update LK_BRAND set LPBrandID=21 Where BrandId =35 AND Brand ='100% CT GREEN'
Update LK_BRAND set LPBrandID=21 Where BrandId =36 AND Brand ='100% CT GREEN (ABC)'
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
