
CREATE PROC [dbo].[usp_CheckListInsert] 
( @Step			int
, @AccountType	int
, @Description	varchar(100)
, @Status		int
, @Order		int
)
AS 
BEGIN 

	INSERT INTO [LibertyPower].[dbo].[CheckList]
           ([Step]
           ,[AccountType]
           ,[Description]
           ,[Status]
           ,[Order]
           ,[DateCreated]
           )
     VALUES
           (  @Step			
			, @AccountType	
			, @Description	
			, @Status
			, @Order
			, getdate()
           )
END 

