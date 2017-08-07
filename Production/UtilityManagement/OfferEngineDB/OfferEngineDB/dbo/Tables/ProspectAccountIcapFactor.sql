CREATE TABLE [dbo].[ProspectAccountIcapFactor] (
    [ID]            INT          IDENTITY (100, 1) NOT NULL,
    [OfferId]       VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [FactorId]      INT          NOT NULL,
    [Created]       DATETIME     CONSTRAINT [DF_ProspectAccountIcapFactor_Created] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ProspectAccountIcapFactor] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_ProspectAccountIcapFactor]
    ON [dbo].[ProspectAccountIcapFactor]([AccountNumber] ASC, [FactorId] ASC, [OfferId] ASC) WITH (FILLFACTOR = 90);

