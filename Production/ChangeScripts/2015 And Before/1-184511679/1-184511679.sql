INSERT INTO lp_account.dbo.account_number_history
Values('2010-0090087','2013-08-05', 'PE000010647159244179', 'PE000010647159224959','2013-08-05')


INSERT INTO lp_account.dbo.account_comments
VALUES('2010-0090087', '2013-08-05','MANUAL UPDATE', 'Account number change from PE000010647159244179 to PE000010647159224959','LIBERTYPOWER\BCHOWDARY',0)



update libertypower..Account
SET AccountNumber = 'PE000010647159224959' 
where AccountID = 181301 and AccountNumber = 'PE000010647159244179'