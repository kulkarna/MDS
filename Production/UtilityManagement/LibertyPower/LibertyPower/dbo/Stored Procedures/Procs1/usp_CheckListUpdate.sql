
CREATE PROC [dbo].[usp_CheckListUpdate]
( 
  @CheckListID	int 
, @Status		int
, @Description	nchar(100)
, @Order		int
) 
AS 
BEGIN 
	UPDATE CheckList
	   SET [Status] = @Status,[Description] = @Description, [Order] = @Order
	 WHERE CheckListID  = @CheckListID
END 

