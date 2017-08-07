CREATE PROC usp_UserInterfaceFormControl_SELECT_By_UserInterfaceFormId
	@UserInterfaceFormId NVARCHAR(50) 
AS
BEGIN
	SELECT
		UIFC.Id, UIFC.ControlName
	FROM
		dbo.UserInterfaceFormControl (NOLOCK) UIFC
	WHERE
		UIFC.UserInterfaceFormId = @UserInterfaceFormId

END
GO