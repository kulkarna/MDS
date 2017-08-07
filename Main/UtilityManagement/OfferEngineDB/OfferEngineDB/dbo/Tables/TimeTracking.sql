CREATE TABLE [dbo].[TimeTracking] (
    [PricingRequestId] VARCHAR (50) NOT NULL,
    [PricingEvent]     TINYINT      NOT NULL,
    [TimeStamp]        DATETIME     CONSTRAINT [DF_TimeTracking_TimeStamp] DEFAULT (getdate()) NOT NULL
);

