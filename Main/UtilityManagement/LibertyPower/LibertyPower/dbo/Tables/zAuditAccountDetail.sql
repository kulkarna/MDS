CREATE TABLE [dbo].[zAuditAccountDetail] (
    [zAuditAccountDetail]    INT           IDENTITY (1, 1) NOT NULL,
    [AccountDetailID]        INT           NOT NULL,
    [AccountID]              INT           NOT NULL,
    [EnrollmentTypeID]       INT           NULL,
    [OriginalTaxDesignation] INT           NULL,
    [Modified]               DATETIME      NOT NULL,
    [ModifiedBy]             INT           NOT NULL,
    [DateCreated]            DATETIME      NOT NULL,
    [CreatedBy]              INT           NOT NULL,
    [AuditChangeType]        CHAR (3)      NOT NULL,
    [AuditChangeDate]        DATETIME      CONSTRAINT [DFzAuditAccountDetailAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]          VARCHAR (30)  CONSTRAINT [DFzAuditAccountDetailAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation]    VARCHAR (30)  CONSTRAINT [DFzAuditAccountDetailAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]         VARCHAR (MAX) NULL,
    [ColumnsChanged]         VARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditAccountDetailAuditChangeDate]
    ON [dbo].[zAuditAccountDetail]([AuditChangeDate] ASC);

