
/*******************************************************************************
 * usp_SalesStatusSelect
 * Gets Sales statuses
 *
 * History
 *******************************************************************************
 * 10/3/2011 - Gail Mangaroo
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesStatusSelectAll]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT [ID]
      ,[Name]
      ,[Description]
	FROM [LibertyPower].[dbo].[SalesStatus]
    
    SET NOCOUNT OFF;
END
