/*******************************************************************************
 * usp_LegalStatusSelect
 * Gets Legal statuses
 *
 * History
 *******************************************************************************
 * 10/3/2011 - Gail Mangaroo
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_LegalStatusSelectAll]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT [ID]
      ,[Name]
      ,[Description]
	FROM [LibertyPower].[dbo].[LegalStatus]
    
    SET NOCOUNT OFF;
END
