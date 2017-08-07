CREATE TABLE [dbo].[DealScreeningPathAssignment] (
    [DealScreeningPathAssignmentID] INT          IDENTITY (1, 1) NOT NULL,
    [Market]                        VARCHAR (50) NULL,
    [Utility]                       VARCHAR (50) NULL,
    [ContractType]                  VARCHAR (50) NULL,
    [POR]                           VARCHAR (50) NULL,
    [AccountTypeID]                 VARCHAR (50) NULL,
    [ProductCategory]               VARCHAR (50) NULL,
    [EnrollmentType]                INT          NULL,
    [BillingType]                   VARCHAR (50) NULL,
    [IsCustomPricing]               INT          NULL,
    [SalesChannelType]              VARCHAR (50) NULL,
    [TPVVendor]                     VARCHAR (50) NULL,
    [DealScreeningPathID]           INT          NOT NULL,
    [InitialStatus]                 VARCHAR (50) NULL,
    [InitialSubStatus]              VARCHAR (50) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DealScreeningPathAssignment';

