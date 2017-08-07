CREATE TABLE [dbo].[referral] (
    [account_id_link]   CHAR (12)     NOT NULL,
    [first_name]        VARCHAR (50)  NOT NULL,
    [last_name]         NCHAR (50)    NOT NULL,
    [company_name]      VARCHAR (50)  NOT NULL,
    [phone_number]      VARCHAR (15)  NOT NULL,
    [email_address]     VARCHAR (255) NOT NULL,
    [confirmation_code] INT           NOT NULL,
    [status]            VARCHAR (25)  NULL,
    [date_created]      DATETIME      NOT NULL,
    [date_updated]      DATETIME      NOT NULL,
    [created_by]        VARCHAR (150) NULL,
    [username]          VARCHAR (100) NULL
);

