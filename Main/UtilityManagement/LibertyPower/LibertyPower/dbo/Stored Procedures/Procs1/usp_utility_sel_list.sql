
CREATE PROC usp_utility_sel_list
AS 
BEGIN 

	SELECT [ID]
      ,[UtilityCode]
      ,[FullName]
      ,[ShortName]
      ,[MarketID]
     
	FROM [Libertypower].[dbo].[Utility] (NOLOCK) 
  
END 
