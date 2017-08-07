CREATE TABLE [dbo].[RequestModeEnrollmentType] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (50)  NOT NULL,
    [Description]      NVARCHAR (255) NOT NULL,
    [Inactive]         BIT            NOT NULL,
    [CreatedBy]        NVARCHAR (100) NOT NULL,
    [CreatedDate]      DATETIME       NOT NULL,
    [LastModifiedBy]   NVARCHAR (100) NOT NULL,
    [LastModifiedDate] DATETIME       NOT NULL,
    CONSTRAINT [PK_RequestModeEnrollmentType] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO



CREATE TRIGGER [dbo].[zAuditRequestModeEnrollmentTypeUpdate]
	ON  [dbo].[RequestModeEnrollmentType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRequestModeEnrollmentType]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END

GO



CREATE TRIGGER [dbo].[zAuditRequestModeEnrollmentTypeInsert]
	ON  [dbo].[RequestModeEnrollmentType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRequestModeEnrollmentType]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END
