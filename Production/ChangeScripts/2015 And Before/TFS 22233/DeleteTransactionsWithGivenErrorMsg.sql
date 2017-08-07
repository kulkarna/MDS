delete from integration.dbo.EDI_814_transaction_result 
where error_msg like 'Transaction Date is older than the last Modified Date for the Account'

