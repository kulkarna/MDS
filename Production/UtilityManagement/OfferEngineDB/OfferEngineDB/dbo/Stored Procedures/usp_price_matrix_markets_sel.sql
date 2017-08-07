-- =============================================
-- Author:		Rick Deigsler	
-- Create date: 9/15/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_price_matrix_markets_sel]

AS

SELECT	DISTINCT MARKET
FROM	OE_PRICE_MATRIX
