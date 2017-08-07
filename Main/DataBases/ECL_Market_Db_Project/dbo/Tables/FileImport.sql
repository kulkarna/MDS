CREATE TABLE [dbo].[FileImport] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Filename]    VARCHAR (100)    NOT NULL,
    [SourceID]    INT              NULL,
    [DateCreated] DATETIME         DEFAULT (getdate()) NOT NULL,
    [IsValid]     BIT              DEFAULT ((1)) NOT NULL,
    [ExecutionID] UNIQUEIDENTIFIER NULL,
    [PackageID]   UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_FileImport] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (DATA_COMPRESSION = PAGE),
    CONSTRAINT [SI_id_fk] FOREIGN KEY ([SourceID]) REFERENCES [dbo].[Source] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [SourceFileNameNonClu]
    ON [dbo].[FileImport]([Filename] ASC, [SourceID] ASC) WITH (DATA_COMPRESSION = PAGE);

