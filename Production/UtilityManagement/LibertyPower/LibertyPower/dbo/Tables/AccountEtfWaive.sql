CREATE TABLE [dbo].[AccountEtfWaive] (
    [AccountEtfWaiveID]             INT      IDENTITY (1, 1) NOT NULL,
    [AccountID]                     INT      NOT NULL,
    [CurrentEtfID]                  INT      NULL,
    [IsOutgoingDeenrollmentRequest] BIT      CONSTRAINT [DF_AccountEtfWaive_IsOutgoingDeenrollmentRequest] DEFAULT ((0)) NOT NULL,
    [WaiveEtf]                      BIT      CONSTRAINT [DF_AccountEtfWaive_WaiveEtf] DEFAULT ((0)) NOT NULL,
    [WaivedEtfReasonCodeID]         INT      NULL,
    [DateCreated]                   DATETIME CONSTRAINT [DF_AccountEtfWaive_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AccountEtfWaive] PRIMARY KEY CLUSTERED ([AccountEtfWaiveID] ASC),
    CONSTRAINT [FK_AccountEtfWaive_AccountEtfWaivedReasonCode] FOREIGN KEY ([WaivedEtfReasonCodeID]) REFERENCES [dbo].[AccountEtfWaivedReasonCode] ([EtfWaivedReasonCodeID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountID_ForAccountSelect]
    ON [dbo].[AccountEtfWaive]([AccountID] ASC)
    INCLUDE([CurrentEtfID], [IsOutgoingDeenrollmentRequest], [WaiveEtf], [WaivedEtfReasonCodeID]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfWaive';

