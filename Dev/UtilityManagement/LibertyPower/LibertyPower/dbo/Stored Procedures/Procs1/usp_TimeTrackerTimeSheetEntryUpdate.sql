


CREATE PROCEDURE [dbo].[usp_TimeTrackerTimeSheetEntryUpdate] 
	@ID int
	,@LegacyID varchar(40)
	,@WorkedHours decimal(4,2)
	,@Comments varchar(max)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [TimeTrackerTimeEntry]
	SET LegacyID = @LegacyID
		,[WorkedHours] = @WorkedHours
		,[Comments] = @Comments
	WHERE [ID] = @ID

	SET NOCOUNT OFF;

END



