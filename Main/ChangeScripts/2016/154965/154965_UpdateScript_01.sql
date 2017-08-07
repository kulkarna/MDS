
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
           , A.createdBy
           ,GETDATE()
           ,  A.LastModifiedBy
           ,GETDATE() 
          
         from
           [Lp_UtilityManagement].[dbo].[LpBillingType] A
           left outer join LpBillingType b  on  a.UtilityCompanyId=b.UtilityCompanyId and  a.PorDriverId=b.PorDriverId
           and (a.LoadProfileId=b.LoadProfileId  or a.RateClassId=b.RateClassId
           or a.TariffCodeId=b.TariffCodeId) and a.Inactive=b.Inactive
           
           and A.DefaultBillingTypeId<>b.DefaultBillingTypeId
           where a.UtilityCompanyId in ('66F9FA9E-9C41-462B-ABFC-EB6D17B38B15','44D86050-0962-4F7E-8A46-8F3B54A5FA87')
               and  A.DefaultBillingTypeId='3964C343-999E-4BD0-B32F-50AD53287ED5'
               and b.DefaultBillingTypeId is null