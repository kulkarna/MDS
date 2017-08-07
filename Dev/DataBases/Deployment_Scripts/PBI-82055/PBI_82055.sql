USE [Workspace] 
GO

CREATE TABLE AuditRunEdiAccount
(
       Id INT IDENTITY(1,1) NOT NULL,
       AuditRunDate DATETIME NOT NULL DEFAULT GETDATE(),
       FromDate	Datetime NOT NULL,
       ToDate Datetime NOT NULL,
       CONSTRAINT [PK_AuditRunEdiAccount] PRIMARY KEY CLUSTERED 
       (
              [Id] ASC
       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

--Drop Table AuditEdiAccountHistory

CREATE TABLE AuditEdiAccountHistory 
(
       Id INT IDENTITY(1,1) NOT NULL,
       AuditRunEdiAccountId INT NOT NULL,
       IstaAccountNumber VARCHAR(200) NOT NULL,
       IstaTableName VARCHAR(200) NULL,
       IstaFieldName VARCHAR(200) NULL,
       IstaValue VARCHAR(200) NULL,
       IstaRecordFieldName VARCHAR(200) NULL,
       IstaRecordFieldValue VARCHAR(200) NULL,
       IstaRecordCreation Datetime not Null,
       LpESAccountNumber VARCHAR(200) NULL,
       LpEaSourceTableName VARCHAR(200) NULL,
       LpEaSourceFieldName VARCHAR(200) NULL,
       LpEaSourceValue VARCHAR(200) NULL,
       LpEaSourceRecordId VARCHAR(200) NULL,
       Comment VARCHAR(500) NULL,
       CreatedDate DATETIME NULL DEFAULT GETDATE(),
       CreatedBy VARCHAR(100) NULL,
       LastModifiedDate DATETIME NULL DEFAULT GETDATE(),
       LastModifiedBy VARCHAR(100),
       CONSTRAINT [PK_AuditEdiAccountHistory] PRIMARY KEY CLUSTERED 
       (
              [Id] ASC
       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AuditEdiAccountHistory]  WITH CHECK ADD  CONSTRAINT [FK_AuditEdiAccountHistory_AuditRunEdiAccount] FOREIGN KEY([AuditRunEdiAccountId])
REFERENCES [dbo].[AuditRunEdiAccount] ([Id])
GO

ALTER TABLE [dbo].[AuditEdiAccountHistory] CHECK CONSTRAINT [FK_AuditEdiAccountHistory_AuditRunEdiAccount]
GO
