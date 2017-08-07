CREATE TABLE [dbo].[deal_contract_error] (
    [process_id]     VARCHAR (15)  NOT NULL,
    [contract_nbr]   VARCHAR (25)  NOT NULL,
    [account_number] VARCHAR (30)  NOT NULL,
    [application]    VARCHAR (30)  NOT NULL,
    [error]          CHAR (1)      NOT NULL,
    [msg_id]         VARCHAR (50)  NOT NULL,
    [descp_add]      VARCHAR (100) NOT NULL
);


GO
CREATE CLUSTERED INDEX [deal_contract_error_idx]
    ON [dbo].[deal_contract_error]([contract_nbr] ASC, [account_number] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

