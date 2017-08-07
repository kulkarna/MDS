
/*******************************************************************************
 * usp_Unprocessed814TransactionsSelect
 * Get unprocessed 814 transactions for accepted enrollment, 
 * reenrollment, and deenrollment responses.
 *
 * History
 *******************************************************************************
 * 5/5/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_Unprocessed814TransactionsSelect]                                                                                     
	@Key814	int
AS
BEGIN
    SET NOCOUNT ON;

	-- This subset of the header table should help make future queries run faster.
	SELECT	DISTINCT h.[814_Key], TdspDuns AS UtilityDuns, TransactionNbr, Direction
	INTO #temp_header
	FROM ISTA..tbl_814_header h (NOLOCK)
	WHERE h.[814_Key] > @Key814 
	AND h.actioncode not in ('HU','C')
	AND h.direction = 1
	
	-- Gathering all header data
	SELECT		DISTINCT m.[814_Key], m.UtilityDuns, m.Direction, tr.lp_transaction_id AS ResponseType, LibertyPowerReasonCode = tr.lp_reasoncode
	INTO #Header
	FROM		integration..EDI_814_transaction t (NOLOCK)
				INNER JOIN integration..EDI_814_transaction_result tr (NOLOCK) ON t.EDI_814_transaction_id = tr.EDI_814_transaction_id 
				INNER JOIN
				(
					SELECT	DISTINCT h.[814_Key], UtilityDuns, TransactionNbr, Direction
					FROM #temp_header h (NOLOCK)
					JOIN ISTA..tbl_814_service s (NOLOCK) ON h.[814_key] = s.[814_key] -- This JOIN is to ensure that we only get header records which have matching service records.
				) m ON m.TransactionNbr = t.transaction_number
	WHERE lp_transaction_id in (3, 4, 6, 7, 8)
	AND t.action_code not in ('HU','C')
	ORDER BY	m.[814_Key]
	
	SELECT * FROM #Header

	-- Gathering all service data.  There can be several service records per header.
	SELECT		DISTINCT m.AccountNumber, m.[814_Key], m.ServiceType2, m.TransactionStatus, m.FlowStartDate, m.DeEnrollmentDate
	FROM		integration..EDI_814_transaction t (NOLOCK)
				INNER JOIN integration..EDI_814_transaction_result tr (NOLOCK) ON t.EDI_814_transaction_id = tr.EDI_814_transaction_id 
				INNER JOIN
				(
					SELECT	DISTINCT a.esiid as AccountNumber, a.[814_Key], c.TransactionNbr, 
							a.ServiceType2, a.ActionCode TransactionStatus, 
							CAST(a.EsiidStartDate AS datetime) AS FlowStartDate, CAST(a.EsiidEndDate AS datetime) AS DeEnrollmentDate
					FROM	ISTA..tbl_814_header c (NOLOCK)
							LEFT JOIN ISTA..tbl_814_Service a (NOLOCK) ON a.[814_key] = c.[814_key]
					--WHERE	c.[814_Key] > @Key814 
					WHERE c.[814_Key] in (select [814_Key] from #Header) -- will greatly reduce the amount records being processed later.
				) m ON m.TransactionNbr = t.transaction_number
	WHERE lp_transaction_id in (3, 4, 6, 7, 8)
	AND t.action_code not in ('HU','C')
	AND m.[814_Key] is not null
	ORDER BY	m.[814_Key]

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

