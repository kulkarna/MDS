alter table Libertypower.dbo.Utility
add AutoApproval bit

alter table Libertypower.dbo.zAuditUtility
add AutoApproval bit

update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'CL&P'
update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'BGE'
update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'DELMD'
update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'PEPCO-MD'
update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'CONED'
update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'NYSEG'
update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'RGE'
update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'PECO'
update libertypower.dbo.utility set AutoApproval = 1 where UtilityCode = 'DUKE'