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
           and c.UtilityCompanyId in ('04A37847-AF38-4EB7-8C43-6C5595B32336','A3C6B621-C361-4123-BB2C-B79F9484632D')
          
           )k on a.Id=k.LpBillingTypeId
           
GO




