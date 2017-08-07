CREATE TABLE [dbo].[CheckList] (
    [CheckListID] INT         IDENTITY (1, 1) NOT NULL,
    [Step]        INT         NOT NULL,
    [AccountType] INT         NOT NULL,
    [Description] NCHAR (100) NOT NULL,
    [Status]      INT         NOT NULL,
    [DateCreated] DATETIME    NULL,
    [Order]       INT         DEFAULT ((10)) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [CheckList__Step_AccountType_I_Order]
    ON [dbo].[CheckList]([Step] ASC, [AccountType] ASC)
    INCLUDE([Order]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CheckList';

