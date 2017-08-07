

CREATE PROCEDURE [dbo].[usp_TimeTrackerTaskInsert] 
	@ProjectID int, 
	@LegacyID varchar(40),
	@Name varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TaskID int

	-- Check if Task already exists
	-- There are 2 possibilities why it could already exist.
	-- 1) A different user has logged hours for the same task 
	--    -> in this case current user will have no entries in TimeTrackerEntries
    -- 2) Current user has saved this task but has not made TimeSheet entries 
	SELECT @TaskID = ID FROM TimeTrackerTask 
		WHERE ProjectID = @ProjectID AND LegacyID = @LegacyID

	IF @TaskID IS NULL
	BEGIN
		INSERT INTO TimeTrackerTask
		 (ProjectID, LegacyID, [Name])
		VALUES 
		(@ProjectID, @LegacyID, @Name)
	
		SET @TaskID = (SELECT SCOPE_IDENTITY())

	END

	SELECT @TaskID

	SET NOCOUNT OFF;

END

