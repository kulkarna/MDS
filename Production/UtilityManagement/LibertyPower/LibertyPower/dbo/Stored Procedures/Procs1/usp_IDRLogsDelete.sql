/********************************* [dbo].[usp_IDRLogsDelete] ********************/
CREATE PROCEDURE [dbo].[usp_IDRLogsDelete] 
	@Date datetime
AS
BEGIN

DELETE IDRLogs
WHERE	CreateDate < @Date

END
