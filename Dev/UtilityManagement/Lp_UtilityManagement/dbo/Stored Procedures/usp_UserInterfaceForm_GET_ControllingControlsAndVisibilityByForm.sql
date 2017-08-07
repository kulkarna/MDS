CREATE PROC usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm
	@FormName NVARCHAR(50)
AS
BEGIN

	SELECT 
		UIFCC.ControlName AS ControllingControlName,
		UICVGCV.ControlValueGoverningVisibiltiy AS ControllingControlValue,
		UIFC.ControlName AS VisibilityControlName
	FROM 
		dbo.UserInterfaceForm (NOLOCK) UIF
		INNER JOIN dbo.UserInterfaceFormControl (NOLOCK) UIFC
			ON UIF.Id = UIFC.UserInterfaceFormId
		INNER JOIN dbo.UserInterfaceFormControl (NOLOCK) UIFCC
			ON UIF.Id = UIFCC.UserInterfaceFormId
		INNER JOIN dbo.UserInterfaceControlAndValueGoverningControlVisibility (NOLOCK) UICVGCV
			ON UIF.Id = UICVGCV.UserInterfaceFormId
				AND UIFCC.Id = UICVGCV.UserInterfaceFormControlGoverningVisibilityId
		INNER JOIN dbo.UserInterfaceControlVisibility (NOLOCK) UICV
			ON UIF.Id = UICV.UserInterfaceFormId
				AND UIFC.Id = UICV.UserInterfaceFormControlId
				AND UICVGCV.Id = UICV.UserInterfaceControlAndValueGoverningControlVisibilityId
	WHERE
		UIF.UserInterfaceFormName = @FormName
	ORDER BY
		UIFCC.ControlName,
		UICVGCV.ControlValueGoverningVisibiltiy,
		UIFC.ControlName  

END

GO