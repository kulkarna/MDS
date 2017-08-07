/*******************************************************************************
 * usp_DailyProfileDetailInsert
 * Insert daily profile detail values
 *
 * History
 *******************************************************************************
 * 1/19/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyProfileDetailInsert]   
	@DateProfile		datetime,                                                                                  
	@DailyProfileId		bigint,
	@PeakValue			decimal(18,7),
	@OffPeakValue		decimal(18,7),
	@DailyValue			decimal(18,7),
	@PeakRatio			decimal(18,7)
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	DailyProfileDetail (DailyProfileID, DateProfile, 
				PeakValue, OffPeakValue, DailyValue, PeakRatio)
	VALUES		(@DailyProfileId, @DateProfile, @PeakValue, 
				@OffPeakValue, @DailyValue, @PeakRatio)

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
