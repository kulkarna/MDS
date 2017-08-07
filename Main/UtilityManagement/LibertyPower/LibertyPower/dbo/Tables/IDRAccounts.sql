CREATE TABLE [dbo].[IDRAccounts] (
    [UtilityID]      VARCHAR (15) NOT NULL,
    [AccountNumber]  VARCHAR (10) NOT NULL,
    [IDRStartDate]   DATETIME     NOT NULL,
    [SiteUploadDate] DATETIME     NULL,
    [CreateDate]     DATETIME     NOT NULL,
    [ModifiedBy]     VARCHAR (10) NOT NULL,
    CONSTRAINT [PK_IDRAccounts] PRIMARY KEY CLUSTERED ([UtilityID] ASC, [AccountNumber] ASC)
);

