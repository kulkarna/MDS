-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/16/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_price_matrix_exceptions_sel]

AS

SELECT		LOAD_SHAPE_ID, UTILITY
FROM		OE_PRICE_MATRIX_EXCEPTIONS
ORDER BY	LOAD_SHAPE_ID
