CREATE TABLE [dbo].[RateClassUtilityManagement] (
    [Id]                   INT            IDENTITY (1, 1) NOT NULL,
    [UtilityId]            INT            NOT NULL,
    [RateClassPropertyId]  INT            NOT NULL,
    [RateClassValueId]     INT            NOT NULL,
    [RateClassDescription] NVARCHAR (255) NULL,
    [AccountTypeId]        INT            NOT NULL,
    [Inactive]             BIT            NOT NULL,
    [CreateBy]             NVARCHAR (255) NULL,
    [CreateDate]           DATETIME       NULL,
    [LastModifiedBy]       NVARCHAR (255) NULL,
    [LastModifiedDate]     DATETIME       NULL,
    CONSTRAINT [PK_RateClassUtilityManagement] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RateClassUtilityManagement_AccountType] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountType] ([ID]),
    CONSTRAINT [FK_RateClassUtilityManagement_Property_RateClass] FOREIGN KEY ([RateClassPropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_RateClassUtilityManagement_PropertyInternalRef_RateClass] FOREIGN KEY ([RateClassValueId]) REFERENCES [dbo].[PropertyInternalRef] ([ID]),
    CONSTRAINT [FK_RateClassUtilityManagement_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);


GO



CREATE TRIGGER [dbo].[zAuditRateClassUtilityManagementInsert]
	ON  [dbo].[RateClassUtilityManagement]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRateClassUtilityManagement]
           ([Id]
           ,[UtilityId]
           ,[RateClassPropertyId]
           ,[RateClassValueId]
           ,[RateClassDescription]
           ,[AccountTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[RateClassPropertyId]
           ,[RateClassValueId]
           ,[RateClassDescription]
           ,[AccountTypeId]
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



CREATE TRIGGER [dbo].[zAuditRateClassUtilityManagementUpdate]
	ON  [dbo].[RateClassUtilityManagement]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRateClassUtilityManagement]
           ([Id]
           ,[UtilityId]
           ,[RateClassPropertyId]
           ,[RateClassValueId]
           ,[RateClassDescription]
           ,[AccountTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[RateClassPropertyId]
           ,[RateClassValueId]
           ,[RateClassDescription]
           ,[AccountTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END
