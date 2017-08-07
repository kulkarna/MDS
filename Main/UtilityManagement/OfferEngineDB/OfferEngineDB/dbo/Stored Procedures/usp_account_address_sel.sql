
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/2/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_account_address_sel]

@p_account_number	varchar(50)

AS

SELECT	TOP 1 ISNULL(ADDRESS, '') AS ADDRESS, 
		ISNULL(SUITE, '') AS SUITE, 
		ISNULL(CITY, '') AS CITY, 
		ISNULL(STATE, '') AS STATE, 
		ISNULL(ZIP, '') AS ZIP
FROM	OE_ACCOUNT_ADDRESS WITH (NOLOCK)
WHERE	ACCOUNT_NUMBER = @p_account_number
AND		ZIP IS NOT NULL
ORDER BY OE_ACCOUNT_ID DESC
