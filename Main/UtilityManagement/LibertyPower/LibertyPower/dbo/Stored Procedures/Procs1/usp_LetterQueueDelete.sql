

-- =============================================
-- Author:	Sofia Melo
-- Create date: 2010-07-26
-- Description:	Create the procedure to remove from LetterQueue
-- =============================================
CREATE PROCEDURE [dbo].[usp_LetterQueueDelete]
			
           @LetterQueueID int
           
AS
	
BEGIN
	
	SET NOCOUNT ON;
    
    DELETE FROM [LibertyPower].[dbo].[LetterQueue]           
    WHERE [LetterQueueID] = @LetterQueueID
           	
	SET NOCOUNT OFF;
	
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_LetterQueueDelete';

