


CREATE PROCEDURE [dbo].[usp_TimeTrackerEmployeeSelect]
	@WindowsLogon varchar(100) 
AS
BEGIN
	SET NOCOUNT ON;

    -- Get Employee by WindowsLogon
	SELECT  ID As EmployeeID
			,WindowsLogon
		    ,ProjectServerGuid
			,ServiceDeskID
			,WebTimeSheetID
	FROM TimeTrackerEmployee WITH (NOLOCK) 
	WHERE WindowsLogon = @WindowsLogon

	SET NOCOUNT OFF;

END



