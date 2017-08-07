
CREATE PROC [dbo].[usp_ReasonCodeInsert] 
( @Step			int
, @Code			varchar(50)
, @Description	varchar(100)
, @Order		int
)
AS 
BEGIN 

	INSERT INTO [LibertyPower].[dbo].[ReasonCodeList]
           ([Step]
           ,[Code]
           ,[Description]
           ,[Order]
           ,[DateCreated]
           )
     VALUES
           (  @Step			
			, @Code	
			, @Description	
			, @Order
			, getdate()
           )
END 

