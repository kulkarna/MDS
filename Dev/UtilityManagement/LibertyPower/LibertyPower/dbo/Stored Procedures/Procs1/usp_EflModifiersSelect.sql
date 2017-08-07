/*******************************************************************************
 * usp_EflModifiersSelect
 * Gets any EFL modifiers used in rate usage calculations
 *
 * History
 *******************************************************************************
 * 8/25/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflModifiersSelect]
	@UtilityCode	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	RateUsage1, RateUsage2, RateUsage3
	FROM	EflModifiers m WITH (NOLOCK)
			INNER JOIN Utility u WITH (NOLOCK) ON u.ID = m.UtilityID
	WHERE	u.UtilityCode = @UtilityCode
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
