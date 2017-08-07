CREATE TABLE [dbo].[UtilityRateLeadTime] (
    [UtilityRateLeadTimeID] INT      IDENTITY (1, 1) NOT NULL,
    [UtilityID]             INT      NOT NULL,
    [LeadTime]              INT      NULL,
    [DateCreated]           DATETIME CONSTRAINT [DF_MarketRateLeadTime_DateCreated] DEFAULT (getdate()) NOT NULL
);

