

/*******************************************************************************
 * usp_DailyPricingLogInsert_Event
 * Inserts event record
 *
 * History
 *******************************************************************************
 * 4/12/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingLogInsert_Event]  
	@Message	varchar(8000)
AS

	DECLARE @ID int

	INSERT INTO	LibertyPower..DailyPricingLog_Event ([Message], DateCreated)
    VALUES		(@Message, GETDATE())


	SET @ID = @@Identity

	SELECT	ID, [Message], DateCreated
	FROM	LibertyPower..DailyPricingLog_Event WITH (NOLOCK)	
	WHERE	ID = @ID                                                                                                                                
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingLogInsert_Event';

