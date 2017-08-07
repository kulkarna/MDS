-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/22/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_aggregates_by_offer_id_del]

@p_offer_id		varchar(50)

AS

DELETE FROM	OE_OFFER_AGGREGATES
WHERE		OFFER_ID = @p_offer_id
