
CREATE PROCEDURE [dbo].[usp_ReasonCodeCheckListClear]
(@Step              int
,@CheckListID		int)
AS
BEGIN
	DELETE
	FROM  ReasonCodeCheckList
	WHERE Step			= @Step
	AND	  CheckListID	= @CheckListID
END