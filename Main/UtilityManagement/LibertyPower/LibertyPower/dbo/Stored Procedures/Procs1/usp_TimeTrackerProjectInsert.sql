

CREATE PROCEDURE [dbo].[usp_TimeTrackerProjectInsert] 
	@ApplicationID int, 
	@LegacyID varchar(40),
	@Name varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ProjectID int

	-- Check if Task already exists
	-- There are 2 possibilities why it could already exist.
	-- 1) A different user has logged hours for the same project 
	--    -> in this case current user will have no entries in TimeTrackerEntries
    -- 2) Current user has saved this project but has not made TimeSheet entries 
	SELECT @ProjectID = ID FROM TimeTrackerProject
		WHERE ApplicationID = @ApplicationID AND LegacyID = @LegacyID

	IF @ProjectID IS NULL
	BEGIN
		INSERT INTO TimeTrackerProject
		(ApplicationID, LegacyID, [Name])
		VALUES 
		 (@ApplicationID, @LegacyID, @Name)
	
		SET @ProjectID = (SELECT SCOPE_IDENTITY())

	END

	SELECT @ProjectID

	SET NOCOUNT OFF;

END

