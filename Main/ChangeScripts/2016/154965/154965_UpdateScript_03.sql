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
     
     select 
        NEWID()
          , id [LpBillingTypeId]
           ,'C39E17D6-8115-437C-98F8-C374281B304E' [ApprovedBillingTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,GETDATE()
           ,[LastModifiedBy]
           ,GETDATE()
           from  LpBillingType A
           where DefaultBillingTypeId='C39E17D6-8115-437C-98F8-C374281B304E'
           and UtilityCompanyId in ('44D86050-0962-4F7E-8A46-8F3B54A5FA87')
            and exists
               (
                  select * from LpApprovedBillingType(NOLOCK) B
                  where A.Id=b.LpBillingTypeId  and a.Inactive=0 and B.ApprovedBillingTypeId not in 
                  (
                     'C39E17D6-8115-437C-98F8-C374281B304E'
                  )
               )
               
         union
         select 
        NEWID()
          , id [LpBillingTypeId]
           ,'C39E17D6-8115-437C-98F8-C374281B304E' [ApprovedBillingTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,GETDATE()
           ,[LastModifiedBy]
           ,GETDATE()
           from  LpBillingType A
           where DefaultBillingTypeId='C39E17D6-8115-437C-98F8-C374281B304E'
           and UtilityCompanyId in ('66F9FA9E-9C41-462B-ABFC-EB6D17B38B15')
            and not  exists
               (
                  select * from LpApprovedBillingType(NOLOCK) B
                  where A.Id=b.LpBillingTypeId   and a.Inactive=0
                  and B.ApprovedBillingTypeId  in 
                  (
                     'C39E17D6-8115-437C-98F8-C374281B304E'
                     
                  )
                  
               )
         
          
          
           
          
GO




