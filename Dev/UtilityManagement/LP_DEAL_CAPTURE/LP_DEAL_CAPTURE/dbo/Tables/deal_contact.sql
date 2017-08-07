CREATE TABLE [dbo].[deal_contact] (
    [contract_nbr] CHAR (12)      NOT NULL,
    [contact_link] INT            NOT NULL,
    [first_name]   VARCHAR (50)   NOT NULL,
    [last_name]    VARCHAR (50)   NOT NULL,
    [title]        VARCHAR (20)   NOT NULL,
    [phone]        VARCHAR (20)   NOT NULL,
    [fax]          VARCHAR (20)   NOT NULL,
    [email]        NVARCHAR (256) NOT NULL,
    [birthday]     VARCHAR (5)    NOT NULL,
    [chgstamp]     SMALLINT       NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [deal_contact_idx]
    ON [dbo].[deal_contact]([contract_nbr] ASC, [contact_link] ASC);

