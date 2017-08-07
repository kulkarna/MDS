-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_terms_and_prices_ins]

@p_terms_and_prices_id	varchar(50),
@p_flow_start_date_id	varchar(50),
@p_term					int				= NULL,
@p_price				decimal(16,2)	= NULL

AS

INSERT INTO	OE_TERMS_AND_PRICES (TERMS_AND_PRICES_ID, FLOW_START_DATE_ID, TERM, PRICE)
VALUES		(@p_terms_and_prices_id, @p_flow_start_date_id, @p_term, @p_price)

IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	SELECT 1
ELSE
	SELECT 0
