
-- =============================================
-- Author:	Sofia Melo
-- Create date: 2010-07-27
-- Description:	Create the procedure to update the Letter Queue
-- =============================================
CREATE PROCEDURE [dbo].[usp_LetterQueueUpdate]
	
	@LetterQueueId int,
	@ScheduledDate datetime,
	@letterStatus varchar(20),
	@PrintDate datetime = NULL,
	@Username varchar(50) 
AS

BEGIN
	
	SET NOCOUNT ON;
	
    UPDATE [LibertyPower].[dbo].[LetterQueue]
	SET [Status] = @letterStatus      
       ,[ScheduledDate] = @ScheduledDate
       ,[PrintDate] = @PrintDate
       ,[Username] = @Username
	WHERE LetterQueueId = @LetterQueueId
 
	SET NOCOUNT OFF;
	
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_LetterQueueUpdate';

