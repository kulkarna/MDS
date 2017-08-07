-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/15/2008
-- Description:	Delete incomplete deals and renewals older than 2 weeks
-- =============================================
CREATE PROCEDURE [dbo].[usp_incomplete_deals_and_renewals_del]

AS

DECLARE	@w_delete_date	datetime
SET		@w_delete_date = DATEADD(dd, -1, GETDATE())

SELECT	contract_nbr
INTO #DELETE_THESE
FROM	lp_deal_capture..deal_contract
WHERE	date_created < @w_delete_date
AND contract_nbr NOT IN (SELECT [Contract] FROM OrderManagement.dbo.WorkItemContract)
UNION
SELECT	contract_nbr
FROM	lp_contract_renewal..deal_contract
WHERE	date_created < @w_delete_date
AND contract_nbr NOT IN (SELECT [Contract] FROM OrderManagement.dbo.WorkItemContract)



-- lp_deal_capture  -------------------------------
DELETE FROM	lp_deal_capture..deal_address
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

DELETE FROM	lp_deal_capture..deal_contact
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

DELETE FROM	lp_deal_capture..deal_name
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

DELETE FROM	lp_deal_capture..deal_contract_account
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

DELETE FROM	lp_deal_capture..deal_contract
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)


-- lp_contract_renewal  -----------------------------
DELETE FROM	lp_contract_renewal..deal_address
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

DELETE FROM	lp_contract_renewal..deal_contact
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

DELETE FROM	lp_contract_renewal..deal_name
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

DELETE FROM	lp_contract_renewal..deal_contract_account
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

DELETE FROM	lp_contract_renewal..deal_contract
WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)
