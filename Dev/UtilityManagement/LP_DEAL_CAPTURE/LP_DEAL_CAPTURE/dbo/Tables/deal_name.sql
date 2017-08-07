CREATE TABLE [dbo].[deal_name] (
    [contract_nbr] CHAR (12)     NOT NULL,
    [name_link]    INT           NOT NULL,
    [full_name]    VARCHAR (100) NOT NULL,
    [chgstamp]     SMALLINT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [deal_name_idx]
    ON [dbo].[deal_name]([contract_nbr] ASC, [name_link] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

