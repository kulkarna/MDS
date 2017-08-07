
CREATE PROCEDURE [dbo].[usp_TimeTrackerTaskDelete] 
	@ID int 
AS
BEGIN
	SET NOCOUNT ON;

	--Will cascade to delete time entries and task history entries as well
	DELETE FROM [TimeTrackerTask]
      WHERE [ID] = @ID

	SET NOCOUNT OFF;

END

