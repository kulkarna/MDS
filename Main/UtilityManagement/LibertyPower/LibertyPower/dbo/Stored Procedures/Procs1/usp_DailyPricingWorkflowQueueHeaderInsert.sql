/*******************************************************************************
 * usp_DailyPricingWorkflowQueueHeaderInsert
 * Inserts header record, returning inserted data with record identifier
 *
 * History
 *******************************************************************************
 * 2/18/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueHeaderInsert]
	@DailyPricingCalendarIdentity	int,
	@EffectiveDate					datetime,
	@ExpirationDate					datetime,
	@WorkDay						datetime,
	@DateCreated					datetime,
	@CreatedBy						int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	int
    
    UPDATE	DailyPricingWorkflowQueueHeader
    SET		EffectiveDate					= @EffectiveDate,
			ExpirationDate					= @ExpirationDate,
			WorkDay							= @WorkDay,
			DateCreated						= @DateCreated,
			CreatedBy						= @CreatedBy
	WHERE	DailyPricingCalendarIdentity	= @DailyPricingCalendarIdentity
    
	SET	@ID = SCOPE_IDENTITY()
    
    IF @ID IS NULL
		BEGIN
			INSERT INTO	DailyPricingWorkflowQueueHeader (DailyPricingCalendarIdentity, EffectiveDate, ExpirationDate, WorkDay, DateCreated, CreatedBy)
			VALUES		(@DailyPricingCalendarIdentity, @EffectiveDate, @ExpirationDate, @WorkDay, @DateCreated, @CreatedBy)
			
			SET	@ID = SCOPE_IDENTITY()
		END
    
    SELECT	ID, EffectiveDate, ExpirationDate, WorkDay, DateCreated, CreatedBy
    FROM	DailyPricingWorkflowQueueHeader WITH (NOLOCK)
    WHERE	ID = @ID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingWorkflowQueueHeaderInsert';

