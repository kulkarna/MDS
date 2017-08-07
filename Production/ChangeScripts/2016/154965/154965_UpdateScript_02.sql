use Lp_UtilityManagement
GO


           INSERT INTO [Lp_UtilityManagement].[dbo].[LpUtilityOfferedBillingType]
           ([Id]
           ,[LpBillingTypeId]
           ,[UtilityOfferedBillingTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
            select NEWID(), a.id [LpBillingTypeId]
           ,'C39E17D6-8115-437C-98F8-C374281B304E' [UtilityOfferedBillingTypeId]
           ,a.[Inactive]
           ,a.[CreatedBy]
           ,GETDATE()
           ,a.[LastModifiedBy]
           ,GETDATE()
           
           
            from
            LpBillingType(NOLOCK) a
           inner join 
           (
              select  d.Id,c.id LpBillingTypeId,c.RateClassId,c.TariffCodeId,c.LoadProfileId,c.UtilityCompanyId
             ,c.DefaultBillingTypeId,d.UtilityOfferedBillingTypeId,c.PorDriverId
              from  LpBillingType(NOLOCK) c
           left outer join LpUtilityOfferedBillingType(NOLOCK) d on c.Id=d.LpBillingTypeId
           where c.DefaultBillingTypeId='C39E17D6-8115-437C-98F8-C374281B304E' 
           and c.UtilityCompanyId in ('66F9FA9E-9C41-462B-ABFC-EB6D17B38B15','44D86050-0962-4F7E-8A46-8F3B54A5FA87')
          
           )k on a.Id=k.LpBillingTypeId
           
GO




