



-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_exec]

@p_offer_id			varchar(50)

AS

DECLARE	@w_offer_id_clone	varchar(50)

-- get new offer id for refresh
EXEC usp_clone_offer_id_sel @p_offer_id, @w_offer_id_clone output

-- insert offer
EXEC usp_clone_offer_ins @p_offer_id, @w_offer_id_clone

-- insert offer accounts
EXEC usp_clone_offer_accounts_ins @p_offer_id, @w_offer_id_clone

-- insert offer aggregates
EXEC usp_clone_offer_aggregates_ins @p_offer_id, @w_offer_id_clone

-- insert offer flow dates
EXEC usp_clone_offer_flow_dates_ins @p_offer_id, @w_offer_id_clone

-- insert offer market prices detail
EXEC usp_clone_offer_market_prices_detail_ins @p_offer_id, @w_offer_id_clone

-- insert offer component details
EXEC usp_clone_offer_component_details_ins @p_offer_id, @w_offer_id_clone

-- insert offer markets
EXEC usp_clone_offer_markets_ins @p_offer_id, @w_offer_id_clone

-- insert offer price files
EXEC usp_clone_offer_price_files_ins @p_offer_id, @w_offer_id_clone

-- insert offer status message
EXEC usp_clone_offer_status_message_ins @p_offer_id, @w_offer_id_clone

-- insert offer utilities
EXEC usp_clone_offer_utilities_ins @p_offer_id, @w_offer_id_clone

-- insert price request offer
EXEC usp_clone_price_request_offer_ins @p_offer_id, @w_offer_id_clone

-- insert offer prospect accounts
EXEC usp_clone_prospectaccounts_by_offer_ins @p_offer_id, @w_offer_id_clone

-- insert offer prospect deals
EXEC usp_clone_prospectdeals_by_offer_ins @p_offer_id, @w_offer_id_clone

-- insert offer historical load by zone
EXEC usp_clone_histloadbyzone_by_offer_ins @p_offer_id, @w_offer_id_clone
