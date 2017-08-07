


-- SELECT count(*), status, sub_status from lp_account..account  group by status, sub_status order by status, sub_status
   
--exec usp_import_account_delete
CREATE procedure [dbo].[usp_import_account_DELETE]
as

/*
delete tblAccounts
from  Enrollment_Access..tblAccounts a,
      lp_account..account b
where a.AccountNumber = b.account_number
*/

delete lp_account..account_comments
where account_id                                  like 'ACCS%' 

delete lp_account..account_additional_info
where account_id                                  like 'ACCS%' 

delete lp_account..account_address
where account_id                                  like 'ACCS%' 

delete lp_account..account_contact
where account_id                                  like 'ACCS%' 

delete lp_account..account_name
where account_id                                  like 'ACCS%' 

delete lp_account..account_status_history
where account_id                                  like 'ACCS%' 


delete lp_account..account_reason_code_hist
where account_id                                  like 'ACCS%' 

delete lp_enrollment..check_account
where origin                                        = 'INIT LOAD'

delete lp_account..account
from lp_account..account 
where origin                                        = 'INIT LOAD'

delete lp_account..customer_account


