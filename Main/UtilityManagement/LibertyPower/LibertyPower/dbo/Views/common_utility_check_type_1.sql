CREATE VIEW [dbo].[common_utility_check_type]
AS
SELECT dpa.utility_id, s.StepNumber as [order], dpa.ContractType as contract_type, 'ALL' as por_option, upper(st.Description) as Check_Type
	, case when st.Description='check account' then '*' else Tapproved.CurrentAccountStatus end as wait_status
	, case when st.Description='check account' then 'S01' else Tapproved.CurrentAccountSubStatus end as wait_sub_status
	, Tapproved.NextAccountStatus as approved_status, Tapproved.NextAccountSubStatus as approved_sub_status
	, case when dpa.ContractType not like '%renewal' then isnull(Trejected.NextAccountStatus,'999999') else '07000' end as rejected_status--Trejected.NextAccountStatus 
	, case when dpa.ContractType not like '%renewal' then isnull(Trejected.NextAccountSubStatus,'10') else '80' end as rejected_sub_status--Trejected.NextAccountSubStatus
	, 'CONTRACT' as type_approval, 'Pre-enrollmentChecks' as role_name, isnull(c.PayCommission,0) as commission_on_approval
	, s.DateCreated as date_created, '' as username, 0 as chgstamp
	, dpa.DealScreeningPathID
	, s.DealScreeningStepID
FROM libertypower.dbo.DealScreeningMigrationAssignment_vw dpa
JOIN libertypower.dbo.DealScreeningPath p ON dpa.DealScreeningPathID = p.DealScreeningPathID
JOIN libertypower.dbo.DealScreeningStep s ON p.DealScreeningPathID = s.DealScreeningPathID
LEFT JOIN libertypower.dbo.DealScreeningCommission c ON c.DealScreeningStepID = s.DealScreeningStepID
JOIN libertypower.dbo.DealScreeningStepType st ON s.StepTypeID = st.DealScreeningStepTypeID
JOIN libertypower.dbo.DealScreeningTransition Tapproved ON s.DealScreeningStepID = Tapproved.DealScreeningStepID and Tapproved.Disposition = 'APPROVED'
JOIN libertypower.dbo.DealScreeningTransition Trejected ON s.DealScreeningStepID = Trejected.DealScreeningStepID and Trejected.Disposition = 'REJECTED'
WHERE dpa.rownum = 1