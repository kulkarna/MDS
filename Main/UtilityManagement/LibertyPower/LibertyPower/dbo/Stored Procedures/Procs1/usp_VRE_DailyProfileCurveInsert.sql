

CREATE PROCEDURE [dbo].[usp_VRE_DailyProfileCurveInsert]
	@FileContextGUID UNIQUEIDENTIFIER,
	@ISO VARCHAR(50),
	@Utility VARCHAR(50),
	@LoadShapeID VARCHAR(50),
	@Zone VARCHAR(50),
	@Date DateTime,
	@DPV DECIMAL(18,7),
	@PeakPercent DECIMAL(18,15),	
	@PDF DECIMAL(18,7),	
	@CreatedBy INT
AS
BEGIN
   INSERT INTO [VREDailyProfileCurve]
           (          
			FileContextGUID,
			ISO,
			Utility,
			LoadShapeID,
			Zone,
			[Date],
			DPV,
			PeakPercent,	
			PDF,
			CreatedBy
           )
     VALUES
           (
			@FileContextGUID,
			@ISO,
			@Utility,
			@LoadShapeID,
			@Zone,
			@Date,
			@DPV,
			@PeakPercent,	
			@PDF,
			@CreatedBy
			);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT 
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
			CreatedBy,
			DateCreated
		FROM 
			[VREDailyProfileCurve] 
		WHERE 
			ID = SCOPE_IDENTITY();
	END

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_DailyProfileCurveInsert';

