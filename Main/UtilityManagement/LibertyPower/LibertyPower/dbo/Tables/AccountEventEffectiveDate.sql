CREATE TABLE [dbo].[AccountEventEffectiveDate] (
    [EventID]                    INT          IDENTITY (1, 1) NOT NULL,
    [EventName]                  VARCHAR (50) NOT NULL,
    [EventEffectiveDateValue]    VARCHAR (50) NOT NULL,
    [GrossMarginRecalculateFlag] BIT          CONSTRAINT [DF_AccountEventEffectiveDate_GrossMarginRecalculateFlag] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AccountEventEffectiveDate] PRIMARY KEY CLUSTERED ([EventID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Account', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEventEffectiveDate';

