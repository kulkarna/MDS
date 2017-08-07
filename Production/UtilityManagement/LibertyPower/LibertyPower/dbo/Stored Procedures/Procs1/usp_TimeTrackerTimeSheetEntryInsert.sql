
CREATE PROCEDURE [dbo].[usp_TimeTrackerTimeSheetEntryInsert] 
	@TaskID int
	,@EmployeeID int
	,@LegacyID varchar(40)
	,@ExecutedDate datetime
	,@WorkedHours decimal(4,2)
	,@Comments varchar(max)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [TimeTrackerTimeEntry]
           ([TaskID]
           ,[EmployeeID]
           ,[LegacyID]
           ,[ExecutedDate]
           ,[WorkedHours]
           ,[Comments])
     VALUES
           (@TaskID
           ,@EmployeeID
           ,@LegacyID
           ,@ExecutedDate
           ,@WorkedHours
           ,@Comments)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END

