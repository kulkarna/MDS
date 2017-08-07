CREATE TABLE [dbo].[TPVFile] (
    [ImportId]     INT           IDENTITY (1, 1) NOT NULL,
    [TPVFileName]  VARCHAR (250) NULL,
    [DateImported] DATETIME      CONSTRAINT [DF_TPVFile_DateImported] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_TPVFile] PRIMARY KEY CLUSTERED ([ImportId] ASC)
);

