CREATE TABLE [dbo].[ComplaintDocumentTypeMapping] (
    [LegacyDocTypeName] VARCHAR (70) NOT NULL,
    [DocumentTypeID]    INT          NULL,
    CONSTRAINT [PK_ComplaintsLegacyDocumentTypeMapping] PRIMARY KEY CLUSTERED ([LegacyDocTypeName] ASC)
);

