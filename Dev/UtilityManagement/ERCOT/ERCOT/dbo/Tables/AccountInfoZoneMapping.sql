CREATE TABLE [dbo].[AccountInfoZoneMapping] (
    [ErcotZone] VARCHAR (200) NOT NULL,
    [OEZone]    VARCHAR (2)   NULL,
    [DCZone]    VARCHAR (200) NULL,
    CONSTRAINT [PK_ErcotZoneMapping] PRIMARY KEY CLUSTERED ([ErcotZone] ASC)
);

