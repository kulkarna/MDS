CREATE TABLE [dbo].[AccountPropertyHistory] (
    [AccountPropertyHistoryID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [UtilityID]                VARCHAR (80)  NOT NULL,
    [AccountNumber]            VARCHAR (50)  NOT NULL,
    [FieldName]                VARCHAR (60)  NOT NULL,
    [FieldValue]               VARCHAR (200) NOT NULL,
    [EffectiveDate]            DATETIME      NOT NULL,
    [ExpirationDate]           DATETIME      NULL,
    [FieldSource]              VARCHAR (60)  NOT NULL,
    [CreatedBy]                VARCHAR (256) NOT NULL,
    [DateCreated]              DATETIME      NOT NULL,
    [LockStatus]               VARCHAR (60)  NOT NULL,
    [Active]                   BIT           NOT NULL,
    CONSTRAINT [PK_DeterminantHistory_2] PRIMARY KEY CLUSTERED ([AccountPropertyHistoryID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountPropertyHistoryTemp02]
    ON [dbo].[AccountPropertyHistory]([UtilityID] ASC, [AccountNumber] ASC, [Active] ASC, [FieldName] ASC, [EffectiveDate] ASC);


GO
CREATE NONCLUSTERED INDEX [idx__temp1]
    ON [dbo].[AccountPropertyHistory]([UtilityID] ASC, [FieldName] ASC)
    INCLUDE([AccountNumber], [Active], [FieldValue]);

