CREATE PROCEDURE usp_TimeTrackerTimeSheetEntryDelete 
	@ID int 
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [TimeTrackerTimeEntry]
      WHERE [ID] = @ID

	SET NOCOUNT OFF;

END
