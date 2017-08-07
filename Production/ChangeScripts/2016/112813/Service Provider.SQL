use Libertypower
go

-- DROP Statements here since the order matters
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderServiceRequest]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderServiceRequest]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderTransactionRequest]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderTransactionRequest]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderTransactionType]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderTransactionType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderServiceDeterminant]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderServiceDeterminant]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderService]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderService]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceDeterminantValue]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceDeterminantValue]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceDeterminant]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceDeterminant]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderContact]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderContact]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderServiceStatusHistory]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderServiceStatusHistory]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderServiceStatus]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderServiceStatus]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProvider]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProvider]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceProviderIntegrationMethod]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceProviderIntegrationMethod]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ServiceType]') AND type in (N'U'))
    DROP TABLE [dbo].[ServiceType]
GO
---------------------------------------------------------------------------------------------------------------

-- CREATE statements
CREATE TABLE [dbo].[ServiceProviderServiceRequest] (
 [SpServiceRequestId] INTEGER Identity(1,1)  NOT NULL  
, [SpServiceId] INTEGER  NOT NULL  
, [SpTransactionRequestId] INTEGER  NOT NULL  
, [SpIntegrationMethodId] INTEGER  NOT NULL  
, [IntegrationPackageName] CHAR(500)  NULL  
, [IntegrationMethodPathOut] CHAR(500)  NULL  
, [IntegrationMethodPathIn] CHAR(500)  NULL  
, [IntegrationMethodSpecOut] CHAR(500)  NULL  
, [IntegrationMethodSpecIn] CHAR(500)  NULL  
, [IntegrationMethodInputData] CHAR(500)  NOT NULL  
, [IsAlternate] BIT  NULL  
, [DateCreated] DATETIME  NOT NULL 
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderServiceRequest] ADD CONSTRAINT [ServiceProviderServiceRequest_PK] PRIMARY KEY CLUSTERED (
[SpServiceRequestId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProviderTransactionType] (
[SpTransactionTypeId] INTEGER Identity(1,1)  NOT NULL  
, [Name] VARCHAR(50)  NOT NULL  
, [Description] VARCHAR(100)  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderTransactionType] ADD CONSTRAINT [ServiceProviderTransactionType_PK] PRIMARY KEY CLUSTERED (
[SpTransactionTypeId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProviderService] (
[SpServiceId] INTEGER Identity(1,1)  NOT NULL  
, [ServiceProviderId] INTEGER  NOT NULL  
, [ServiceTypeId] INTEGER  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderService] ADD CONSTRAINT [ServiceProviderService_PK] PRIMARY KEY CLUSTERED (
[SpServiceId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProviderTransactionRequest] (
[SpTransactionRequestId] INTEGER Identity(1,1)  NOT NULL  
, [Name] VARCHAR(50)  NOT NULL  
, [Description] VARCHAR(100)  NOT NULL  
, [DaysAging] INTEGER  NOT NULL  
, [SpTransactionTypeId] INTEGER  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderTransactionRequest] ADD CONSTRAINT [ServiceProviderTransactionRequest_PK] PRIMARY KEY CLUSTERED (
[SpTransactionRequestId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProviderServiceDeterminant] (
[SpServiceDeterminantId] INTEGER Identity(1,1)  NOT NULL  
, [SpServiceId] INTEGER  NOT NULL  
, [ServiceDeterminantId] INTEGER  NOT NULL  
, [ServiceDeterminantValueId] INTEGER  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderServiceDeterminant] ADD CONSTRAINT [ServiceProviderServiceDeterminant_PK] PRIMARY KEY CLUSTERED (
[SpServiceDeterminantId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProvider] (
[ServiceProviderId] INTEGER Identity(1,1)  NOT NULL  
, [ReferenceNumber] VARCHAR(50)  NULL  
, [ReferenceNumberType] CHAR(10)  NULL  
, [Name] VARCHAR(50)  NOT NULL  
, [Description] VARCHAR(200)  NOT NULL  
, [StreetAddress] CHAR(250)  NULL  
, [City] CHAR(100)  NULL  
, [State] CHAR(10)  NULL  
, [Country] CHAR(50)  NULL  
, [PhoneNumber] CHAR(20)  NULL  
, [Website] CHAR(100)  NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProvider] ADD CONSTRAINT [ServiceProvider_PK] PRIMARY KEY CLUSTERED (
[ServiceProviderId]
)
GO
GO

CREATE TABLE [dbo].[ServiceDeterminant] (
[ServiceDeterminantId] INTEGER Identity(1,1)  NOT NULL  
, [Name] CHAR(50)  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceDeterminant] ADD CONSTRAINT [ServiceDeterminant_PK] PRIMARY KEY CLUSTERED (
[ServiceDeterminantId]
)
GO
GO

CREATE TABLE [dbo].[ServiceDeterminantValue] (
[ServiceDeterminantValueId] INTEGER Identity(1,1)  NOT NULL  
, [ServiceDeterminantId] INTEGER  NOT NULL  
, [DeterminantIdentifier] INTEGER  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceDeterminantValue] ADD CONSTRAINT [ServiceDeterminantValue_PK] PRIMARY KEY CLUSTERED (
[ServiceDeterminantValueId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProviderServiceStatus] (
[SpServiceStatusId] INTEGER Identity(1,1)  NOT NULL  
, [Name] CHAR(10)  NOT NULL  
, [Description] CHAR(10)  NOT NULL  
, [DateCreated] CHAR(10)  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderServiceStatus] ADD CONSTRAINT [ServiceProviderServiceStatus_PK] PRIMARY KEY CLUSTERED (
[SpServiceStatusId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProviderContact] (
[SpProviderContactId] INTEGER Identity(1,1)  NOT NULL  
, [FirstName] CHAR(100)  NOT NULL  
, [LastName] CHAR(100)  NOT NULL  
, [Title] CHAR(100)  NOT NULL  
, [ContactTypeId] INTEGER  NOT NULL  
, [Email] CHAR(100)  NOT NULL  
, [OfficePhone] CHAR(20)  NOT NULL  
, [MobilePhone] CHAR(20)  NULL  
, [ServiceProviderID] INTEGER  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderContact] ADD CONSTRAINT [ServiceProviderContact_PK] PRIMARY KEY CLUSTERED (
[SpProviderContactId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProviderServiceStatusHistory] (
[SpServiceStatusHistoryId] INTEGER Identity(1,1)  NOT NULL  
, [SpServiceId] INTEGER  NOT NULL  
, [SpServiceStatusId] INTEGER  NOT NULL  
, [EffectiveDate] DATETIME  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderServiceStatusHistory] ADD CONSTRAINT [ServiceProviderServiceStatusHistory_PK] PRIMARY KEY CLUSTERED (
[SpServiceStatusHistoryId]
)
GO
GO

CREATE TABLE [dbo].[ServiceType] (
[ServiceTypeId] INTEGER Identity(1,1)  NOT NULL  
, [Name] CHAR(10)  NOT NULL  
, [Description] CHAR(10)  NOT NULL  
, [DateCreated] CHAR(10)  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceType] ADD CONSTRAINT [ServiceType_PK] PRIMARY KEY CLUSTERED (
[ServiceTypeId]
)
GO
GO

CREATE TABLE [dbo].[ServiceProviderIntegrationMethod] (
[SpIntegrationMethodId] INTEGER Identity(1,1)  NOT NULL  
, [Name] CHAR(10)  NOT NULL  
, [Description] CHAR(10)  NOT NULL  
, [DateCreated] DATETIME  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL
, [DateModified] DATETIME  NULL 
, [ModifiedBy] VARCHAR(50)  NULL
)
GO

ALTER TABLE [dbo].[ServiceProviderIntegrationMethod] ADD CONSTRAINT [ServiceProviderIntegrationMethod_PK] PRIMARY KEY CLUSTERED (
[SpIntegrationMethodId]
)
GO
GO

ALTER TABLE [dbo].[ServiceProviderServiceRequest] WITH CHECK ADD CONSTRAINT [FkServiceProviderServiceRequest_SpTransactionRequestId] FOREIGN KEY (
[SpTransactionRequestId]
)
REFERENCES [dbo].[ServiceProviderTransactionRequest] (
[SpTransactionRequestId]
)
ALTER TABLE [dbo].[ServiceProviderServiceRequest] WITH CHECK ADD CONSTRAINT [FkServiceProviderServiceRequest_SpIntegrationMethodId] FOREIGN KEY (
[SpIntegrationMethodId]
)
REFERENCES [dbo].[ServiceProviderIntegrationMethod] (
[SpIntegrationMethodId]
)
ALTER TABLE [dbo].[ServiceProviderServiceRequest] WITH CHECK ADD CONSTRAINT [FkServiceProviderServiceRequest_SpServiceId] FOREIGN KEY (
[SpServiceId]
)
REFERENCES [dbo].[ServiceProviderService] (
[SpServiceId]
)
GO

GO

ALTER TABLE [dbo].[ServiceProviderService] WITH CHECK ADD CONSTRAINT [FkServiceProviderService_ServiceProviderId] FOREIGN KEY (
[ServiceProviderId]
)
REFERENCES [dbo].[ServiceProvider] (
[ServiceProviderId]
)
ALTER TABLE [dbo].[ServiceProviderService] WITH CHECK ADD CONSTRAINT [FkServiceProviderService_ServiceTypeId] FOREIGN KEY (
[ServiceTypeId]
)
REFERENCES [dbo].[ServiceType] (
[ServiceTypeId]
)
GO

ALTER TABLE [dbo].[ServiceProviderTransactionRequest] WITH CHECK ADD CONSTRAINT [FkSpTransactionRequest_SpTransactionTypeId] FOREIGN KEY (
[SpTransactionTypeId]
)
REFERENCES [dbo].[ServiceProviderTransactionType] (
[SpTransactionTypeId]
)
GO

ALTER TABLE [dbo].[ServiceProviderServiceDeterminant] WITH CHECK ADD CONSTRAINT [FkServiceProviderServiceDeterminant_SprServiceId] FOREIGN KEY (
[SpServiceId]
)
REFERENCES [dbo].[ServiceProviderService] (
[SpServiceId]
)
ALTER TABLE [dbo].[ServiceProviderServiceDeterminant] WITH CHECK ADD CONSTRAINT [FkServiceProviderServiceDeterminant_ServiceDeterminantValueId] FOREIGN KEY (
[ServiceDeterminantValueId]
)
REFERENCES [dbo].[ServiceDeterminantValue] (
[ServiceDeterminantValueId]
)
ALTER TABLE [dbo].[ServiceProviderServiceDeterminant] WITH CHECK ADD CONSTRAINT [FkServiceProviderServiceDeterminant_ServiceDeterminantId] FOREIGN KEY (
[ServiceDeterminantId]
)
REFERENCES [dbo].[ServiceDeterminant] (
[ServiceDeterminantId]
)
GO

GO

GO

ALTER TABLE [dbo].[ServiceDeterminantValue] WITH CHECK ADD CONSTRAINT [FkServiceDeterminantValue_ServiceDeterminantId] FOREIGN KEY (
[ServiceDeterminantId]
)
REFERENCES [dbo].[ServiceDeterminant] (
[ServiceDeterminantId]
)
GO

GO

ALTER TABLE [dbo].[ServiceProviderContact] WITH CHECK ADD CONSTRAINT [FkServiceProviderContact_ServiceProviderId] FOREIGN KEY (
[ServiceProviderID]
)
REFERENCES [dbo].[ServiceProvider] (
[ServiceProviderId]
)
GO

ALTER TABLE [dbo].[ServiceProviderServiceStatusHistory] WITH CHECK ADD CONSTRAINT [FkServiceProviderServiceStatusHistory_SpServiceStatusId] FOREIGN KEY (
[SpServiceStatusId]
)
REFERENCES [dbo].[ServiceProviderServiceStatus] (
[SpServiceStatusId]
)
GO

GO

GO

