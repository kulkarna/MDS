BEGIN TRANSACTION
UPDATE lp_account.dbo.account
SET status='05000', sub_status='30'--, date_flow_start = '2009-08-14 00:00:00.000'
WHERE account_number in ('08006570890000027069')

INSERT INTO [lp_account].[dbo].[account_status_history]
SELECT  account_id, status, sub_status, getdate(), 'libertypower\rvasconcelos', 'MANUAL UPDATE',
'', '', '', '', '', '', '', '', getdate()
FROM lp_account.dbo.account
WHERE account_number in ('08006570890000027069')

INSERT INTO lp_account.dbo.account_comments
(account_id   , date_comment, process_id     , comment   , username   , chgstamp)
SELECT account_id, getdate()   , 'MANUAL UPDATE', 'This was updated as requested by user - SR1-15130862', 'libertypower\rvasconcelos', 0      
FROM lp_account.dbo.account WHERE account_number in ('08006570890000027069')

-- VERIFICATION:
select * from lp_account..account where account_number = '08006570890000027069'
