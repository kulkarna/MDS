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
           and UtilityCompanyId in ('04A37847-AF38-4EB7-8C43-6C5595B32336')
             and exists
               (
                  select * from LpApprovedBillingType(NOLOCK) B
                  where A.Id=b.LpBillingTypeId  and A.inactive=0 and B.ApprovedBillingTypeId not in 
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
           and UtilityCompanyId in ('A3C6B621-C361-4123-BB2C-B79F9484632D')
            and exists
               (
                  select * from LpApprovedBillingType(NOLOCK) B
                  where A.Id=b.LpBillingTypeId and A.inactive=0 and B.ApprovedBillingTypeId not in 
                  (
                     'C39E17D6-8115-437C-98F8-C374281B304E'
                  )
               )
         
          
          
           
          
GO




