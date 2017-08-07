CREATE TABLE [dbo].[BillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingType] (
    [Id]                             INT            IDENTITY (1, 1) NOT NULL,
    [BillingTypeUtilityManagementId] INT            NOT NULL,
    [BillingTypeId]                  INT            NOT NULL,
    [Inactive]                       BIT            NOT NULL,
    [CreateBy]                       NVARCHAR (255) NULL,
    [CreateDate]                     DATETIME       NULL,
    [LastModifiedBy]                 NVARCHAR (255) NULL,
    [LastModifiedDate]               DATETIME       NULL,
    CONSTRAINT [PK_BillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingType] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingType_BillingTypeUtilityManagementId] FOREIGN KEY ([BillingTypeUtilityManagementId]) REFERENCES [dbo].[BillingTypeUtilityManagement] ([Id]),
    CONSTRAINT [FK_BillingTypeUtilityManagemntUtilityOfferedBillingTypeToBillingType_BillingType] FOREIGN KEY ([BillingTypeId]) REFERENCES [dbo].[BillingType] ([BillingTypeID])
);


GO



CREATE TRIGGER [dbo].[zAuditBillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingTypeUpdate]
	ON  [dbo].[BillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditBillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingType]
           ([Id]
           ,[BillingTypeUtilityManagementId]
           ,[BillingTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[BillingTypeUtilityManagementId]
           ,[BillingTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END

GO



CREATE TRIGGER [dbo].[zAuditBillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingTypeInsert]
	ON  [dbo].[BillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditBillingTypeUtilityManagementUtilityOfferedBillingTypeToBillingType]
           ([Id]
           ,[BillingTypeUtilityManagementId]
           ,[BillingTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[BillingTypeUtilityManagementId]
           ,[BillingTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END
