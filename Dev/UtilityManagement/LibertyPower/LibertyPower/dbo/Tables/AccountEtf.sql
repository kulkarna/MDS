CREATE TABLE [dbo].[AccountEtf] (
    [EtfID]                INT             IDENTITY (1, 1) NOT NULL,
    [AccountID]            INT             NOT NULL,
    [EtfProcessingStateID] INT             NOT NULL,
    [EtfEndStatusID]       INT             CONSTRAINT [DF_AccountEtf_EtfEndStatusID] DEFAULT ((0)) NOT NULL,
    [ErrorMessage]         VARCHAR (255)   NULL,
    [EtfAmount]            DECIMAL (10, 2) NULL,
    [DeenrollmentDate]     DATETIME        NULL,
    [IsPaid]               BIT             CONSTRAINT [DF_AccountEtf_IsLocked] DEFAULT ((0)) NOT NULL,
    [IsEstimated]          BIT             CONSTRAINT [DF_AccountEtf_IsEstimated] DEFAULT ((0)) NOT NULL,
    [CalculatedDate]       DATETIME        NOT NULL,
    [EtfFinalAmount]       DECIMAL (10, 2) NULL,
    [LastUpdatedBy]        NCHAR (100)     NULL,
    [EtfCalculatorType]    NCHAR (50)      NULL,
    CONSTRAINT [PK_AccountEtf] PRIMARY KEY CLUSTERED ([EtfID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AccountEtf_AccountEtfEndStatus] FOREIGN KEY ([EtfEndStatusID]) REFERENCES [dbo].[AccountEtfEndStatus] ([EtfEndStatusID]),
    CONSTRAINT [FK_AccountEtf_AccountEtfProcessingState] FOREIGN KEY ([EtfProcessingStateID]) REFERENCES [dbo].[AccountEtfProcessingState] ([EtfProcessingStateID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtf';

