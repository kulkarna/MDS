

CREATE PROCEDURE [dbo].[usp_VRE_SupplierPremiumCurveSelect]
	@StartDate DateTime = null,
	@EndDate DateTime = null,		
	@FileContextGuid UniqueIdentifier = null,
	@FilterOldRecords Bit = null,
	@ContextDate DateTime = null
AS

BEGIN
	
	SET NOCOUNT ON;
	
	-- The day value in the curves is not used. We need to take this into account
	
	
	-- If we have a start date, set it's day value to 1
	If not @StartDate is null
		Set @StartDate = Cast(Year(@StartDate) as varchar(4)) + '-' + Cast(Month(@StartDate) as varchar(2)) + '-1'
		
	-- If we have an end date, set it to next month and set the day to 1
	If not @EndDate is null
	Begin
		Set @EndDate = DateAdd(Month,1,@EndDate)
		Set @EndDate = Cast(Year(@EndDate) as varchar(4)) + '-' + Cast((Month(@EndDate)) as varchar(2)) + '-1'
	End
	
	-- If we have an ContextDate, set it to next month and set the day to 1
	If not @ContextDate is null
	Begin
		Set @ContextDate = DateAdd(Month,1,@ContextDate)
		Set @ContextDate = Cast(Year(@ContextDate) as varchar(4)) + '-' + Cast((Month(@ContextDate)) as varchar(2)) + '-1'
	End
							
	If @StartDate is null
		Set @StartDate = DateAdd(Month,-1,GetDate())
	
	If @EndDate is null
		Set @EndDate =  DateAdd(Month,1,GetDate())
			   	
   	If @FilterOldRecords IS NULL OR @FilterOldRecords = 0
		Begin			
			Select 
				H.VreSupplierPremiumCurveHeaderID,
				H.[FileContextGUID],
				H.[ISO],
				H.[Zone],
				H.[Market],
				H.[UpdatedDate],
				H.[VrePriceType],
				H.[CreatedBy],
				H.[DateCreated],
				V.VreSupplierPremiumCurveValueID,				
				V.[Date],
				V.Value
			From 
				VreSupplierPremiumCurveHeader H
				Inner Join
				VreSupplierPremiumCurveValues V
				On H.VreSupplierPremiumCurveHeaderID = V.VreSupplierPremiumCurveHeaderID
			Where	
				H.FileContextGUID =  IsNull(@FileContextGuid,H.FileContextGuid) And
				@StartDate <= V.[Date] And
				@EndDate > V.[Date] And
				(@ContextDate is null or H.DateCreated < @ContextDate)			
		End
	Else
		Begin
			Select 
				H.VreSupplierPremiumCurveHeaderID,
				H.[FileContextGUID],
				H.[ISO],
				H.[Zone],
				H.[Market],
				H.[UpdatedDate],
				H.[VrePriceType],
				H.[CreatedBy],
				H.[DateCreated],
				V.VreSupplierPremiumCurveValueID,				
				V.[Date],
				V.Value
			From 
				VreSupplierPremiumCurveHeader H
				Inner Join
				VreSupplierPremiumCurveValues V
				On H.VreSupplierPremiumCurveHeaderID = V.VreSupplierPremiumCurveHeaderID
			Where
				FileContextGUID =  ISNULL(@FileContextGuid,FileContextGuid) And
				V.VreSupplierPremiumCurveValueID In 
				(
					Select 
						Max(V2.VreSupplierPremiumCurveValueID) 
					From 
						VreSupplierPremiumCurveHeader H2
						Inner Join
						VreSupplierPremiumCurveValues V2
						On H2.VreSupplierPremiumCurveHeaderID = V2.VreSupplierPremiumCurveHeaderID
					Where
						@StartDate <= V2.[Date] And
						@EndDate > V2.[Date] And
						(@ContextDate is null or H2.DateCreated < @ContextDate)
					Group By
						H2.ISO, H2.Zone, H2.Market, H2.VrePriceType,V2.[Date], V2.Value							
				)
			Order By
				V.[Date]
		End		   						  
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_SupplierPremiumCurveSelect';

