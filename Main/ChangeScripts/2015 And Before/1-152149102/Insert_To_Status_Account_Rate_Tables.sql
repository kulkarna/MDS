Insert into Libertypower..AccountStatus 
values(718778,'05000','10',getdate(),1972,getdate(),160),
(718779,'05000','10',getdate(),1972,getdate(),160)


insert into LibertyPower..AccountContractRate 
Values(718778,'PSEG_FX',24,1000000193,0.0756,'','2013-07-13 00:00:00.000','2015-07-12 00:00:00.000',1,null,null,0.0756,null,null,null,getdate(),1972,getdate(),160,1719695869,null),
(718779,'PSEG_FX',24,1000000193,0.0756,'','2013-07-13 00:00:00.000','2015-07-12 00:00:00.000',1,null,null,0.0756,null,null,null,getdate(),1972,getdate(),160,1719695869,null)


UPDATE Libertypower..Account
 SET CurrentContractID = 482490, CurrentRenewalContractID = 482490
 WHERE AccountID = 530523 and AccountNumber = 'PE000007962441755115'
 
 
UPDATE Libertypower..Account
 SET CurrentContractID = 482490, CurrentRenewalContractID = 482490
 WHERE AccountID = 530524 and AccountNumber = 'PE000009113629155042'
 
 
 

