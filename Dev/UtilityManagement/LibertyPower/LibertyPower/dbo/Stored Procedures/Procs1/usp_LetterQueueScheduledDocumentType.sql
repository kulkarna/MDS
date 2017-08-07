

-- =============================================
-- Author:		Sofia Melo
-- Create date:	2010-07-26
-- Description:	Create the procedure to get document type id 
--				of Pending letter queue.
-- Modified:	05/11/2011 - Ryan Russon	- Added current date condition to scheduling
-- =============================================
CREATE PROCEDURE [dbo].[usp_LetterQueueScheduledDocumentType]
	
AS

BEGIN

	SET NOCOUNT ON;

    SELECT DISTINCT DocumentTypeId
    FROM [LibertyPower].[dbo].[LetterQueue] (NOLOCK)
    WHERE Status = 'Scheduled'
	AND IsNull(ScheduledDate, '12/31/2500') < GETDATE()
	ORDER BY DocumentTypeId
	
	SET NOCOUNT OFF;
END




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_LetterQueueScheduledDocumentType';

