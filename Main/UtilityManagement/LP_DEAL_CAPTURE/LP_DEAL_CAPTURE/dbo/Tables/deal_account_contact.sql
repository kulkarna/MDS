CREATE TABLE [dbo].[deal_account_contact] (
    [account_id]   CHAR (12)      NOT NULL,
    [contact_link] INT            NOT NULL,
    [first_name]   VARCHAR (50)   NOT NULL,
    [last_name]    VARCHAR (50)   NOT NULL,
    [title]        VARCHAR (20)   NOT NULL,
    [phone]        VARCHAR (20)   NOT NULL,
    [fax]          VARCHAR (20)   NOT NULL,
    [email]        NVARCHAR (256) NOT NULL,
    [birthday]     CHAR (5)       NULL,
    [chgstamp]     SMALLINT       NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [account_contact_idx]
    ON [dbo].[deal_account_contact]([account_id] ASC, [contact_link] ASC);


GO
CREATE NONCLUSTERED INDEX [account_contact_idx1]
    ON [dbo].[deal_account_contact]([account_id] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

