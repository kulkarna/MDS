
CREATE PROC [dbo].[usp_ReasonCodeCheckListInsert] 
( @Step			int
, @CheckListID	int
, @ReasonCodeID int
)
AS 
BEGIN 

	INSERT INTO [LibertyPower].[dbo].[ReasonCodeCheckList]
           ([Step]
           ,[CheckListID]
           ,[ReasonCodeID]
           ,[DateCreated]
           )
     VALUES
           (  @Step			
			, @CheckListID	
			, @ReasonCodeID	
			, getdate()
           )
END 

