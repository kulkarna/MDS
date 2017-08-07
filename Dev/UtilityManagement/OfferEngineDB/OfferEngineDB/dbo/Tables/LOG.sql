CREATE TABLE [dbo].[LOG] (
    [ID]        INT            IDENTITY (1, 1) NOT NULL,
    [DATE]      DATETIME       NOT NULL,
    [THREAD]    VARCHAR (255)  NOT NULL,
    [LEV]       VARCHAR (50)   NOT NULL,
    [LOGGER]    VARCHAR (255)  NOT NULL,
    [MESSAGE]   VARCHAR (4000) NOT NULL,
    [EXCEPTION] VARCHAR (2000) NULL
);

