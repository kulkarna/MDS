
CREATE PROC [dbo].[usp_ReasonCodeUpdate]
( 
  @ReasonCodeID	int 
, @Code			varchar(50)
, @Description	varchar(100)
, @Order		int
) 
AS 
BEGIN 
	UPDATE ReasonCodeList
	   SET [Code] = @Code, [Description] = @Description, [Order] = @Order
	 WHERE ReasonCodeID  = @ReasonCodeID
END 

