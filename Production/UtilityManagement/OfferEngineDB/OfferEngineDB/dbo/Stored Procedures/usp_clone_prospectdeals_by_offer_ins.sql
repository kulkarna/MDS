-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/16/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_prospectdeals_by_offer_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

INSERT INTO	lp_historical_info..ProspectDeals
SELECT		Utility, AccountNumber, @p_offer_id_clone, AcctName, AcctZip, Status, 
			GETDATE(), CreatedBy, NULL, NULL, MeterNumber
FROM		lp_historical_info..ProspectDeals
WHERE		DealID = @p_offer_id
