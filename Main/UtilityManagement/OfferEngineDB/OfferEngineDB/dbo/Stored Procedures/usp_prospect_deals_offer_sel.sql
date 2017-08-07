


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/24/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_prospect_deals_offer_sel]

@p_offer_id		varchar(50)

AS

SELECT	CASE WHEN a.AcctName IS NULL THEN '' ELSE a.AcctName END AS AcctName, 
		a.Status, a.AccountNumber, a.DealID, 
		a.Created, a.CreatedBy, 
		CASE WHEN AcctZip IS NULL THEN '' ELSE AcctZip END AS AcctZip, 
		a.Utility,
		CASE WHEN a.Modified IS NULL THEN GETDATE() ELSE a.Modified END AS Modified, 
		CASE WHEN a.ModifiedBy IS NULL THEN '' ELSE a.ModifiedBy END AS ModifiedBy
FROM	lp_historical_info..ProspectDeals a WITH (NOLOCK) 
		INNER JOIN lp_historical_info..ProspectAccounts b WITH (NOLOCK) 
		ON a.DealID = b.[Deal ID] AND a.AccountNumber = b.AccountNumber
WHERE	a.DealID	= @p_offer_id
AND		b.Active	= 1






