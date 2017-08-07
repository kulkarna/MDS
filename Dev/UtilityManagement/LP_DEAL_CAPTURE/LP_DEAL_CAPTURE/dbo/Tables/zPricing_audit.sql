CREATE TABLE [dbo].[zPricing_audit] (
    [product_id]    VARCHAR (100) NULL,
    [rate_id]       INT           NULL,
    [product_rate]  FLOAT (53)    NULL,
    [rate]          FLOAT (53)    NULL,
    [comm_cap]      FLOAT (53)    NULL,
    [contract_date] DATETIME      NULL,
    [insert_date]   DATETIME      NULL
);

