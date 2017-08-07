CREATE TABLE [dbo].[ComplaintDocument] (
    [ComplaintDocumentID] INT              IDENTITY (1, 1) NOT NULL,
    [ComplaintID]         INT              NOT NULL,
    [DocumentTypeID]      INT              NOT NULL,
    [FileGuid]            UNIQUEIDENTIFIER NOT NULL,
    [FileName]            VARCHAR (250)    NOT NULL,
    [CreatedOn]           DATETIME         CONSTRAINT [DF_ComplaintDocument_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [AllowPublicView]     BIT              CONSTRAINT [DF_ComplaintDocument_AllowPublicView] DEFAULT ((0)) NOT NULL,
    [UploadedOn]          DATETIME         NULL,
    CONSTRAINT [PK_ComplaintDocument] PRIMARY KEY CLUSTERED ([ComplaintDocumentID] ASC),
    CONSTRAINT [FK_ComplaintDocument_Complaint] FOREIGN KEY ([ComplaintID]) REFERENCES [dbo].[Complaint] ([ComplaintID]),
    CONSTRAINT [FK_ComplaintDocument_FileContext] FOREIGN KEY ([FileGuid]) REFERENCES [dbo].[FileContext] ([FileGuid])
);

