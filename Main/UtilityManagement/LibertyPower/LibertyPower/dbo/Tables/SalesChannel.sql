CREATE TABLE [dbo].[SalesChannel] (
    [ChannelID]                   INT           IDENTITY (1, 1) NOT NULL,
    [ChannelName]                 VARCHAR (100) NOT NULL,
    [DateCreated]                 DATETIME      CONSTRAINT [DF__SalesChan__DateC__7E57BA87] DEFAULT (getdate()) NOT NULL,
    [DateModified]                DATETIME      CONSTRAINT [DF__SalesChan__DateM__7F4BDEC0] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                   INT           CONSTRAINT [DF__SalesChan__Creat__004002F9] DEFAULT ((1)) NOT NULL,
    [ModifiedBy]                  INT           CONSTRAINT [DF__SalesChan__Modif__01342732] DEFAULT ((1)) NOT NULL,
    [EntityID]                    INT           CONSTRAINT [DF__SalesChan__Entit__02284B6B] DEFAULT ((0)) NULL,
    [ChannelDevelopmentManagerID] INT           NULL,
    [ChannelDescription]          VARCHAR (100) NULL,
    [ActiveDirectoryLoginID]      VARCHAR (100) NULL,
    [HasManagedUsers]             BIT           NOT NULL,
    [Inactive]                    BIT           NULL,
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
    [DoNotTransfer]               BIT           CONSTRAINT [DF_SalesChannel_DoNotTransfer] DEFAULT ((0)) NOT NULL,
    [DoNotTransferTime]           DATETIME      NULL,
    [DoNotTransferComment]        VARCHAR (500) NULL,
    CONSTRAINT [PK_SalesChannel] PRIMARY KEY CLUSTERED ([ChannelID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_ChannelName]
    ON [dbo].[SalesChannel]([ChannelName] ASC)
    INCLUDE([ChannelID]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SalesChannel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Full name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SalesChannel', @level2type = N'COLUMN', @level2name = N'ChannelDescription';

