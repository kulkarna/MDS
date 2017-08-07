USE [Workspace]
GO

INSERT INTO [dbo].[AuditRunEdiAccount]
           ([AuditRunDate]
           ,[FromDate]
           ,[ToDate])
     VALUES
           (Getdate()
           ,'08/01/2014'
           ,'08/02/2014')
GO


