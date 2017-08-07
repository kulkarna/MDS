
CREATE PROCEDURE [dbo].[usp_TimeTrackerTaskUpdate] 
	@ID int, 
	@Name varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @OldName varchar(100);
	SELECT @OldName = [Name] FROM TimeTrackerTask WHERE ID = @ID

	BEGIN TRY
		BEGIN TRANSACTION

		UPDATE TimeTrackerTask SET [Name] = @Name, HasHistoryEntries = 1 WHERE ID = @ID
		INSERT INTO TimeTrackerTaskHistory (TaskID, [Name]) VALUES (@ID, @OldName)
	
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		 SELECT @ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	  RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

	SET NOCOUNT OFF;
END

