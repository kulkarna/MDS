
/*******************************************************************************
 * usp_814ServiceTransactionsSelect
 * Get 814 service transactions for given key
 *
 * History
 *******************************************************************************
 * 10/28/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_814ServiceTransactionsSelect]                                                                                     
	@Key814	int
AS
BEGIN
    SET NOCOUNT ON;

	-- service table
	SELECT		DISTINCT m.AccountNumber, m. [814_Key], m.ServiceType2, m.TransactionStatus, m.FlowStartDate, m.DeEnrollmentDate
	FROM		integration..EDI_814_transaction t WITH (NOLOCK)
				INNER JOIN integration..EDI_814_transaction_result tr WITH (NOLOCK) ON t.EDI_814_transaction_id = tr.EDI_814_transaction_id 
				INNER JOIN
				(
					SELECT	DISTINCT a.esiid as AccountNumber, a.[814_Key], c.TransactionNbr, 
							a.ServiceType2, a.ActionCode TransactionStatus, 
							CAST(a.EsiidStartDate AS datetime) AS FlowStartDate, CAST(a.EsiidEndDate AS datetime) AS DeEnrollmentDate
					FROM	ISTA..tbl_814_header c WITH (NOLOCK)
							LEFT JOIN ISTA..tbl_814_Service a WITH (NOLOCK) ON a.[814_key] = c.[814_key]
					WHERE	c.[814_Key] = @Key814 
				) m ON m.TransactionNbr = t.transaction_number
	WHERE		lp_transaction_id in (3, 4, 7, 8)
	AND			t.action_code <> 'C' 
	ORDER BY	m.[814_Key]

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

