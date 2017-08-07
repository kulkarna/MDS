         update libertypower..account
         SET BillingAddressID = 1239961
         where AccountID = 530897 and AccountIdLegacy = '2013-0086465'
         
         
         update libertypower..Customer
         set AddressID = 1239961
         where CustomerID = 518681 and NameID = 1015192 and ContactID = 957634
         
         
         insert into lp_account..account_renewal_address values('2009-0029858','1245710','4000 N BENTSEN PALM DRIVE',' ','MISSION','TX','78574',' ',' ',' ',0)