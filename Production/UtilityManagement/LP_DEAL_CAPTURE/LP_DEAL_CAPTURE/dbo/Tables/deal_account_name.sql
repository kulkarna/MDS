CREATE TABLE [dbo].[deal_account_name] (
    [account_id] CHAR (12)     NOT NULL,
    [name_link]  INT           NOT NULL,
    [full_name]  VARCHAR (100) NOT NULL,
    [chgstamp]   SMALLINT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [account_name_idx]
    ON [dbo].[deal_account_name]([account_id] ASC, [name_link] ASC);


GO
CREATE NONCLUSTERED INDEX [account_name_idx1]
    ON [dbo].[deal_account_name]([full_name] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

