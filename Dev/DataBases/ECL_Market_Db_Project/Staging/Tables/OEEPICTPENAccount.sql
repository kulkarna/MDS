CREATE TABLE [Staging].[OEEPICTPENAccount] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [RecNo]            FLOAT (53)     NULL,
    [ESIID]            NVARCHAR (255) NULL,
    [AccountNumber]    NVARCHAR (255) NULL,
    [PMIID]            NVARCHAR (255) NULL,
    [AccountName]      NVARCHAR (255) NULL,
    [ServiceAddress 1] NVARCHAR (255) NULL,
    [ServiceAddress 3] NVARCHAR (255) NULL,
    [ContextDate]      DATETIME       NOT NULL,
    [DateCreated]      DATETIME       DEFAULT (getdate()) NOT NULL,
    [FileImportID]     INT            NULL,
    CONSTRAINT [pk_OEEPICTPENAccount_id] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [OEEPICTPENAcct_id_fk] FOREIGN KEY ([FileImportID]) REFERENCES [dbo].[FileImport] ([ID])
);

