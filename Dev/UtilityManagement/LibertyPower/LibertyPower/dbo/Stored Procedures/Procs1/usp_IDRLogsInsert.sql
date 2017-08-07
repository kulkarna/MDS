/********************************* [dbo].[usp_IDRLogsInsert] ********************/
CREATE PROCEDURE [dbo].[usp_IDRLogsInsert] 
	@UtilityID varchar(15),
	@LogMessage varchar(350),
	@CreateDate datetime
AS
BEGIN
	INSERT INTO IDRLogs
           (UtilityID
           ,LogMessage
           ,CreateDate)
     VALUES
           (@UtilityID
           ,@LogMessage
           ,@CreateDate)

END
