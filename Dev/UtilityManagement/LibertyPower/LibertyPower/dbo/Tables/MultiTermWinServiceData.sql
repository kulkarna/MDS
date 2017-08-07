CREATE TABLE [dbo].[MultiTermWinServiceData] (
    [ID]                              INT            IDENTITY (1, 1) NOT NULL,
    [LeadTime]                        INT            NOT NULL,
    [StartToSubmitDate]               DATETIME       NOT NULL,
    [ToBeExpiredAccountContactRateId] INT            NOT NULL,
    [MeterReadDate]                   DATETIME       NOT NULL,
    [NewAccountContractRateId]        INT            NULL,
    [RateEndDateAjustedByService]     BIT            CONSTRAINT [DF_MultiTermWinServiceData_RateEndDateAjustedByService] DEFAULT ((0)) NOT NULL,
    [MultiTermWinServiceStatusId]     INT            CONSTRAINT [DF_MultyTermWinServiceProcessList_ProcessStatus] DEFAULT ((1)) NOT NULL,
    [ServiceLastRunDate]              DATETIME       NULL,
    [IstaErrorMssg]                   NVARCHAR (200) NULL,
    [DateCreated]                     DATETIME       CONSTRAINT [DF_MultyTermWinServiceProcessList_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                       INT            NOT NULL,
    [DateModified]                    DATETIME       NULL,
    [ModifiedBy]                      INT            NULL,
    [ReenrollmentFollowingMeterDate]  DATETIME       NULL,
    CONSTRAINT [PK_MultyTermWinServiceProcessList] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_MultiTermWinServiceData_AccountContractRate] FOREIGN KEY ([ToBeExpiredAccountContactRateId]) REFERENCES [dbo].[AccountContractRate] ([AccountContractRateID]),
    CONSTRAINT [FK_MultiTermWinServiceData_AccountContractRate1] FOREIGN KEY ([NewAccountContractRateId]) REFERENCES [dbo].[AccountContractRate] ([AccountContractRateID]),
    CONSTRAINT [FK_MultiTermWinServiceData_MultiTermWinServiceStatus] FOREIGN KEY ([MultiTermWinServiceStatusId]) REFERENCES [dbo].[MultiTermWinServiceStatus] ([Id]),
    CONSTRAINT [FK_MultiTermWinServiceData_User] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_MultiTermWinServiceData_User1] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);

