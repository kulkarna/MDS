
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/31/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_errors_sel]

AS

SELECT		RequestID, OfferID, AccountNumber, Utility, ErrorMessage, UserName, DateInsert
FROM		zErrors WITH (NOLOCK)
ORDER BY	DateInsert DESC

