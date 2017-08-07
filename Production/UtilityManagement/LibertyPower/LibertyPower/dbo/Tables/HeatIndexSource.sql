CREATE TABLE [dbo].[HeatIndexSource] (
    [HeatIndexSourceID] INT           IDENTITY (1, 1) NOT NULL,
    [Code]              CHAR (10)     NOT NULL,
    [Name]              VARCHAR (200) NOT NULL,
    [DateCreated]       DATETIME      NOT NULL,
    CONSTRAINT [PK_HeatIndexSource] PRIMARY KEY CLUSTERED ([HeatIndexSourceID] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Code]
    ON [dbo].[HeatIndexSource]([Code] ASC) WITH (FILLFACTOR = 90);


GO
GRANT UPDATE
    ON OBJECT::[dbo].[HeatIndexSource] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[HeatIndexSource] TO PUBLIC
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[HeatIndexSource] TO PUBLIC
    AS [dbo];

