USE GENIE
GO
--UPDATE LK_AccountType 
--SMB
UPDATE  LK_AccountType set LPAccountTypeID = 2 where AccountTypeID=1
--RESIDENTIAL
UPDATE  LK_AccountType set LPAccountTypeID = 3 where AccountTypeID=2
--SOHO
UPDATE  LK_AccountType set LPAccountTypeID = 4 where AccountTypeID=4
