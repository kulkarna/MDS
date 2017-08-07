CREATE TABLE [dbo].[zErrors] (
    [RequestID]      VARCHAR (50)  NULL,
    [OfferID]        VARCHAR (50)  NULL,
    [AccountNumber]  VARCHAR (50)  NULL,
    [Utility]        VARCHAR (50)  NULL,
    [ErrorMessage]   VARCHAR (MAX) NULL,
    [UserName]       VARCHAR (100) NULL,
    [Filename]       VARCHAR (100) NULL,
    [DateInsert]     DATETIME      CONSTRAINT [DF_zErrors_DateInsert] DEFAULT (getdate()) NOT NULL,
    [ChangeBy]       VARCHAR (30)  CONSTRAINT [DF_zErrors_AUDIT_CHANGE_BY] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [ChangeLocation] VARCHAR (30)  CONSTRAINT [DF_zErrors_AUDIT_CHANGE_LOCATION] DEFAULT (substring(host_name(),(1),(30))) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Account Number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'zErrors', @level2type = N'COLUMN', @level2name = N'AccountNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of Utility', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'zErrors', @level2type = N'COLUMN', @level2name = N'Utility';

