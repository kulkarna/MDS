--/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP 100 *
--  FROM [lp_account].[dbo].[zAudit_account] (nolock) where account_id IN 
--  (
--	SELECT account_id
--	 FROM [lp_account].[dbo].[zAudit_account] (nolock) where account_number IN 
--		('211314072000102', '622315009700055', '666062046600057', '644306100659062', '301269006318064', '255662143200052', '314129303500076')
--  )
-- ORDER BY account_id, audit_change_dt
 
BEGIN TRANSACTION
UPDATE lp_account.dbo.account SET status='01000', sub_status='10'
--, date_flow_start = '2009-08-14 00:00:00.000'
--,date_deenrollment = '2012-01-31'
WHERE account_number in ('211314072000102', '622315009700055', '666062046600057', '644306100659062', '301269006318064', '255662143200052', '314129303500076') 

INSERT INTO [lp_account].[dbo].[account_status_history] 
SELECT  account_id, status, sub_status, getdate(), 'libertypower\rvasconcelos', 'MANUAL UPDATE','', '', '', '', '', '', '', '', getdate()
FROM lp_account.dbo.account (nolock) WHERE account_number in ('211314072000102', '622315009700055', '666062046600057', '644306100659062', '301269006318064', '255662143200052', '314129303500076') 

INSERT INTO lp_account.dbo.account_comments 
(account_id   , date_comment, process_id     , comment   , username   , chgstamp)
SELECT account_id, getdate()   , 'MANUAL UPDATE', 'This was updated as requested by user - SR1-16200562', 'libertypower\rvasconcelos', 0      
FROM lp_account.dbo.account (nolock) WHERE account_number in ('211314072000102', '622315009700055', '666062046600057', '644306100659062', '301269006318064', '255662143200052', '314129303500076') 

-- VERIFICATION:

select * from lp_account..account where account_number IN ('211314072000102', '622315009700055', '666062046600057', '644306100659062', '301269006318064', '255662143200052', '314129303500076')