
-- =============================================
-- Author:		Forero, Jaime
-- Create date: 06/17/2010
-- Description:	Retreive all NEISO day ahead records
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_NeisoDayAheadSelect]
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@FilterOldRecords BIT = NULL,
	@FileContextGuid UNIQUEIDENTIFIER = NULL,
	@ZoneIdList VARCHAR(4000) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @pos INT, @CurZoneId VARCHAR(50);
	DECLARE @useList BIT;
	SET  @useList = 0;
	SET @pos = 0;
	DECLARE @tempZone TABLE 
	(
		zoneId VARCHAR(50)
	)
	IF @ZoneIdList IS NOT NULL AND @ZoneIdList != ''
	BEGIN
		SET @useList = 1;
		WHILE CHARINDEX(',',@ZoneIdList) > 0
		BEGIN
			SET @pos = CHARINDEX(',',@ZoneIdList);
			SET @CurZoneId = RTRIM(SUBSTRING(@ZoneIdList,1,@pos-1));
			INSERT INTO @tempZone (zoneId) VALUES (@CurZoneId);
			SET @ZoneIdList= SUBSTRING(@ZoneIdList,@pos+1,4000);
		END
	END
	
	IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Date]
		  ,[HourEnd]
		  ,[LocationID]
		  ,[LocationName]
		  ,[LocationType]
		  ,[LocationalMarginalPrice]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VRENeisoDayAhead] DA
		WHERE 
		FileContextGUID = ISNULL(@FileContextGuid,FileContextGuid)
		AND	ISNULL(@StartDate , DA.[Date]) <= DA.[Date]
		AND   ISNULL(@EndDate , DATEADD(DAY,1,DA.[Date])) > DA.[Date]
		AND ([LocationName] IN (SELECT zoneId FROM @tempZone) OR @useList = 0 )
	END
	ELSE
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Date]
		  ,[HourEnd]
		  ,[LocationID]
		  ,[LocationName]
		  ,[LocationType]
		  ,[LocationalMarginalPrice]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VRENeisoDayAhead] 
		WHERE ID IN(
				SELECT MAX(DA.ID) 
				FROM [VRENeisoDayAhead] AS DA 
				WHERE FileContextGUID = ISNULL(@FileContextGuid,FileContextGuid)
				AND	ISNULL(@StartDate, DA.[Date]) <= DA.[Date]
				AND   ISNULL(@EndDate, DATEADD(DAY,1,DA.[Date])) > DA.[Date]
				AND ([LocationName] IN (SELECT zoneId FROM @tempZone) OR @useList = 0 )
				GROUP BY DA.LocationType, DA.HourEnd, DA.LocationName, DA.[Date]
			);
	END
	
END




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_NeisoDayAheadSelect';

