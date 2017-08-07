
CREATE PROCEDURE [dbo].[usp_ReasonCodeCheckListSelect]
(@Step              int
,@CheckListID		int)
AS
BEGIN
	SELECT rccl.ReasonCodeID, rcl.Description
	FROM  ReasonCodeCheckList rccl
	INNER JOIN ReasonCodeList rcl ON rccl.ReasonCodeID = rcl.ReasonCodeID
	WHERE rccl.Step			= @Step
	AND	  rccl.CheckListID	= @CheckListID
	ORDER BY rcl.[Order]
END