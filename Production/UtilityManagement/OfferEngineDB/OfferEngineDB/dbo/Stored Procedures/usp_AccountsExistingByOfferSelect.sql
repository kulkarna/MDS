
/*******************************************************************************
 * usp_AccountsExistingByOfferSelect
 * Gets existing account data for accounts in offer
 *
 * History
 *******************************************************************************
 * 10/27/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountsExistingByOfferSelect]
	@OfferId	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

SELECT		acc.account_number AS AccountNumber, acc.utility_id AS UtilityCode,
			ISNULL(s.status_descp, '') + ' - ' + ISNULL(s.sub_status_descp, '') AS [Status], 
			ISNULL(p.product_descp, '') AS Product, acc.rate AS Rate, acc.date_flow_start AS FlowStartDate, 
			acc.date_end AS EndDate, acc.term_months AS Term
FROM		OE_ACCOUNT a WITH (NOLOCK) 
			INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
			INNER JOIN lp_account..account acc ON a.ACCOUNT_NUMBER = acc.account_number		
			LEFT JOIN lp_account..status_convertion s ON acc.status = s.status AND acc.sub_status = s.sub_status
			INNER JOIN lp_common..common_product p ON acc.product_id = p.product_id
WHERE		b.OFFER_ID = @OfferId
ORDER BY	a.UTILITY, a.ACCOUNT_NUMBER

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


