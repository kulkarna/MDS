
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_request_files_sel] 

@p_pricing_request_id		varchar(50)

AS

SELECT	ID, ISNULL(REQUEST_ID, ''), ISNULL([FILE_NAME], ''), DATA
FROM	OE_PRICING_REQUEST_FILES WITH (NOLOCK)
WHERE	REQUEST_ID = @p_pricing_request_id

