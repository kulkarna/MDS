CREATE TABLE [dbo].[EflProcess] (
    [ID]      INT          IDENTITY (1, 1) NOT NULL,
    [Process] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_EflProcess] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EFL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EflProcess';

