
CREATE PROCEDURE [dbo].[usp_ReasonCodeSelect]
(@Step              int)
AS
BEGIN
	SELECT *
	FROM  ReasonCodeList
	WHERE Step			= @Step
	ORDER BY [Order]
END