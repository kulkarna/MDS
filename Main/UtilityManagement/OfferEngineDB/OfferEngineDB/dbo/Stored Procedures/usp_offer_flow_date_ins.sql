-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_flow_date_ins]

@p_offer_id				varchar(50),
@p_flow_start_date_id	varchar(50),
@p_flow_start_date		datetime

AS

INSERT INTO	OE_OFFER_FLOW_DATES (FLOW_START_DATE_ID, OFFER_ID, FLOW_START_DATE)
VALUES		(@p_flow_start_date_id, @p_offer_id, @p_flow_start_date)

IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	SELECT 1
ELSE
	SELECT 0
