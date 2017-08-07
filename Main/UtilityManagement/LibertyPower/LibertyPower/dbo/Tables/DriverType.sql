CREATE TABLE [dbo].[DriverType] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [DriverName]        NVARCHAR (50)  NOT NULL,
    [DriverDescription] NVARCHAR (255) NOT NULL,
    [CreateBy]          NVARCHAR (255) NULL,
    [CreateDate]        DATETIME       NULL,
    [LastModifiedBy]    NVARCHAR (255) NULL,
    [LastModifiedDate]  DATETIME       NULL,
    [inactive]          BIT            NOT NULL,
    CONSTRAINT [PK_DriverType] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO


CREATE TRIGGER [dbo].[zAuditDriverTypeInsert]
	ON  [dbo].[DriverType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditDriverType]
           ([Id]
           ,[DriverName]
           ,[DriverDescription]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[inactive])
	SELECT 
		[Id]
           ,[DriverName]
           ,[DriverDescription]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[inactive]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END



GO


CREATE TRIGGER [dbo].[zAuditDriverTypeUpdate]
	ON  [dbo].[DriverType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditDriverType]
           ([Id]
           ,[DriverName]
           ,[DriverDescription]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[inactive])
	SELECT 
		[Id]
           ,[DriverName]
           ,[DriverDescription]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[inactive]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END


