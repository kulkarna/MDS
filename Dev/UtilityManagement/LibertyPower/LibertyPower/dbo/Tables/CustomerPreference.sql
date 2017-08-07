CREATE TABLE [dbo].[CustomerPreference] (
    [CustomerPreferenceID] INT          IDENTITY (1, 1) NOT NULL,
    [IsGoGreen]            BIT          CONSTRAINT [DF_CustomerPreference_IsGoGreen] DEFAULT ((0)) NOT NULL,
    [OptOutSpecialOffers]  BIT          CONSTRAINT [DF_CustomerPreference_OptOutSpecialOffers] DEFAULT ((0)) NOT NULL,
    [LanguageID]           INT          CONSTRAINT [DF_CustomerPreference_LanguageID] DEFAULT ((0)) NOT NULL,
    [Pin]                  VARCHAR (16) NOT NULL,
    [Modified]             DATETIME     CONSTRAINT [DF_CustomerPreference_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]           INT          NOT NULL,
    [DateCreated]          DATETIME     CONSTRAINT [DF_CustomerPreference_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            INT          NOT NULL,
    CONSTRAINT [PK_CustomerPreference] PRIMARY KEY CLUSTERED ([CustomerPreferenceID] ASC),
    CONSTRAINT [FK_CustomerPreference_User] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_CustomerPreference_User1] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID])
);

