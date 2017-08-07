


CREATE PROCEDURE [dbo].[usp_TimeTrackerEmployeesSelect]
AS
BEGIN
	SET NOCOUNT ON;

    -- Get Employee by WindowsLogon
	SELECT ID As EmployeeID
			,WindowsLogon
		    ,ProjectServerGuid
			,ServiceDeskID
			,WebTimeSheetID
	FROM TimeTrackerEmployee WITH (NOLOCK) 

	SET NOCOUNT OFF;

END



