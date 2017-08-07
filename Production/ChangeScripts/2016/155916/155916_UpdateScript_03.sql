use Lp_UtilityManagement
GO



INSERT INTO [Lp_UtilityManagement].[dbo].LpApprovedBillingType   
           ([Id]
           ,[LpBillingTypeId]
           ,[ApprovedBillingTypeId] 
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])

select NEWID(), c.id [LpBillingTypeId]
           ,'C39E17D6-8115-437C-98F8-C374281B304E' [LpApprovedBillingType]
           ,a.[Inactive]
           ,a.[CreatedBy]
           ,GETDATE()
           ,a.[LastModifiedBy]
           ,GETDATE()
           

 from LpApprovedBillingType a(NOLOCK)
inner join LpBillingType b(NOLOCK) on a.LpBillingTypeId=b.Id
left outer join LpBillingType c (NOLOCK) on (b.RateClassId=c.RateClassId or b.RateClassId is null)
and (b.TariffCodeId=b.TariffCodeId or b.TariffCodeId is null)
and (b.LoadProfileId=c.LoadProfileId or b.LoadProfileId is null)
and b.UtilityCompanyId=c.UtilityCompanyId and b.PorDriverId=c.PorDriverId
and b.DefaultBillingTypeId<>c.DefaultBillingTypeId
where ApprovedBillingTypeId='3964C343-999E-4BD0-B32F-50AD53287ED5'
and b.UtilityCompanyId in ('04A37847-AF38-4EB7-8C43-6C5595B32336','A3C6B621-C361-4123-BB2C-B79F9484632D')
and b.DefaultBillingTypeId='3964C343-999E-4BD0-B32F-50AD53287ED5'
and( c.DefaultBillingTypeId ='C39E17D6-8115-437C-98F8-C374281B304E' or c.DefaultBillingTypeId is null)









GO




