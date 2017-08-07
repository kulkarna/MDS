CREATE TABLE [dbo].[BillingTypeUtilityManagementApprovedLpBillingTypeToBillingType] (
    [Id]                             INT            IDENTITY (1, 1) NOT NULL,
    [BillingTypeUtilityManagementId] INT            NOT NULL,
    [BillingTypeId]                  INT            NOT NULL,
    [Inactive]                       BIT            NOT NULL,
    [CreateBy]                       NVARCHAR (255) NULL,
    [CreateDate]                     DATETIME       NULL,
    [LastModifiedBy]                 NVARCHAR (255) NULL,
    [LastModifiedDate]               DATETIME       NULL,
    CONSTRAINT [PK_BillingTypeUtilityManagementApprovedLpBillingTypeToBillingType] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BillingTypeUtilityManagementApprovedLpBillingTypeToBillingType_BillingType] FOREIGN KEY ([BillingTypeId]) REFERENCES [dbo].[BillingType] ([BillingTypeID]),
    CONSTRAINT [FK_BillingTypeUtilityManagementApprovedLpBillingTypeToBillingType_BillingTypeUtilityManagement] FOREIGN KEY ([BillingTypeUtilityManagementId]) REFERENCES [dbo].[BillingTypeUtilityManagement] ([Id])
);


GO



CREATE TRIGGER [dbo].[zAuditBillingTypeUtilityManagementApprovedLpBillingTypeToBillingTypeInsert]
	ON  [dbo].[BillingTypeUtilityManagementApprovedLpBillingTypeToBillingType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditBillingTypeUtilityManagementApprovedLpBillingTypeToBillingType]
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



CREATE TRIGGER [dbo].[zAuditBillingTypeUtilityManagementApprovedLpBillingTypeToBillingTypeUpdate]
	ON  [dbo].[BillingTypeUtilityManagementApprovedLpBillingTypeToBillingType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditBillingTypeUtilityManagementApprovedLpBillingTypeToBillingType]
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
