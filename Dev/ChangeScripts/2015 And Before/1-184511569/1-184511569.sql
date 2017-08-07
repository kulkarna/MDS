---- Account '677340141000036'
--select top 10 *
--from lp_common..common_product_rate
--where  rate = 0.10405 and product_id = 'CONED_MT_IP'    --Couldnt not find Rates


declare @RateID int
SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)
-------------------------------------------------------------------
-- Account '08043464590001192977'
insert into lp_common..common_product_rate 
values('PENELEC_MT_IP',@RateID,'2013-07-25',0.06610,'(TEL) 2 Month PENELEC Default: 51-100 MWh','3000-01-01',365,'2013-08-01 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',-1,92,'2013-09-03 15:43:27.870','1972','0','2013-07-25 15:43:27.870',0,2,0,7.500000,' ',0)

SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)

insert into lp_common..common_product_rate 
values('PENELEC_MT_IP',@RateID,'2013-07-25',0.0751,'(TEL) 10 Month PENELEC Default: 51-100 MWh','3000-01-01',365,'2013-10-01 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',-1,92,'2013-09-03 15:43:27.870','1972','0','2013-07-25 15:43:27.870',0,10,0,7.500000,' ',0)

------------------------------------------------------------------
-- Account '677340141000036'

--update libertypower..AccountContractRate
--SET LegacyProductID = 'CONED_MT_IP' , RateID = 240363854
--where AccountContractRateID in (978651)

SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)

insert into lp_common..common_product_rate 
values('CONED_MT_IP',@RateID,'2013-07-18',0.12168,'(TEL) 10 Month J SC2: 0-25 MWh','3000-01-01 00:00:00.000',365,'2013-10-01 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',1,3,'2013-09-03 18:22:11.260','1972','0','2013-07-24 18:22:11.260',0,10,0,5.833330,' ',0)

--------------------------------------------------------------------
--- Account '701270038000064'
SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)

insert into lp_common..common_product_rate 
values('CONED_MT_IP',@RateID,'2013-07-23 00:00:00.000',0.08947,'(TEL) 2 Month J SC9: 51-100 MWh','3000-01-01 00:00:00.000',365,'2013-08-23 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',2,3,'2013-07-23 19:20:14.800','1972','0','2013-07-23 19:20:14.800',0,2,0,9.395830,' ',0)

SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)

insert into lp_common..common_product_rate 
values('CONED_MT_IP',@RateID,'2013-07-23 00:00:00.000',0.09972,'(TEL) 22 Month J SC9: 51-100 MWh','3000-01-01 00:00:00.000',365,'2013-10-23 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',2,3,'2013-07-23 19:20:14.800','1972','0','2013-07-23 19:20:14.800',0,22,0,9.395830,' ',0)

----------------------------------------------------------------------
--  Account '677011135000023'
SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)

insert into lp_common..common_product_rate 
values('CONED_MT_IP',@RateID,'2013-07-23 00:00:00.000',0.09005,'(TEL) 2 Month J SC9: 51-100 MWh','3000-01-01 00:00:00.000',365,'2013-08-01 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',2,3,'2013-09-03 19:20:14.800','1972','0','2013-07-23 19:20:14.800',0,2,0,0.000000,' ',0)

SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)

insert into lp_common..common_product_rate 
values('CONED_MT_IP',@RateID,'2013-07-23 00:00:00.000',0.10405,'(TEL) 22 Month J SC9: 51-100 MWh','3000-01-01 00:00:00.000',365,'2013-10-23 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',2,3,'2013-09-03 19:20:14.800','1972','0','2013-07-23 19:20:14.800',0,22,0,0.000000,' ',0)

-------------------------------------------------------------------------
--- Account '08001217880001166207'

SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)

insert into lp_common..common_product_rate 
values('PENELEC_MT_IP',@RateID,'2013-07-24 00:00:00.000',0.06609,'(TEL) 2 Month PENELEC Default: 0-25 MWh','3000-01-01 00:00:00.000',365,'2013-08-01 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',-1,92,'2013-09-03 19:20:14.800','1972','0','2013-07-23 19:20:14.800',0,2,0,0.000000,' ',0)

SET @RateID = 1 + (select MAX(rate_id) from lp_common..common_product_rate)

insert into lp_common..common_product_rate 
values('PENELEC_MT_IP',@RateID,'2013-07-24 00:00:00.000',0.07509,'(TEL) 10 Month PENELEC Default: 0-25 MWh','3000-01-01 00:00:00.000',365,'2013-10-01 00:00:00.000','NONE',' ','NONE','NONE',' ','NONE',-1,92,'2013-09-03 19:20:14.800','1972','0','2013-07-23 19:20:14.800',0,10,0,0.000000,' ',0)

----------------------------------------------------------------------------
--- Account '08001217880006551704'
--- Rates Same as above so not required

----------------------------------------------------------------------------
--- Account '08043183640001164368'
--- Rates Same as above so not required
----------------------------------------------------------------------------
--- Account '08037312330001067968'
--- Rates Same as above so not required
----------------------------------------------------------------------------

