USE [LibertyPower]
GO

alter table [dbo].[SalesChannel] add Affinity bit default(0), AffinityProgram varchar(100)
GO

UPDATE [dbo].[SalesChannel] SET [Affinity] = 0
GO
