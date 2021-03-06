/****** Script for SelectTopNRows command from SSMS  ******/
USE GENIE
GO

  UPDATE GENIE..LK_AccountType
	SET LPAccountTypeID = 2 
	WHERE AccountTypeID = 1;
  
  UPDATE GENIE..LK_AccountType
	SET LPAccountTypeID = 3
	WHERE AccountTypeID = 2;
	
  UPDATE GENIE..LK_AccountType
	SET LPAccountTypeID = 4
	WHERE AccountTypeID = 4;


SELECT TOP 1000 [AccountTypeID]
      ,[AccountType]
      ,[AccountTypeDescription]
      ,[AccountGroup]
      ,[LPAccountTypeID]
  FROM [GENIE].[dbo].[LK_AccountType] WITH (NOLOCK)
  
  Go