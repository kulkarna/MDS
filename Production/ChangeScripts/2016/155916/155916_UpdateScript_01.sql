Use Lp_UtilityManagement
GO
           
		   



            INSERT INTO [Lp_UtilityManagement].[dbo].[LpBillingType]
           ([Id]
           ,[UtilityCompanyId]
           ,[PorDriverId]
           ,[RateClassId]
           ,[LoadProfileId]
           ,[TariffCodeId]
           ,[DefaultBillingTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])   
               
         select
          NEWID()
           , A.[UtilityCompanyId]
           ,A.[PorDriverId]
           ,A.[RateClassId]
           , A.[LoadProfileId]
           , A.[TariffCodeId]
           ,'C39E17D6-8115-437C-98F8-C374281B304E' DefaultBillingTypeId
           , A.inactive
           , max(A.createdBy)createdBy
           ,GETDATE()
           , MAX( A.LastModifiedBy)LastModifiedBy
           ,GETDATE()
from
           [Lp_UtilityManagement].[dbo].[LpBillingType] A (nolock)
           left outer join LpBillingType b ( nolock) on  a.UtilityCompanyId=b.UtilityCompanyId and  a.PorDriverId=b.PorDriverId
           and (a.LoadProfileId=b.LoadProfileId  or a.RateClassId=b.RateClassId
           or a.TariffCodeId=b.TariffCodeId) and a.Inactive=b.Inactive
           
           and A.DefaultBillingTypeId<>b.DefaultBillingTypeId
           where a.UtilityCompanyId in ('04A37847-AF38-4EB7-8C43-6C5595B32336','A3C6B621-C361-4123-BB2C-B79F9484632D')
               and  A.DefaultBillingTypeId='3964C343-999E-4BD0-B32F-50AD53287ED5'
               and b.DefaultBillingTypeId is null
               
               group by
               A.[UtilityCompanyId]
           ,A.[PorDriverId]
           ,A.[RateClassId]
           , A.[LoadProfileId]
           , A.[TariffCodeId]
           ,a.Inactive