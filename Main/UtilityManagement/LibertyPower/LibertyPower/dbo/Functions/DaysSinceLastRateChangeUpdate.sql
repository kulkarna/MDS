


CREATE Function [dbo].[DaysSinceLastRateChangeUpdate]
(
	@AccountNumber varchar(50),
	@ContextDate datetime
)

Returns int

AS

BEGIN
			
	Declare @DateOfLastRateChange datetime
	Declare @DaysSinceLastRateChange int
	
	Set @DateOfLastRateChange = 
	(
		Select 
			Top 1 RC.DateModified 
		From 
			RateChange RC 
		Where 
			RC.AccountNumber = @AccountNumber and
			RC.[Status] = 1
		Order By 
			RC.DateModified Desc
	)
	
	If Not @DateOfLastRateChange Is Null
		Begin
			Set @DaysSinceLastRateChange = (Select DateDiff(Day, @DateOfLastRateChange, @ContextDate))
		End
	Else
		Begin
			Set @DaysSinceLastRateChange = null
		End
	
	Return @DaysSinceLastRateChange

END


