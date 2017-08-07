-- =============================================
-- Author:		Forero, Jaime
-- Create date: 06/16/2010
-- Description:	Retreive all ERCOT day ahead records
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_ErcotDayAheadSelect]
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@FileContextGuid UNIQUEIDENTIFIER = NULL,
	@FilterOldRecords BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- SELECT * FROM VREErcotDayAhead;
	
	IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Date]
		  ,[IntervalEnding]
		  ,[Houston]
		  ,[North]
		  ,[South]
		  ,[West]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREErcotDayAhead] DA
		WHERE FileContextGUID =  ISNULL(@FileContextGuid,FileContextGuid)
		AND ISNULL(@StartDate, DA.[Date]) <= DA.[Date]
		AND   ISNULL(@EndDate , DATEADD(DAY,1,DA.[Date])) > DA.[Date]
	END
	ELSE
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Date]
		  ,[IntervalEnding]
		  ,[Houston]
		  ,[North]
		  ,[South]
		  ,[West]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREErcotDayAhead] 
		WHERE FileContextGUID =  ISNULL(@FileContextGuid,FileContextGuid)
			AND ID IN(
				SELECT MAX(DA.ID) 
				FROM [VREErcotDayAhead] AS DA 
				WHERE ISNULL(@StartDate, DA.[Date]) <= DA.[Date]
				AND   ISNULL(@EndDate , DATEADD(DAY,1,DA.[Date])) > DA.[Date]
				GROUP BY CAST( DA.[Date] AS DATETIME) , DA.[IntervalEnding] 
			);
	END
	
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ErcotDayAheadSelect';

