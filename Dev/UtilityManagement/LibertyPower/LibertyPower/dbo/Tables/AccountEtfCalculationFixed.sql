CREATE TABLE [dbo].[AccountEtfCalculationFixed] (
    [EtfCalculationFixedID] INT        IDENTITY (1, 1) NOT NULL,
    [EtfID]                 INT        NOT NULL,
    [LostTermDays]          INT        NOT NULL,
    [LostTermMonths]        INT        NOT NULL,
    [AccountRate]           FLOAT (53) NOT NULL,
    [MarketRate]            FLOAT (53) NOT NULL,
    [AnnualUsage]           INT        NOT NULL,
    [Term]                  INT        NOT NULL,
    [FlowStartDate]         DATETIME   NOT NULL,
    [DropMonthIndicator]    INT        NOT NULL,
    CONSTRAINT [PK_AccountEtfCalculationFixed] PRIMARY KEY CLUSTERED ([EtfCalculationFixedID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AccountEtfCalculationFixed_AccountEtf] FOREIGN KEY ([EtfID]) REFERENCES [dbo].[AccountEtf] ([EtfID])
);


GO
-- =============================================
-- Author:		Eric Hernandez
-- Create date: 2011-08-30
-- Description:	Archives the parameters so that we can always see what went into an estimate.
-- =============================================
CREATE TRIGGER tr_ArchiveParameters
   ON  AccountEtfCalculationFixed
   AFTER INSERT,UPDATE
AS 
BEGIN
	INSERT INTO [Libertypower].[dbo].[AccountEtfCalculationFixedHistory]
           ([EtfID]
           ,[LostTermDays]
           ,[LostTermMonths]
           ,[AccountRate]
           ,[MarketRate]
           ,[AnnualUsage]
           ,[Term]
           ,[FlowStartDate]
           ,[DropMonthIndicator])
    SELECT [EtfID]
           ,[LostTermDays]
           ,[LostTermMonths]
           ,[AccountRate]
           ,[MarketRate]
           ,[AnnualUsage]
           ,[Term]
           ,[FlowStartDate]
           ,[DropMonthIndicator]
    FROM Inserted
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfCalculationFixed';

