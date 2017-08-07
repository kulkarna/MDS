﻿CREATE TABLE [dbo].[tbl_Complaints] (
    [ID]                              INT            NOT NULL,
    [SF_CASE]                         NVARCHAR (255) NULL,
    [SF_OPEN]                         NVARCHAR (255) NULL,
    [FLAG]                            NVARCHAR (255) NULL,
    [STATE]                           NVARCHAR (255) NOT NULL,
    [COMPLAINT_NUMBER]                NVARCHAR (255) NULL,
    [DATE_OPEN]                       DATETIME       NULL,
    [UTILITY]                         NVARCHAR (255) NULL,
    [CUST_TYPE]                       NVARCHAR (255) NOT NULL,
    [CUST_NAME]                       NVARCHAR (255) NULL,
    [CUST_ACCT_NUMBER]                NVARCHAR (255) NULL,
    [PRIMARY_COMPLAINT_DESCRIPTION]   NVARCHAR (MAX) NOT NULL,
    [SECONDARY_COMPLAINT_DESCRIPTION] NVARCHAR (MAX) NULL,
    [DISPUTED_DOLLAR_AMT]             MONEY          NULL,
    [CUST_ACK_DATE]                   DATETIME       NULL,
    [RESOLVE_DATE]                    DATETIME       NULL,
    [CASE_PRIME]                      NVARCHAR (255) NOT NULL,
    [INTERNAL_FINDINGS]               NVARCHAR (MAX) NULL,
    [SALES_CHANNEL]                   NVARCHAR (255) NULL,
    [DISPUTE_OUTCOME]                 NVARCHAR (255) NOT NULL,
    [RecordCreationDate]              DATETIME       NULL,
    [RecordCreatedBy]                 NVARCHAR (50)  NULL,
    [RecordModificationDate]          DATETIME       NULL,
    [RecordModifiedBy]                NVARCHAR (50)  NULL,
    [ENTITY_TYPE]                     NVARCHAR (50)  NULL,
    [DATE_CLOSED]                     DATETIME       NULL,
    [COMPLAINT_TYPE]                  NVARCHAR (50)  NOT NULL,
    [CONTRACT_TYPE]                   NVARCHAR (50)  NULL,
    [PRODUCT_TYPE]                    NVARCHAR (50)  NULL,
    [CONTRACT_VERSION_ID]             NVARCHAR (50)  NULL,
    [FilePathName]                    NVARCHAR (255) NULL,
    [Status]                          NVARCHAR (50)  NULL,
    [LastContactDate]                 DATETIME       NULL,
    [Comments]                        NVARCHAR (MAX) NULL,
    [TeamContacted]                   NVARCHAR (50)  NULL,
    [ResolutionDescription]           NVARCHAR (MAX) NULL,
    [CustStatus]                      NVARCHAR (50)  NULL,
    [ContractSubmitDate]              DATETIME       NULL,
    [InboundCallCount]                INT            NULL,
    [SalesAgent]                      NVARCHAR (50)  NULL,
    [Justification]                   NVARCHAR (50)  NULL,
    [DDOLC]                           INT            NULL,
    [DDOC]                            INT            NULL,
    [DDSO]                            INT            NULL,
    [ContractTerms]                   NVARCHAR (50)  NULL,
    [ContractRate]                    FLOAT (53)     NULL,
    [DueDate]                         DATETIME       NULL,
    [Entity]                          INT            NULL,
    [annual_usage]                    NVARCHAR (255) NULL,
    [ChannelType]                     NVARCHAR (50)  NULL,
    [ComplaintCategory]               NVARCHAR (50)  NULL,
    [ContractNumber]                  NVARCHAR (50)  NULL,
    [NumberOfAccounts]                INT            NULL,
    [BusinessType]                    NVARCHAR (50)  NULL,
    [IssueType]                       NVARCHAR (50)  NOT NULL,
    [WaiverAmt]                       MONEY          NULL,
    [CreditAmt]                       MONEY          NULL,
    [FlowStartDate]                   DATETIME       NULL,
    [DeEnrolledDate]                  DATETIME       NULL
);
