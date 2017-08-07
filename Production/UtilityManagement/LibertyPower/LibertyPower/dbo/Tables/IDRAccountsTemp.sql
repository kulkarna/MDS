CREATE TABLE [dbo].[IDRAccountsTemp] (
    [UtilityID]      VARCHAR (15) NOT NULL,
    [AccountNumber]  VARCHAR (10) NOT NULL,
    [IDRStartDate]   DATETIME     NOT NULL,
    [SiteUploadDate] DATETIME     NULL,
    [CreateDate]     DATETIME     NOT NULL,
    [ModifiedBy]     VARCHAR (10) NOT NULL,
    CONSTRAINT [PK_IDRAccountsTemp] PRIMARY KEY CLUSTERED ([UtilityID] ASC, [AccountNumber] ASC)
);

