

CREATE PROCEDURE [dbo].[usp_VRE_ShapingFactorCurveInsert]
	@FileContextGUID UNIQUEIDENTIFIER,
	@LoadShapeID VARCHAR(50),
	@ZoneID VARCHAR(50),
	@Month INT,
	@Year INT,
	@Date DateTime,
	@PeakFactor DECIMAL(6,5),
	@OffPeakFactor DECIMAL(6,5),	
	@CreatedBy INT
AS
BEGIN
   INSERT INTO [VREShapingFactorCurve]
           (          
			[FileContextGUID],
			[LoadShapeID],
			[ZoneID],
			[Month],
			[Year],
			[Date],
			[PeakFactor],
			[OffPeakFactor],			
			[CreatedBy]
           )
     VALUES
           (
			@FileContextGUID,
			@LoadShapeID,
			@ZoneID,
			@Month,			
			@Year,
			@Date,
			@PeakFactor,
			@OffPeakFactor,			
			@CreatedBy
			);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT 
			[ID],
			[FileContextGUID],
			[LoadShapeID],
			[ZoneID],
			[Month],
			[Year],
			[Date],
			[PeakFactor],
			[OffPeakFactor],			
			[CreatedBy],
			[DateCreated]
		FROM 
			[VREShapingFactorCurve] 
		WHERE 
			ID = SCOPE_IDENTITY();
	END

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ShapingFactorCurveInsert';

