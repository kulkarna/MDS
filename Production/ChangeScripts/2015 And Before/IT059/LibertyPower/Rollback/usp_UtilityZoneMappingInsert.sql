USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_UtilityZoneMappingInsert]    Script Date: 07/13/2013 14:01:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityZoneMappingInsert
 * Inserts utility zone mapping record
 *
 * History
 *******************************************************************************
 * 12/6/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_UtilityZoneMappingInsert]
	@UtilityID	int,	
	@ZoneID		int,
	@Grid		varchar(50),
	@LbmpZone	varchar(50),
	@Losses		decimal(20,16) = NULL,	
	@IsActive	tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@UtilityZoneID	int
    
    SELECT	@UtilityZoneID	= ID
    FROM	UtilityZone WITH (NOLOCK)
    WHERE	UtilityID		= @UtilityID
    AND		ZoneID			= @ZoneID
    
    IF @UtilityZoneID IS NULL
		BEGIN
			INSERT INTO UtilityZone (UtilityID, ZoneID)
			VALUES		(@UtilityID, @ZoneID)
			
			SET	@UtilityZoneID = SCOPE_IDENTITY()
		END
     
    INSERT INTO	UtilityZoneMapping (UtilityID, Grid, LBMPZone, LossFactor, IsActive, UtilityZoneID)
	VALUES		(@UtilityID, @Grid, @LbmpZone, @Losses, @IsActive, @UtilityZoneID)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO

