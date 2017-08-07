  
  begin tran 
  UPDATE [Libertypower].[dbo].[LetterSchedule]
  SET DaysBeforeContractEnd = 45
  WHERE MarketID = 1 AND DocumentTypeID = 34