CREATE TABLE [dbo].[RequestModeIcap] (
    [Id]                                                                INT            IDENTITY (1, 1) NOT NULL,
    [UtilityId]                                                         INT            NOT NULL,
    [PreEnrollmentRequestModeTypeId]                                    INT            NOT NULL,
    [AddressForPreEnrollment]                                           NVARCHAR (200) NOT NULL,
    [Instructions]                                                      NVARCHAR (500) NOT NULL,
    [IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser] BIT            NOT NULL,
    [Inactive]                                                          BIT            NOT NULL,
    [CreatedBy]                                                         NVARCHAR (100) NOT NULL,
    [CreatedDate]                                                       DATETIME       NOT NULL,
    [LastModifiedBy]                                                    NVARCHAR (100) NOT NULL,
    [LastModifiedDate]                                                  DATETIME       NOT NULL,
    CONSTRAINT [PK_RequestModeIcap] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RequestModeIcap_RequestModeType] FOREIGN KEY ([PreEnrollmentRequestModeTypeId]) REFERENCES [dbo].[RequestModeType] ([Id]),
    CONSTRAINT [FK_RequestModeIcap_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);


GO



CREATE TRIGGER [dbo].[zAuditRequestModeIcapUpdate]
	ON  [dbo].[RequestModeIcap]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRequestModeIcap]
           ([Id]
           ,[UtilityId]
           ,[PreEnrollmentRequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[Instructions]
           ,[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[PreEnrollmentRequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[Instructions]
           ,[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser]
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



CREATE TRIGGER [dbo].[zAuditRequestModeIcapInsert]
	ON  [dbo].[RequestModeIcap]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

INSERT INTO [LibertyPower].[dbo].[zAuditRequestModeIcap]
           ([Id]
           ,[UtilityId]
           ,[PreEnrollmentRequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[Instructions]
           ,[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate])
	SELECT 
		[Id]
           ,[UtilityId]
           ,[PreEnrollmentRequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[Instructions]
           ,[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
	FROM 
		inserted
	
	SET NOCOUNT OFF;
END
