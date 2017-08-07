CREATE TABLE [dbo].[PurchaseOfReceivables] (
    [Id]                        INT            IDENTITY (1, 1) NOT NULL,
    [UtilityId]                 INT            NOT NULL,
    [DriverTypeId]              INT            NOT NULL,
    [DriverValuePropertyId]     INT            NOT NULL,
    [DriverValueValueId]        INT            NOT NULL,
    [PorOffered]                BIT            NOT NULL,
    [PorParticipated]           BIT            NOT NULL,
    [DoesPorRecourseExist]      BIT            NOT NULL,
    [PorRisk]                   BIT            NOT NULL,
    [PorDiscountRate]           DECIMAL (18)   NULL,
    [PorFlatFee]                DECIMAL (18)   NULL,
    [PorDiscountEffectiveDate]  DATETIME       NULL,
    [PorDiscountExpirationDate] DATETIME       NOT NULL,
    [Inactive]                  BIT            NOT NULL,
    [CreateBy]                  NVARCHAR (255) NULL,
    [CreateDate]                DATETIME       NULL,
    [LastModifiedBy]            NVARCHAR (255) NULL,
    [LastModifiedDate]          DATETIME       NULL,
    CONSTRAINT [PK_PurchaseOfReceivables] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PurchaseOfReceivables_DriverType] FOREIGN KEY ([DriverTypeId]) REFERENCES [dbo].[DriverType] ([Id]),
    CONSTRAINT [FK_PurchaseOfReceivables_Property_DriverValue] FOREIGN KEY ([DriverValuePropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_PurchaseOfReceivables_PropertyInternalRef_DriverValue] FOREIGN KEY ([DriverValueValueId]) REFERENCES [dbo].[PropertyInternalRef] ([ID]),
    CONSTRAINT [FK_PurchaseOfReceivables_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);


GO


CREATE TRIGGER [dbo].[zAuditPurchaseOfReceivablesUpdate]
	ON  [dbo].[PurchaseOfReceivables]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditPurchaseOfReceivables]
           ([Id]
           ,[UtilityId]
           ,[DriverTypeId]
           ,[DriverValuePropertyId]
           ,[DriverValueValueId]
           ,[PorOffered]
           ,[PorParticipated]
           ,[DoesPorRecourseExist]
           ,[PorRisk]
           ,[PorDiscountRate]
           ,[PorFlatFee]
           ,[PorDiscountEffectiveDate]
           ,[PorDiscountExpirationDate]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[DriverTypeId]
           ,[DriverValuePropertyId]
           ,[DriverValueValueId]
           ,[PorOffered]
           ,[PorParticipated]
           ,[DoesPorRecourseExist]
           ,[PorRisk]
           ,[PorDiscountRate]
           ,[PorFlatFee]
           ,[PorDiscountEffectiveDate]
           ,[PorDiscountExpirationDate]
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


CREATE TRIGGER [dbo].[zAuditPurchaseOfReceivablesInsert]
	ON  [dbo].[PurchaseOfReceivables]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditPurchaseOfReceivables]
           ([Id]
           ,[UtilityId]
           ,[DriverTypeId]
           ,[DriverValuePropertyId]
           ,[DriverValueValueId]
           ,[PorOffered]
           ,[PorParticipated]
           ,[DoesPorRecourseExist]
           ,[PorRisk]
           ,[PorDiscountRate]
           ,[PorFlatFee]
           ,[PorDiscountEffectiveDate]
           ,[PorDiscountExpirationDate]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[DriverTypeId]
           ,[DriverValuePropertyId]
           ,[DriverValueValueId]
           ,[PorOffered]
           ,[PorParticipated]
           ,[DoesPorRecourseExist]
           ,[PorRisk]
           ,[PorDiscountRate]
           ,[PorFlatFee]
           ,[PorDiscountEffectiveDate]
           ,[PorDiscountExpirationDate]
           ,[Inactive]
           ,[CreateBy]
           ,[CreateDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END


