CREATE TABLE [dbo].[GeoAddress] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [TypeID] SMALLINT      NOT NULL,
    [Street] VARCHAR (100) NULL,
    [City]   VARCHAR (50)  NULL,
    [State]  CHAR (2)      NULL,
    [Suite]  VARCHAR (10)  NULL,
    [Zip]    VARCHAR (10)  NULL,
    CONSTRAINT [PK_GeoAddress] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GeoAddress_GeoAddress] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[GeoAddressType] ([ID])
);

