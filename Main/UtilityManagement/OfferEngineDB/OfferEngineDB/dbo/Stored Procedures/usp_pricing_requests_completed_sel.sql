
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/28/2008
-- Description:	Get completed price requests
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_requests_completed_sel]

@p_status		varchar(50)

AS

SELECT	REQUEST_ID
FROM	OE_PRICING_REQUEST WITH (NOLOCK)
WHERE	STATUS = @p_status

