Use lp_utilityManagement
GO
delete a from Lp_UtilityManagement..LpApprovedBillingType a
inner join Lp_UtilityManagement..LpBillingType b on a.LpBillingTypeId=b.Id
where a.CreatedDate>getdate()-1
and  b.UtilityCompanyId in ('66F9FA9E-9C41-462B-ABFC-EB6D17B38B15')

delete a from Lp_UtilityManagement..LpUtilityOfferedBillingType a
inner join Lp_UtilityManagement..LpBillingType b on a.LpBillingTypeId=b.Id
where a.CreatedDate>getdate()-1
and  b.UtilityCompanyId in ('66F9FA9E-9C41-462B-ABFC-EB6D17B38B15')

delete from Lp_UtilityManagement..LpBillingType
where CreatedDate>getdate()-1
and  UtilityCompanyId in ('66F9FA9E-9C41-462B-ABFC-EB6D17B38B15')

