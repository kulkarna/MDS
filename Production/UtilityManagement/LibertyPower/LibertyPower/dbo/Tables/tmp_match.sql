CREATE TABLE [dbo].[tmp_match] (
    [Utility]     VARCHAR (50)  NOT NULL,
    [Account]     VARCHAR (50)  NOT NULL,
    [USDesc]      VARCHAR (50)  NOT NULL,
    [UsageSource] SMALLINT      NOT NULL,
    [UTDesc]      VARCHAR (50)  NOT NULL,
    [UsageType]   SMALLINT      NOT NULL,
    [FromD]       DATETIME      NOT NULL,
    [ToD]         DATETIME      NOT NULL,
    [Kwh]         INT           NOT NULL,
    [Kwh2]        INT           NOT NULL,
    [Active]      SMALLINT      NOT NULL,
    [Meter]       VARCHAR (50)  NOT NULL,
    [ReasonCode]  VARCHAR (100) NOT NULL
);

