CREATE TABLE [dbo].[zAuditRequestModeIcap] (
    [Id]                                                                INT            NOT NULL,
    [UtilityId]                                                         INT            NOT NULL,
    [PreEnrollmentRequestModeTypeId]                                    INT            NOT NULL,
    [AddressForPreEnrollment]                                           NVARCHAR (200) NOT NULL,
    [Instructions]                                                      NVARCHAR (500) NOT NULL,
    [IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser] BIT            NOT NULL,
    [Inactive]                                                          BIT            NOT NULL,
    [CreatedBy]                                                         NVARCHAR (100) NOT NULL,
    [CreatedDate]                                                       DATETIME       NOT NULL,
    [LastModifiedBy]                                                    NVARCHAR (100) NOT NULL,
    [LastModifiedDate]                                                  DATETIME       NOT NULL
);

