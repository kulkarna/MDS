CREATE TABLE [dbo].[ST_GenieImportAttachments] (
    [ContractID]       INT           NOT NULL,
    [attachmentTypeID] INT           NOT NULL,
    [DocFileName]      VARCHAR (200) NULL,
    [UploadedPath]     VARCHAR (200) NULL,
    [ContractNBR]      VARCHAR (20)  NULL,
    [DocumentVersion]  VARCHAR (50)  NULL
);


GO
CREATE NONCLUSTERED INDEX [ST_GenieImportAttachments__ContractID_AttachmentTypeID]
    ON [dbo].[ST_GenieImportAttachments]([ContractID] ASC, [attachmentTypeID] ASC);

