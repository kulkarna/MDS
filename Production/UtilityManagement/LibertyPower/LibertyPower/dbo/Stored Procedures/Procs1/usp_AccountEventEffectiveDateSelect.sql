
--ALTER TABLE AccountEventHistory
--ADD SubmitDate datetime NULL
--GO
--ALTER TABLE AccountEventHistory
--ADD DealDate datetime NULL
--GO
--ALTER TABLE AccountEventHistory
--ADD SalesChannelId varchar(100) NULL
--GO
--ALTER TABLE AccountEventHistory
--ADD SalesRep varchar(100) NULL
--GO
--ALTER TABLE AccountEventHistory
--ADD AdditionalGrossMargin decimal(18,4) NOT NULL DEFAULT 0
--GO

/*******************************************************************************
 * usp_AccountEventEffectiveDateSelect
 * Get effective date based on id
 *
 * History
 *******************************************************************************
 * 5/4/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountEventEffectiveDateSelect]                                                                                    
	@EventId	int
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	EventID, EventName, EventEffectiveDateValue, GrossMarginRecalculateFlag
	FROM	AccountEventEffectiveDate WITH (NOLOCK)
	WHERE	EventID = @EventId

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

