
CREATE procedure [dbo].[usp_import_account_CHECKACCOUNT]
as
declare @w_getdate                                  datetime
select @w_getdate                                   = getdate()

declare @w_username                                 nchar(100)
select @w_username                                  = 'libertypower\dmarino'
insert into lp_enrollment..check_account
select distinct
       contract_nbr,
       ' ',
        case when ltrim(rtrim(status)) 
                + ltrim(rtrim(sub_status)) = '0100010'
             and  utility_id <> 'CONED'
             then 'CREDIT CHECK'
             when ltrim(rtrim(status)) 
                + ltrim(rtrim(sub_status)) = '0100010'
             and  utility_id = 'CONED'
             then 'PROFITABILITY'
             when ltrim(rtrim(status)) 
                + ltrim(rtrim(sub_status)) = '0300010'
             then 'TPV'
             when ltrim(rtrim(status)) 
                + ltrim(rtrim(sub_status)) = '0300020'
             then 'LETTER'
             when ltrim(rtrim(status)) 
                + ltrim(rtrim(sub_status)) = '0400010'
             then 'DOCUMENTS'
             when ltrim(rtrim(status)) 
                + ltrim(rtrim(sub_status)) = '0400020'
             then 'LETTER'
       end,
       'ENROLLMENT',
       'PENDING',
       '19000101',
       ' ',
       '19000101',
       'INIT LOAD',
       ' ',
       case when ltrim(rtrim(status)) 
          + ltrim(rtrim(sub_status)) = '0100010'
            and  utility_id = 'CONED'
            then 'DEAL-CAPTURE-INIT-LOAD'
            else ' '
       end,
       '19000101',
       ' ',
       '19000101',
       '19000101',
       0,
       @w_username,
       @w_getdate,
       0
from lp_account..account with (NOLOCK INDEX = account_idx)
where (ltrim(rtrim(status)) 
    +  ltrim(rtrim(sub_status))                     = '0100010'
or     ltrim(rtrim(status)) 
    +  ltrim(rtrim(sub_status))                     = '0300010'
or     ltrim(rtrim(status)) 
    +  ltrim(rtrim(sub_status))                     = '0300020'
or     ltrim(rtrim(status)) 
    +  ltrim(rtrim(sub_status))                     = '0400010'
or     ltrim(rtrim(status)) 
    +  ltrim(rtrim(sub_status))                     = '0400020')
and   contract_nbr                                 in ('0134874','0205065','0284936','0285063','0395027','0605125','0635070','0655120','0655120','0675158','0745012','0745038','0812531','1014969','1044962','1064947','1084966','1144850','1174886','1184929')
