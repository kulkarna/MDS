CREATE TABLE [Staging].[Nantucket] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [Caldendar Year] FLOAT (53)     NULL,
    [Calendar Month] FLOAT (53)     NULL,
    [Utility]        NVARCHAR (255) NULL,
    [Read Cycle]     FLOAT (53)     NULL,
    [Read Date]      DATETIME       NULL,
    [DateCreated]    DATETIME       DEFAULT (getdate()) NOT NULL
);

