




-- =============================================
-- Author:		Jaime Foreo
-- Create date: 6/10/2010
-- Description:	Select all rows from VREMarkupCurve table
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_MarkupCurveSelect]
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
	-- SELECT * FROM VREMarkupCurve;
	IF @StartDate IS NULL
		SET @StartDate = CAST('2000-01-01' AS DATETIME);
	
	IF @EndDate IS NULL
		SET @EndDate = DATEADD(YEAR,10,GETDATE());
	
	
		
	IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Market]
		  ,[UtilityCode]
		  ,[ServiceClass]
		  ,[ZoneID]
		  ,[PricingType]
		  ,[AccountType]
		  ,[MinSize]
		  ,[MaxSize]
		  ,[ProductType]
		  ,[EffectiveDate]
		  ,[ExpirationDate]
		  ,[Markup]
		  ,[MinDuration]
		  ,[MaxDuration]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREMarkupCurve] MARKUP
		WHERE 
		FileContextGUID = ISNULL(@FileContextGuid,FileContextGuid)
		AND		([ExpirationDate] IS NULL OR [ExpirationDate] >= @StartDate ) 
	    AND		[EffectiveDate] < @EndDate
	    AND		(@ContextDate IS NULL OR MARKUP.DateCreated < @ContextDate)
	    ;
	END
	ELSE
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Market]
		  ,[UtilityCode]
		  ,[ServiceClass]
		  ,[ZoneID]
		  ,[PricingType]
		  ,[AccountType]
		  ,[MinSize]
		  ,[MaxSize]
		  ,[ProductType]
		  ,[EffectiveDate]
		  ,[ExpirationDate]
		  ,[Markup]
		  ,[MinDuration]
		  ,[MaxDuration]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREMarkupCurve] 
		WHERE ID IN(
				SELECT MAX(MARKUP.ID) 
				FROM [VREMarkupCurve] AS MARKUP 
				WHERE 
				FileContextGUID = ISNULL(@FileContextGuid,FileContextGuid)
				AND	([ExpirationDate] IS NULL OR [ExpirationDate] >= @StartDate ) 
				AND [EffectiveDate] < @EndDate
				AND (@ContextDate IS NULL OR MARKUP.DateCreated < @ContextDate)
				GROUP BY MARKUP.Market, 
				MARKUP.UtilityCode, 
				MARKUP.ServiceClass, 
				MARKUP.ZoneID, 
				MARKUP.ProductType, 
				MARKUP.PricingType,
				MARKUP.AccountType, 
				MARKUP.EffectiveDate,
				MARKUP.MinSize,
				MARKUP.MaxSize,
				MARKUP.MinDuration,
				MARKUP.MaxDuration
			);
	END
	
	
END






GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_MarkupCurveSelect';

