CREATE PROC usp_UserInterfaceFormControlValues_SELECT_By_UserInterfaceFormControlId
	@UserInterfaceFormControlId NVARCHAR(50) 
AS
BEGIN
	SELECT
		UICVGCV.Id, UICVGCV.ControlValueGoverningVisibiltiy
	FROM
		dbo.UserInterfaceControlAndValueGoverningControlVisibility UICVGCV
	WHERE
		UICVGCV.UserInterfaceFormId = @UserInterfaceFormControlId

END
