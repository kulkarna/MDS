CREATE TABLE [dbo].[FileImport_11] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Filename]    VARCHAR (100)    NOT NULL,
    [ExecutionID] UNIQUEIDENTIFIER NULL,
    [PackageID]   UNIQUEIDENTIFIER NULL,
    [SourceID]    INT              NULL,
    [IsValid]     BIT              DEFAULT ((1)) NOT NULL,
    [DateCreated] DATETIME         DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_FileImport_11] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (DATA_COMPRESSION = PAGE),
    CONSTRAINT [SI_id_fk_11] FOREIGN KEY ([SourceID]) REFERENCES [dbo].[Source] ([ID])
);

