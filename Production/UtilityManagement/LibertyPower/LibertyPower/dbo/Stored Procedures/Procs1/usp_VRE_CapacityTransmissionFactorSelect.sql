-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_CapacityTransmissionFactorSelect]
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@FileContextGuid UNIQUEIDENTIFIER = NULL,
	@FilterOldRecords BIT = NULL,
	@ContextDate	DATETIME = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT * FROM VRECapacityTransmissionFactor;
	
	
	IF @StartDate IS NULL
		SET @StartDate = CAST('2000-01-01' AS DATETIME);
	
	SET @StartDate = CAST(CAST(YEAR(@StartDate)AS VARCHAR) +'-'+ CAST(MONTH(@StartDate)AS VARCHAR) + '-01 00:00:00' AS DATETIME );
	
	IF @EndDate IS NULL
		SET @EndDate = DATEADD(YEAR,10,GETDATE());
		
	
	IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[UtilityCode]
		  ,[LoadShapeID]
		  ,[Month]
		  ,[Year]
		  ,[Capacity]
		  ,[Transmission]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VRECapacityTransmissionFactor] CT
		WHERE 
		FileContextGUID =  ISNULL(@FileContextGuid,FileContextGuid)
		AND @StartDate <= CAST( CAST(CT.[Year] AS VARCHAR) + '-' + CAST(CT.[Month] AS VARCHAR) +  '-01 00:00:00' AS DATETIME)
		AND @EndDate > CAST( CAST(CT.[Year] AS VARCHAR)+ '-'+ CAST(CT.[Month] AS VARCHAR) + '-01 00:00:00' AS DATETIME)
		AND	(@ContextDate IS NULL OR CT.DateCreated < @ContextDate)
		;
	END
	ELSE
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[UtilityCode]
		  ,[LoadShapeID]
		  ,[Month]
		  ,[Year]
		  ,[Capacity]
		  ,[Transmission]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VRECapacityTransmissionFactor] 
		WHERE 
			FileContextGUID =  ISNULL(@FileContextGuid,FileContextGuid)
			AND 
			ID IN(
				SELECT MAX(CT.ID) 
				FROM [VRECapacityTransmissionFactor] AS CT 
				WHERE @StartDate <= CAST( CAST(CT.[Year] AS VARCHAR) + '-' + CAST(CT.[Month] AS VARCHAR) +  '-01 00:00:00' AS DATETIME)
				AND @EndDate > CAST( CAST(CT.[Year] AS VARCHAR)+ '-'+ CAST(CT.[Month] AS VARCHAR) + '-01 00:00:00' AS DATETIME)
				AND	(@ContextDate IS NULL OR CT.DateCreated < @ContextDate)
				GROUP BY CT.UtilityCode,CT.LoadShapeID, CT.[Year], CT.[Month]
			);
	END
	
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_CapacityTransmissionFactorSelect';

