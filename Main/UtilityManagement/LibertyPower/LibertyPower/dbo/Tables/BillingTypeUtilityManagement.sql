CREATE TABLE [dbo].[BillingTypeUtilityManagement] (
    [Id]                   INT            IDENTITY (1, 1) NOT NULL,
    [UtilityId]            INT            NOT NULL,
    [DriverTypeId]         INT            NOT NULL,
    [DriverTypePropertyId] INT            NOT NULL,
    [DriverTypeValueId]    INT            NOT NULL,
    [DefaultBillingTypeId] INT            NOT NULL,
    [Inactive]             BIT            NOT NULL,
    [CreateBy]             NVARCHAR (255) NULL,
    [CreateDate]           DATETIME       NULL,
    [LastModifiedBy]       NVARCHAR (255) NULL,
    [LastModifiedDate]     DATETIME       NULL,
    CONSTRAINT [PK_BillingTypeUtilityManagement] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BillingTypeUtilityManagement_BillingType] FOREIGN KEY ([DefaultBillingTypeId]) REFERENCES [dbo].[BillingType] ([BillingTypeID]),
    CONSTRAINT [FK_BillingTypeUtilityManagement_DriverType] FOREIGN KEY ([DriverTypeId]) REFERENCES [dbo].[DriverType] ([Id]),
    CONSTRAINT [FK_BillingTypeUtilityManagement_Property_DriverType] FOREIGN KEY ([DriverTypePropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_BillingTypeUtilityManagement_PropertyInternalRef_DriverType] FOREIGN KEY ([DriverTypeValueId]) REFERENCES [dbo].[PropertyInternalRef] ([ID]),
    CONSTRAINT [FK_BillingTypeUtilityManagement_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);


GO



CREATE TRIGGER [dbo].[zAuditBillingTypeUtilityManagementUpdate]
	ON  [dbo].[BillingTypeUtilityManagement]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditBillingTypeUtilityManagement]
           ([Id]
           ,[UtilityId]
           ,[DriverTypeId]
           ,[DriverTypePropertyId]
           ,[DriverTypeValueId]
           ,[DefaultBillingTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[DriverTypeId]
           ,[DriverTypePropertyId]
           ,[DriverTypeValueId]
           ,[DefaultBillingTypeId]
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



CREATE TRIGGER [dbo].[zAuditBillingTypeUtilityManagementInsert]
	ON  [dbo].[BillingTypeUtilityManagement]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditBillingTypeUtilityManagement]
           ([Id]
           ,[UtilityId]
           ,[DriverTypeId]
           ,[DriverTypePropertyId]
           ,[DriverTypeValueId]
           ,[DefaultBillingTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[DriverTypeId]
           ,[DriverTypePropertyId]
           ,[DriverTypeValueId]
           ,[DefaultBillingTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END
