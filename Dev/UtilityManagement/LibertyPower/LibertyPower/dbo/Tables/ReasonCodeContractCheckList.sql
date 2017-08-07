CREATE TABLE [dbo].[ReasonCodeContractCheckList] (
    [ContractNumber] VARCHAR (12) NOT NULL,
    [AccountNumber]  VARCHAR (30) NULL,
    [Step]           INT          NOT NULL,
    [CheckListID]    INT          NOT NULL,
    [ReasonCodeID]   INT          NOT NULL,
    [DateCreated]    DATETIME     NULL
);

