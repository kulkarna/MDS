CREATE TABLE [dbo].[EflDataRange] (
    [TermMin]    INT             NOT NULL,
    [TermMax]    INT             NOT NULL,
    [RateMin]    DECIMAL (18, 5) NOT NULL,
    [RateMax]    DECIMAL (18, 5) NOT NULL,
    [LpFixedMin] DECIMAL (18, 2) NOT NULL,
    [LpFixedMax] DECIMAL (18, 2) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EFL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EflDataRange';

