CREATE TABLE [dbo].[tbl_ComplaintsOtherFiles] (
    [FileID]         INT            NOT NULL,
    [ComplaintID]    INT            NULL,
    [FilePathName]   NVARCHAR (255) NOT NULL,
    [DocType]        NVARCHAR (255) NULL,
    [IncludeInEmail] BIT            NOT NULL,
    [EditDate]       DATETIME       NULL,
    [EditBy]         NVARCHAR (50)  NULL
);

