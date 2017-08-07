CREATE TABLE [dbo].[EnrollmentAcceptedLog] (
    [ID]                   INT      IDENTITY (1, 1) NOT NULL,
    [AccountID]            INT      NOT NULL,
    [RateUpdateSentToISTA] BIT      NOT NULL,
    [DateCreated]          DATETIME NOT NULL
);

