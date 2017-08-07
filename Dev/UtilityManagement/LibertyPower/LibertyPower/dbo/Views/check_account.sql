CREATE VIEW check_account
AS

SELECT distinct d.ContractNumber as contract_nbr
	, '' as account_id
	, dst.description as check_type
	, case when a.contract_type like '%renewal' OR ar.contract_type like '%renewal' then 'RENEWAL' else 'ENROLLMENT' end as check_request_id
	, d.Disposition as approval_status
	, d.DateCreated as approval_status_date
	, d.Comments as approval_comments
	, d.DateDispositioned as approval_eff_date
	, 'ONLINE' as origin
	, '' as userfield_text_01
	, '' as userfield_text_02
	, '1900-01-01 00:00:00.000' as userfield_text_03
	, '' as userfield_text_04
	, '1900-01-01 00:00:00.000' as userfield_text_05
	, '1900-01-01 00:00:00.000' as userfield_text_06
	, 0 as userfield_amt_07
	, d.UserName as username
	, d.DateCreated as date_created	
	, 0 as chgstamp
FROM LibertyPower.dbo.DealScreening d
JOIN LibertyPower.dbo.DealScreeningStepType dst ON d.StepTypeID = dst.DealScreeningStepTypeID
LEFT JOIN (select distinct contract_nbr, contract_type from lp_account..zaudit_account_renewal) ar ON d.contractnumber = ar.contract_nbr
LEFT JOIN lp_account..account a ON d.contractnumber = a.contract_nbr