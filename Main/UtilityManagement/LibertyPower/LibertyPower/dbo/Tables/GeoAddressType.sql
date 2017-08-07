CREATE TABLE [dbo].[GeoAddressType] (
    [ID]          SMALLINT     NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_AddressType] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

