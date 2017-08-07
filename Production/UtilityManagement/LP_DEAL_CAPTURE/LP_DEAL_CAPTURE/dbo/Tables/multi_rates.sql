CREATE TABLE [dbo].[multi_rates] (
    [contract_nbr]  CHAR (12)    NOT NULL,
    [utility_id]    CHAR (15)    NOT NULL,
    [utility_descp] VARCHAR (50) NOT NULL,
    [product_id]    CHAR (20)    NOT NULL,
    [product_descp] VARCHAR (50) NOT NULL,
    [rate_id]       INT          NOT NULL,
    [rate]          FLOAT (53)   NOT NULL,
    [rate_descp]    VARCHAR (50) NOT NULL
);

