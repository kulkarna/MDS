-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/2/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_price_request_ready_for_contract_search_sel]

@p_pricing_request_id		varchar(50)		= '',
@p_role_id					int				= 0,
@p_offer_status				varchar(50)		= ''

AS

DECLARE	@w_sql				nvarchar(1000)

-- sales have limited functionality, filtering only by price request id
--IF	(SELECT [NAME] FROM AD_ROLES WHERE ROL_ID = @p_role_id) = 'Sales'
--	BEGIN
		IF LEN(@p_pricing_request_id) = 0
			BEGIN
				SET	@w_sql	=	'SELECT		o.REQUEST_ID, o2.OFFER_ID, o2.DATE_CREATED 
								FROM		OE_PRICING_REQUEST_OFFER o INNER JOIN OE_OFFER o2 ON o.OFFER_ID = o2.OFFER_ID 
								WHERE		o2.STATUS = ''' + @p_offer_status + ''' 
								ORDER BY	o.REQUEST_ID DESC, o2.OFFER_ID ASC'
			END
		ELSE
			BEGIN
				SET	@w_sql	=	'SELECT		o.REQUEST_ID, o2.OFFER_ID, o2.DATE_CREATED 
								FROM		OE_PRICING_REQUEST_OFFER o INNER JOIN OE_OFFER o2 ON o.OFFER_ID = o2.OFFER_ID 
								WHERE		o.REQUEST_ID = ''' + @p_pricing_request_id + ''' AND o2.STATUS = ''' + @p_offer_status + ''' 
								ORDER BY	o.REQUEST_ID DESC, o2.OFFER_ID ASC'
			END
--	END

EXEC sp_executesql @w_sql
