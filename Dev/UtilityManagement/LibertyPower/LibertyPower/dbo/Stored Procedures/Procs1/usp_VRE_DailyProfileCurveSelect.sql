

CREATE PROCEDURE [dbo].[usp_VRE_DailyProfileCurveSelect]		
	@StartDate DateTime = null,
	@EndDate DateTime = null,		
	@FileContextGuid UniqueIdentifier = null,
	@FilterOldRecords Bit = null,
	@ContextDate DateTime = null
AS
BEGIN
	
	SET NOCOUNT ON;

	If Not @StartDate is null
		Set @StartDate = DateAdd(Day,30,@StartDate)
		
	If @StartDate is null
		Set @StartDate = CAST('2000-01-01' AS DATETIME);
	
	If @EndDate is null
		Set @EndDate =  DATEADD(YEAR,10,GETDATE());
		
	If @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	Begin
		Select 
			ID,
			FileContextGUID,
			ISO,
			Utility,
			LoadShapeID,
			Zone,
			[Date],
			DPV,
			PeakPercent,
			PDF,
			DateCreated,
			CreatedBy
		From 
			VREDailyProfileCurve C1 WITH (NOLOCK)
		Where	
			FileContextGUID =  IsNull(@FileContextGuid,FileContextGuid) And
			@StartDate <= [Date] And
			@EndDate > [Date] And
			(@ContextDate is null or DateCreated < @ContextDate)			
	End
	Else
	Begin
		Select 
			ID,
			FileContextGUID,
			ISO,
			Utility,
			LoadShapeID,
			Zone,
			[Date],
			DPV,
			PeakPercent,
			PDF,
			DateCreated,
			CreatedBy
		From 
			VREDailyProfileCurve C1 WITH (NOLOCK)
		Where	
			FileContextGUID =  ISNULL(@FileContextGuid,FileContextGuid) And			
			ID In 
			(
				Select 
					Max(C2.ID) 
				From 
					VREDailyProfileCurve AS C2 
				Where
					@StartDate <= C2.[Date] And
					@EndDate > C2.[Date] And
					(@ContextDate is null or C2.DateCreated < @ContextDate)
				Group By
					C2.ISO, C2.Utility, C2.LoadShapeID, C2.[Date]
			)
	End
	  
End


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_DailyProfileCurveSelect';

