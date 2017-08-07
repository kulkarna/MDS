CREATE TABLE [dbo].[Fileimport_Temp] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Filename]    VARCHAR (100) NOT NULL,
    [SourceID]    INT           NULL,
    [DateCreated] DATETIME      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-20141127-091637]
    ON [dbo].[Fileimport_Temp]([ID] ASC);

