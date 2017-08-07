CREATE TABLE [dbo].[deal_contract_batch] (
    [request_id]    VARCHAR (50) NOT NULL,
    [contract_nbr]  VARCHAR (15) NOT NULL,
    [contract_type] VARCHAR (15) NOT NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [deal_contract_batch_idx]
    ON [dbo].[deal_contract_batch]([request_id] ASC, [contract_nbr] ASC, [contract_type] ASC);


GO
CREATE NONCLUSTERED INDEX [deal_contract_batch_idx2]
    ON [dbo].[deal_contract_batch]([request_id] ASC, [contract_type] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

