


CREATE PROCEDURE [dbo].[usp_VRE_MarkupCurveInsert]
	@FileContextGUID UNIQUEIDENTIFIER,
	@Market VARCHAR(50),
	@UtilityCode VARCHAR(50),
	@ServiceClass VARCHAR(50),
	@ZoneID VARCHAR(50),
	@PricingType VARCHAR(50),
	@AccountType VARCHAR(50) = 'SMB',
	@MinSize INT,
	@MaxSize INT,
	@ProductType VARCHAR(50),
	@EffectiveDate DATETIME ,
	@ExpirationDate DATETIME = NULL,
	@Markup DECIMAL(18,4),
	@MinDuration int,
	@MaxDuration int,
	@CreatedBy INT
AS
BEGIN
   INSERT INTO [VREMarkupCurve]
           (
           [FileContextGUID]
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
           ,[CreatedBy]
           ,[ModifiedBy]
           )
     VALUES
           (@FileContextGUID,
			@Market,
			@UtilityCode,
			@ServiceClass,
			@ZoneID,
			@PricingType,
			@AccountType,
			@MinSize,
			@MaxSize,
			@ProductType,
			@EffectiveDate,
			@ExpirationDate,
			@Markup,
			@MinDuration,
		    @MaxDuration,
			@CreatedBy,
			@CreatedBy);
			
	IF @@ROWCOUNT > 0
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
		WHERE ID = SCOPE_IDENTITY();
	END


END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_MarkupCurveInsert';

