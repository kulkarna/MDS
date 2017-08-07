USE Libertypower
Go 

IF EXISTS(Select 1 from LetterSchedule ls (nolock) where ls.DocumentTypeID=33 and ls.MarketID=8)
    BEGIN 
	   Update LetterSchedule set DaysBeforeContractEnd=30 where DocumentTypeID=33 and MarketID=8
    END
ELSE
    BEGIN
	   INSERT INTO [LibertyPower].[dbo].[LetterSchedule]
		    ([MarketID]
		    ,[DocumentTypeID]
		    ,[DaysBeforeContractEnd]) Values (8,33,30)
    END
    
IF EXISTS(Select 1 from LetterSchedule ls (nolock) where ls.DocumentTypeID=34 and ls.MarketID=8)
    BEGIN 
	   Update LetterSchedule set DaysBeforeContractEnd=30 where DocumentTypeID=34 and MarketID=8
    END
ELSE
    BEGIN
	   INSERT INTO [LibertyPower].[dbo].[LetterSchedule]
		    ([MarketID]
		    ,[DocumentTypeID]
		    ,[DaysBeforeContractEnd]) Values (8,34,30)
    END
--Select * from LetterSchedule  where MarketID=8 and DocumentTypeID in(33,34)