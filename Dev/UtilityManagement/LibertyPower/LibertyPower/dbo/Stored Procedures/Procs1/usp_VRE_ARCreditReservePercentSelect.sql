-- =============================================
-- Author:		Jaime Forero
-- Create date: 6/10/2010
-- Description:	Select all rows from ARCreditReservePercent table.
-- Changes:
-- 07-08-2010 Jaime Forero:
--			  Added EndDate for filtering records.
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_ARCreditReservePercentSelect]
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@FileContextGuid UNIQUEIDENTIFIER = NULL,
	@FilterOldRecords BIT = NULL,
	@ContextDate	DATETIME = NULL
AS
BEGIN
	SET NOCOUNT ON;

	/**
		We are trying to exclude duplicate records only the latest values should be taken in consideration.
		We also filter for the start date, if NULL then it IGNORES the start date.
		Note that start date DOES NOT mean the record creation date
	**/
	
	IF @StartDate IS NULL
		SET @StartDate = CAST('2000-01-01' AS DATETIME);
	
	IF @EndDate IS NULL
		SET @EndDate =  DATEADD(YEAR,10,GETDATE());
		
	SET @StartDate = CAST(CAST(YEAR(@StartDate)AS VARCHAR) +'-'+ CAST(MONTH(@StartDate)AS VARCHAR) + '-01 00:00:00' AS DATETIME );
	
	
	
	IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		DECLARE @T INT;
		SET @T = NULL;
		SELECT 
		   [ID]
		  ,[FileContextGUID]
		  ,[UtilityCode]
		  ,[Month]
		  ,[Year]
		  ,[ARPercent]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREARCreditReservePercent] CR
		WHERE	FileContextGUID = ISNULL(@FileContextGuid,FileContextGuid)
		AND		@StartDate <= CAST( CAST(CR.[Year] AS VARCHAR) + '-' + CAST(CR.[Month] AS VARCHAR) +  '-01 00:00:00' AS DATETIME)
		AND		@EndDate > CAST( CAST(CR.[Year] AS VARCHAR)+ '-'+ CAST(CR.[Month] AS VARCHAR) + '-01 00:00:00' as DATETIME)
		AND		(@ContextDate IS NULL OR CR.DateCreated < @ContextDate)
		;
	END
	ELSE
	BEGIN
		SELECT 
		   [ID]
		  ,[FileContextGUID]
		  ,[UtilityCode]
		  ,[Month]
		  ,[Year]
		  ,[ARPercent]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREARCreditReservePercent]
		WHERE 
			FileContextGUID = ISNULL(@FileContextGuid,FileContextGuid)
			AND
			ID IN(
				SELECT MAX(CR.ID) 
				FROM [VREARCreditReservePercent] AS CR 
				WHERE @StartDate <= CAST( CAST(CR.[Year] AS VARCHAR) + '-' + CAST(CR.[Month] AS VARCHAR) +  '-01 00:00:00' AS DATETIME)
				AND @EndDate > CAST( CAST(CR.[Year] AS VARCHAR)+ '-'+ CAST(CR.[Month] AS VARCHAR) + '-01 00:00:00' as DATETIME)
				AND	(@ContextDate IS NULL OR CR.DateCreated < @ContextDate)
				GROUP BY CR.UtilityCode,CR.[Year], CR.[Month]
			);
	END
	
	
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ARCreditReservePercentSelect';

