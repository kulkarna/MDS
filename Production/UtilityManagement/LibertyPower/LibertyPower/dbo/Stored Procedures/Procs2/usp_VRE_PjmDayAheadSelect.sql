
-- =============================================
-- Author:		Forero, Jaime
-- Create date: 06/16/2010
-- Description:	Retreive all MISO day ahead records
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_PjmDayAheadSelect]
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
		  ,[Name]
		  ,[Type]
		  ,[Zone]
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
		FROM [VREPjmDayAhead] DA
		WHERE FileContextGUID = ISNULL(@FileContextGuid,FileContextGuid)
		AND	  ISNULL(@StartDate ,DA.[Date]) <= DA.[Date]
		AND   ISNULL(@EndDate , DATEADD(DAY,1,DA.[Date] )) > DA.[Date]
		AND   ([Name] IN (SELECT zoneId FROM @tempZone) OR @useList = 0 )
	END
	ELSE
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Date]
		  ,[Name]
		  ,[Type]
		  ,[Zone]
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
		FROM [VREPjmDayAhead] 
		WHERE ID IN(
				SELECT MAX(DA.ID) 
				FROM [VREPjmDayAhead] AS DA 
				WHERE FileContextGUID = ISNULL(@FileContextGuid,FileContextGuid)
				AND	 ISNULL(@StartDate, DA.[Date]) <= DA.[Date]
				AND   ISNULL(@EndDate, DATEADD(DAY,1,DA.[Date])) > DA.[Date]
				AND   ([Name] IN (SELECT zoneId FROM @tempZone) OR @useList = 0 )
				GROUP BY DA.Name, DA.[Type], DA.[Date]
			);
	END
	
	
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_PjmDayAheadSelect';

