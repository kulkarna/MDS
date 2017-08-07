CREATE TABLE [dbo].[TariffCodeUtilityManagement] (
    [Id]                           INT            IDENTITY (1, 1) NOT NULL,
    [UtilityId]                    INT            NOT NULL,
    [RateClassUtilityManagementId] INT            NOT NULL,
    [TariffCodePropertyId]         INT            NOT NULL,
    [TariffCodeValueId]            INT            NOT NULL,
    [TariffCodeDescription]        NVARCHAR (255) NULL,
    [AccountTypeId]                INT            NOT NULL,
    [Inactive]                     BIT            NOT NULL,
    [CreateBy]                     NVARCHAR (255) NULL,
    [CreateDate]                   DATETIME       NULL,
    [LastModifiedBy]               NVARCHAR (255) NULL,
    [LastModifiedDate]             DATETIME       NULL,
    CONSTRAINT [PK_TariffCodeUtilityManagement] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TariffCodeUtilityManagement_AccountType] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountType] ([ID]),
    CONSTRAINT [FK_TariffCodeUtilityManagement_Property_TariffCode] FOREIGN KEY ([TariffCodePropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_TariffCodeUtilityManagement_PropertyInternalRef_TariffCode] FOREIGN KEY ([TariffCodeValueId]) REFERENCES [dbo].[PropertyInternalRef] ([ID]),
    CONSTRAINT [FK_TariffCodeUtilityManagement_RateClassUtilityManagement] FOREIGN KEY ([RateClassUtilityManagementId]) REFERENCES [dbo].[RateClassUtilityManagement] ([Id]),
    CONSTRAINT [FK_TariffCodeUtilityManagement_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);


GO



CREATE TRIGGER [dbo].[zAuditTariffCodeUtilityManagementUpdate]
	ON  [dbo].[TariffCodeUtilityManagement]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditTariffCodeUtilityManagement]
           ([Id]
           ,[UtilityId]
           ,[RateClassUtilityManagementId]
           ,[TariffCodePropertyId]
           ,[TariffCodeValueId]
           ,[TariffCodeDescription]
           ,[AccountTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[RateClassUtilityManagementId]
           ,[TariffCodePropertyId]
           ,[TariffCodeValueId]
           ,[TariffCodeDescription]
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



CREATE TRIGGER [dbo].[zAuditTariffCodeUtilityManagementInsert]
	ON  [dbo].[TariffCodeUtilityManagement]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditTariffCodeUtilityManagement]
           ([Id]
           ,[UtilityId]
           ,[RateClassUtilityManagementId]
           ,[TariffCodePropertyId]
           ,[TariffCodeValueId]
           ,[TariffCodeDescription]
           ,[AccountTypeId]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[RateClassUtilityManagementId]
           ,[TariffCodePropertyId]
           ,[TariffCodeValueId]
           ,[TariffCodeDescription]
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
