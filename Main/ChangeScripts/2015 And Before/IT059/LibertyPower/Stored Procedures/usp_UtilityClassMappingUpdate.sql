USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityClassMappingUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityClassMappingUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityClassMappingUpdate
 * Updates utility class mapping for specified record identity,
 * inserting new values into corresponding tables, if any.
 *
 * History
 *******************************************************************************
 * 12/3/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingUpdate]
	@ID					int,
	@UtilityID			int,
	@AccountTypeID		int,	
	@MeterTypeID		int,
	@VoltageID			int,	
	@RateClassCode		varchar(50),
	@ServiceClassCode	varchar(50),
	@LoadProfileCode	varchar(50),
	@LoadShapeCode		varchar(50),
	@TariffCode			varchar(50),
	@Losses				decimal(20,16) = NULL,
	@Zone				varchar(50),
	@IsActive			tinyint,
     @RuleType int = 0,
     @Icap decimal(20, 5) = NULL,
	@Tcap decimal(20, 5) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE	@RateClassID	int,
			@ServiceClassID	int,
			@LoadProfileID	int,
			@LoadShapeID	int,
			@TariffID		int,
			@ZoneID		    int 
			
	SELECT @RateClassID = ID FROM RateClass WITH (NOLOCK) WHERE RateClassCode = @RateClassCode			
	IF @RateClassID IS NULL
		BEGIN
			INSERT INTO RateClass (RateClassCode) VALUES (@RateClassCode)
			SET @RateClassID = SCOPE_IDENTITY()
		END
    
    SELECT @ServiceClassID = ID FROM ServiceClass WITH (NOLOCK) WHERE ServiceClassCode = @ServiceClassCode
	IF @ServiceClassID IS NULL
		BEGIN
			INSERT INTO ServiceClass (ServiceClassCode) VALUES (@ServiceClassCode)
			SET @ServiceClassID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadProfileID = ID FROM LoadProfile WITH (NOLOCK) WHERE LoadProfileCode = @LoadProfileCode
	IF @LoadProfileID IS NULL
		BEGIN
			INSERT INTO LoadProfile (LoadProfileCode) VALUES (@LoadProfileCode)
			SET @LoadProfileID = SCOPE_IDENTITY()
		END
    
    SELECT @LoadShapeID = ID FROM LoadShape WITH (NOLOCK) WHERE LoadShapeCode = @LoadShapeCode
	IF @LoadShapeID IS NULL
		BEGIN
			INSERT INTO LoadShape (LoadShapeCode) VALUES (@LoadShapeCode)
			SET @LoadShapeID = SCOPE_IDENTITY()
		END
    
    SELECT @TariffID = ID FROM TariffCode WITH (NOLOCK) WHERE Code = @TariffCode
	IF @TariffID IS NULL
		BEGIN
			INSERT INTO TariffCode (Code) VALUES (@TariffCode)
			SET @TariffID = SCOPE_IDENTITY()
		END
    
    SELECT 
		@ZoneID = Z.ID 
	FROM 
		Zone Z WITH (NOLOCK) 
		Inner Join UtilityZone UZ WITH (NOLOCK) 
		On Z.ID = UZ.ZoneID
	WHERE 
		Z.ZoneCode = @Zone And
		UZ.UtilityID = @UtilityID
		
	IF @ZoneID IS NULL
		BEGIN
			INSERT INTO Zone (ZoneCode) VALUES (@Zone)
			SET @ZoneID = SCOPE_IDENTITY()
		END
		
    UPDATE	UtilityClassMapping
	SET		AccountTypeID	= @AccountTypeID,
			MeterTypeID		= @MeterTypeID,
			VoltageID		= @VoltageID,
			RateClassID		= @RateClassID,
			ServiceClassID	= @ServiceClassID,
			LoadProfileID	= @LoadProfileID,
			LoadShapeID		= @LoadShapeID,
			TariffCodeID	= @TariffID,
			LossFactor		= @Losses,
			ZoneID			= @ZoneID,
			IsActive		= @IsActive,
			RuleType = @RuleType,
			ICap = @Icap,
			 TCap = @Tcap
    WHERE	ID				= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO
