insert into Libertypower..AccountStatus Values(716705,05000,10,getdate(),1972,getdate(),160)

insert into Libertypower..AccountContractRate 
Values(716705,'JCPL_FX',24,1000000074,0.08089,'','2013-07-01','2015-06-01',1,null,null,null,null,null,null,getdate(),1972, getdate(),160,1731825783,null)

Update Libertypower ..Account
  SET CurrentContractID = 482672, CurrentRenewalContractID = 482672  
  where AccountID = 530522 and AccountNumber = '08057095600000883818'