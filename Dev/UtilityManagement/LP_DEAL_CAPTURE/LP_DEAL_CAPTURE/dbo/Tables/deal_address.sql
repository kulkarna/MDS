CREATE TABLE [dbo].[deal_address] (
    [contract_nbr] CHAR (12) NOT NULL,
    [address_link] INT       NOT NULL,
    [address]      CHAR (50) NOT NULL,
    [suite]        CHAR (50) NOT NULL,
    [city]         CHAR (50) NOT NULL,
    [state]        CHAR (2)  NOT NULL,
    [zip]          CHAR (10) NOT NULL,
    [county]       CHAR (10) NOT NULL,
    [state_fips]   CHAR (2)  NOT NULL,
    [county_fips]  CHAR (3)  NOT NULL,
    [chgstamp]     SMALLINT  NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [deal_address_idx]
    ON [dbo].[deal_address]([contract_nbr] ASC, [address_link] ASC);

