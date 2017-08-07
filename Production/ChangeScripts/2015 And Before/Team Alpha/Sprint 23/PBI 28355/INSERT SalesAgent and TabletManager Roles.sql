USE Libertypower
GO

INSERT INTO [Libertypower].[dbo].[Role]
           ([RoleName]
           ,[DateCreated]
           ,[DateModified]
           ,[CreatedBy]
           ,[ModifiedBy]
           ,[Description])
     VALUES
           ('SalesAgent'
           ,GETDATE()
           ,GETDATE()
           ,2241
           ,2241
           ,'Role for a sales channel agent');

INSERT INTO [Libertypower].[dbo].[Role]
           ([RoleName]
           ,[DateCreated]
           ,[DateModified]
           ,[CreatedBy]
           ,[ModifiedBy]
           ,[Description])
     VALUES
           ('TabletManager'
           ,GETDATE()
           ,GETDATE()
           ,2241
           ,2241
           ,'Manages tablets assigned to sales channels')

GO