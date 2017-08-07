-- =============================================
-- Author:		Jaime Foreo
-- Create date: 6/11/2010
-- Description:	Select all rows from VREHourlyProfile table
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_HourlyProfileSelect]
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
	-- SELECT * FROM [VREHourlyProfile];
	
	IF @StartDate IS NULL
		SET @StartDate = CAST('2000-01-01' AS DATETIME);
	
	IF @EndDate IS NULL
		SET @EndDate =  DATEADD(YEAR,10,GETDATE());
		
	
	
	IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		SELECT 
		[ID]
      ,[FileContextGUID]
      ,[UtilityCode]
      ,[ZoneID]
      ,[LoadShapeID]
      ,[Date]
      ,[H1]
      ,[H2]
      ,[H3]
      ,[H4]
      ,[H5]
      ,[H6]
      ,[H7]
      ,[H8]
      ,[H9]
      ,[H10]
      ,[H11]
      ,[H12]
      ,[H13]
      ,[H14]
      ,[H15]
      ,[H16]
      ,[H17]
      ,[H18]
      ,[H19]
      ,[H20]
      ,[H21]
      ,[H22]
      ,[H23]
      ,[H24]
      ,[DateCreated]
      ,[CreatedBy]
      ,[DateModified]
      ,[ModifiedBy]
		
		FROM [VREHourlyProfile] HP
		WHERE FileContextGUID =  ISNULL(@FileContextGuid,FileContextGuid)
		AND		@StartDate <= HP.[Date]
		AND		@EndDate > HP.[Date]
		AND		(@ContextDate IS NULL OR HP.DateCreated < @ContextDate)
		;
	END
	ELSE
	BEGIN
		SELECT 
		 [ID]
      ,[FileContextGUID]
      ,[UtilityCode]
      ,[ZoneID]
      ,[LoadShapeID]
      ,[Date]
      ,[H1]
      ,[H2]
      ,[H3]
      ,[H4]
      ,[H5]
      ,[H6]
      ,[H7]
      ,[H8]
      ,[H9]
      ,[H10]
      ,[H11]
      ,[H12]
      ,[H13]
      ,[H14]
      ,[H15]
      ,[H16]
      ,[H17]
      ,[H18]
      ,[H19]
      ,[H20]
      ,[H21]
      ,[H22]
      ,[H23]
      ,[H24]
      ,[DateCreated]
      ,[CreatedBy]
      ,[DateModified]
      ,[ModifiedBy]
		 
		 
		FROM [VREHourlyProfile] 
		WHERE 
			FileContextGUID =  ISNULL(@FileContextGuid,FileContextGuid)
			AND 
			ID IN(
				SELECT MAX(HP.ID) 
				FROM [VREHourlyProfile] AS HP 
				WHERE	@StartDate <= HP.[Date]
				AND		@EndDate > HP.[Date]
				AND		(@ContextDate IS NULL OR HP.DateCreated < @ContextDate)
				GROUP BY HP.UtilityCode, HP.ZoneID, HP.LoadShapeID, HP.[Date]
			);
	END
	
	
	
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_HourlyProfileSelect';

