CREATE TABLE [dbo].[CheckListContract] (
    [CheckListContractID] INT         IDENTITY (1, 1) NOT NULL,
    [ContractNumber]      CHAR (12)   NOT NULL,
    [Step]                INT         NOT NULL,
    [Disposition]         NCHAR (10)  NOT NULL,
    [CheckListID]         INT         NOT NULL,
    [Username]            NCHAR (100) NOT NULL,
    [DateCreated]         DATETIME    NOT NULL,
    [State]               INT         NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [CheckListContract__ContractNumber_I]
    ON [dbo].[CheckListContract]([ContractNumber] ASC)
    INCLUDE([CheckListID], [DateCreated], [State]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CheckListContract';

