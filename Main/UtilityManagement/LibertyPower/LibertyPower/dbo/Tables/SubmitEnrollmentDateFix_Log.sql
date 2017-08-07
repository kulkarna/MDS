CREATE TABLE [dbo].[SubmitEnrollmentDateFix_Log] (
    [SubmitEnrollmentDateFixLogID] INT      IDENTITY (1, 1) NOT NULL,
    [AccountContractID]            INT      NOT NULL,
    [SendEnrollmentDateOld]        DATETIME NULL,
    [SendEnrollmentDateNew]        DATETIME NULL,
    [RecordCreatedOn]              DATETIME CONSTRAINT [DF_SubmitEnrollmentDateFix_Log_RecordCreatedOn] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_SubmitEnrollmentDateFix_Test] PRIMARY KEY CLUSTERED ([SubmitEnrollmentDateFixLogID] ASC)
);

