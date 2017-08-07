CREATE TABLE [dbo].[ST_GenieImportAttachments_BAK] (
    [TEMPID]           INT           IDENTITY (1, 1) NOT NULL,
    [ContractID]       INT           NOT NULL,
    [attachmentTypeID] INT           NOT NULL,
    [DocFileName]      VARCHAR (200) NULL,
    [UploadedPath]     VARCHAR (200) NULL,
    [ContractNBR]      VARCHAR (20)  NULL,
    [DocumentVersion]  VARCHAR (50)  NULL
);

