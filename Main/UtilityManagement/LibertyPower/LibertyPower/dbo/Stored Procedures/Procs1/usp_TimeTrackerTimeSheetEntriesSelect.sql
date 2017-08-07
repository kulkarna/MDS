




CREATE PROCEDURE [dbo].[usp_TimeTrackerTimeSheetEntriesSelect]
	@EmployeeID int,
	@StartDate datetime,
	@EndDate datetime,
	@ApplicationID int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TimeTrackerProject.ApplicationID
			,TimeTrackerProject.ID AS ProjectID
			,TimeTrackerProject.LegacyID AS LegacyProjectID
			,TimeTrackerProject.Name AS ProjectName
		    ,TimeTrackerProject.HasHistoryEntries AS HasProjectHistoryEntries
			,TimeTrackerTask.ID AS TaskID
			,TimeTrackerTask.LegacyID AS LegacyTaskID
			,TimeTrackerTask.Name AS TaskName
		    ,TimeTrackerTask.HasHistoryEntries AS HasTaskHistoryEntries
			,TimeTrackerTimeEntry.ID AS TimeSheetEntryID
			,TimeTrackerTimeEntry.LegacyID AS LegacyTimeSheetEntryID
			,TimeTrackerTimeEntry.ExecutedDate
			,TimeTrackerTimeEntry.WorkedHours
			,TimeTrackerTimeEntry.Comments
	FROM TimeTrackerProject WITH (NOLOCK) 
		INNER JOIN TimeTrackerTask WITH (NOLOCK) ON TimeTrackerProject.ID = TimeTrackerTask.ProjectID 
		INNER JOIN TimeTrackerTimeEntry WITH (NOLOCK) ON TimeTrackerTask.ID = TimeTrackerTimeEntry.TaskID
	WHERE ApplicationID = @ApplicationID 
		AND TimeTrackerTimeEntry.EmployeeID = @EmployeeID
		  AND (TimeTrackerTimeEntry.ExecutedDate BETWEEN @StartDate AND @EndDate)

	SET NOCOUNT OFF;

END





