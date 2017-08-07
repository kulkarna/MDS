CREATE TABLE [dbo].[SalesChannelHistory] (
    [ChannelHistoryID]            INT           IDENTITY (1, 1) NOT NULL,
    [ChannelID]                   INT           NOT NULL,
    [ChannelName]                 VARCHAR (100) NOT NULL,
    [DateModified]                DATETIME      NOT NULL,
    [ModifiedBy]                  INT           NOT NULL,
    [EntityID]                    INT           NULL,
    [ChannelDevelopmentManagerID] INT           NULL,
    [ChannelDescription]          VARCHAR (100) NULL,
    [inactive]                    BIT           NULL,
    [ContactFirstName]            VARCHAR (100) NULL,
    [ContactLastName]             VARCHAR (100) NULL,
    [ContactAddress1]             VARCHAR (100) NULL,
    [ContactAddress2]             VARCHAR (100) NULL,
    [ContactCity]                 VARCHAR (100) NULL,
    [ContactState]                VARCHAR (5)   NULL,
    [ContactZip]                  VARCHAR (20)  NULL,
    [ContactEmail]                VARCHAR (100) NULL,
    [ContactPhone]                VARCHAR (50)  NULL,
    [ContactFax]                  VARCHAR (50)  NULL,
    [RenewalGracePeriod]          INT           DEFAULT ((0)) NOT NULL,
    [AllowRetentionSave]          BIT           DEFAULT ((0)) NOT NULL,
    [AllowRenewalOnDefault]       BIT           DEFAULT ((0)) NOT NULL,
    [AlwaysTransfer]              BIT           DEFAULT ((0)) NOT NULL,
    [LegalStatus]                 INT           DEFAULT ((0)) NOT NULL,
    [SalesStatus]                 INT           DEFAULT ((0)) NOT NULL,
    [AllowInfoOnWelcomeLetter]    BIT           DEFAULT ((0)) NOT NULL,
    [AllowInfoOnRenewalLetter]    BIT           DEFAULT ((0)) NOT NULL,
    [AllowInfoOnRenewalNotice]    BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SalesChannelHistory] PRIMARY KEY CLUSTERED ([ChannelHistoryID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SalesChannelHistory';

