/*******************************************************************************
 * usp_SelfGenerationsSelect
 * Gets self generation records
 *
 * History
 *******************************************************************************
 * 11/5/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SelfGenerationsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, Name
    FROM	SelfGeneration WITH (NOLOCK)
    ORDER BY ID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
