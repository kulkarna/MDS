CREATE TABLE [dbo].[FileImport_test] (
    [ID]          INT              NOT NULL,
    [Filename]    VARCHAR (100)    NOT NULL,
    [SourceID]    INT              NULL,
    [DateCreated] DATETIME         DEFAULT (getdate()) NOT NULL,
    [IsValid]     BIT              DEFAULT ((1)) NOT NULL,
    [ExecutionID] UNIQUEIDENTIFIER NULL,
    [PackageID]   UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_FileImport_test] PRIMARY KEY CLUSTERED ([ID] ASC)
);

