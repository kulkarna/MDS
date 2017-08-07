CREATE TABLE [dbo].[Complaint] (
    [ComplaintID]                    INT           IDENTITY (1, 1) NOT NULL,
    [AccountID]                      INT           NULL,
    [ComplaintAccountID]             INT           NULL,
    [ComplaintRegulatoryAuthorityID] INT           NULL,
    [ComplaintStatusID]              INT           NOT NULL,
    [ComplaintIssueTypeID]           INT           NOT NULL,
    [ComplaintantName]               VARCHAR (150) NULL,
    [OpenDate]                       DATETIME      NULL,
    [DueDate]                        DATETIME      NULL,
    [AcknowledgeDate]                DATETIME      NULL,
    [ClosedDate]                     DATETIME      NULL,
    [LastContactDate]                DATETIME      NULL,
    [CasePrimeID]                    INT           NULL,
    [ControlNumber]                  VARCHAR (50)  NULL,
    [ComplaintTypeID]                INT           NULL,
    [IsFormal]                       BIT           NULL,
    [PrimaryDescription]             VARCHAR (MAX) NULL,
    [SecondaryDescription]           VARCHAR (MAX) NULL,
    [InboundCalls]                   INT           NULL,
    [TeamContactedID]                INT           NULL,
    [ContractReviewDate]             DATETIME      NULL,
    [SalesMgrNotified]               DATETIME      NULL,
    [ValidContract]                  BIT           NULL,
    [DisputeOutcomeID]               INT           NULL,
    [Waiver]                         MONEY         NULL,
    [Credit]                         MONEY         NULL,
    [ResolutionDescription]          VARCHAR (MAX) NULL,
    [InternalFindings]               VARCHAR (MAX) NULL,
    [Comments]                       VARCHAR (MAX) NULL,
    [CreationDate]                   DATETIME      CONSTRAINT [DF_Complaint_CreationDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                      VARCHAR (200) NOT NULL,
    [LastModifiedDate]               DATETIME      CONSTRAINT [DF_Complaint_LastModifiedDate] DEFAULT (getdate()) NULL,
    [LastModifiedBy]                 VARCHAR (200) NULL,
    [ContractID]                     INT           NULL,
    [ComplaintLegacyID]              INT           NULL,
    CONSTRAINT [PK_Complaint] PRIMARY KEY CLUSTERED ([ComplaintID] ASC),
    CONSTRAINT [CK_Either_AccountID] CHECK ([AccountID] IS NULL AND [ComplaintAccountID] IS NOT NULL OR [AccountID] IS NOT NULL AND [ComplaintAccountID] IS NULL),
    CONSTRAINT [FK_Complaint_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_Complaint_ComplaintAccount] FOREIGN KEY ([ComplaintAccountID]) REFERENCES [dbo].[ComplaintAccount] ([ComplaintAccountID]),
    CONSTRAINT [FK_Complaint_ComplaintContactedTeam] FOREIGN KEY ([TeamContactedID]) REFERENCES [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID]),
    CONSTRAINT [FK_Complaint_ComplaintIssueType] FOREIGN KEY ([ComplaintIssueTypeID]) REFERENCES [dbo].[ComplaintIssueType] ([ComplaintIssueTypeID]),
    CONSTRAINT [FK_Complaint_ComplaintStatus] FOREIGN KEY ([ComplaintStatusID]) REFERENCES [dbo].[ComplaintStatus] ([ComplaintStatusID]),
    CONSTRAINT [FK_Complaint_ComplaintType] FOREIGN KEY ([ComplaintTypeID]) REFERENCES [dbo].[ComplaintType] ([ComplaintTypeID]),
    CONSTRAINT [FK_Complaint_Contract] FOREIGN KEY ([ContractID]) REFERENCES [dbo].[Contract] ([ContractID])
);


GO
ALTER TABLE [dbo].[Complaint] NOCHECK CONSTRAINT [FK_Complaint_Account];


GO
ALTER TABLE [dbo].[Complaint] NOCHECK CONSTRAINT [FK_Complaint_ComplaintAccount];


GO
ALTER TABLE [dbo].[Complaint] NOCHECK CONSTRAINT [FK_Complaint_Contract];


GO
CREATE NONCLUSTERED INDEX [IX_Complaint]
    ON [dbo].[Complaint]([AccountID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Complaint_1]
    ON [dbo].[Complaint]([ComplaintAccountID] ASC);

