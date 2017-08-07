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
     
     select 
        NEWID()
          , id [LpBillingTypeId]
           ,'C39E17D6-8115-437C-98F8-C374281B304E' [UtilityOfferedBillingTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,GETDATE()
           ,[LastModifiedBy]
           ,GETDATE()
           
           from  LpBillingType a
           where DefaultBillingTypeId='C39E17D6-8115-437C-98F8-C374281B304E'
           and UtilityCompanyId in ('44D86050-0962-4F7E-8A46-8F3B54A5FA87')
           and exists
               (
                  select * from LpUtilityOfferedBillingType(NOLOCK) B
                  where A.Id=b.LpBillingTypeId  and A.Inactive=0 and B.UtilityOfferedBillingTypeId not in 
                  (
                     'C39E17D6-8115-437C-98F8-C374281B304E'
                  )
               )    
        
        union
        
         select 
        NEWID()
          , id [LpBillingTypeId]
           ,'C39E17D6-8115-437C-98F8-C374281B304E' [UtilityOfferedBillingTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,GETDATE()
           ,[LastModifiedBy]
           ,GETDATE()
           
           from  LpBillingType a
           where DefaultBillingTypeId='C39E17D6-8115-437C-98F8-C374281B304E'
           and UtilityCompanyId in ('66F9FA9E-9C41-462B-ABFC-EB6D17B38B15')
           and exists
               (
                  select * from LpUtilityOfferedBillingType(NOLOCK) B
                  where A.Id=b.LpBillingTypeId  and A.Inactive=0 and B.UtilityOfferedBillingTypeId not in 
                  (
                     'C39E17D6-8115-437C-98F8-C374281B304E'
                  )
               )
               
           
             
          
GO




