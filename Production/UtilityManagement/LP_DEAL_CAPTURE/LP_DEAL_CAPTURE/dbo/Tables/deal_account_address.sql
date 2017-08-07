CREATE TABLE [dbo].[deal_account_address] (
    [account_id]   CHAR (12) NOT NULL,
    [address_link] INT       NOT NULL,
    [address]      CHAR (50) NOT NULL,
    [suite]        CHAR (10) NOT NULL,
    [city]         CHAR (28) NOT NULL,
    [state]        CHAR (2)  NOT NULL,
    [zip]          CHAR (10) NOT NULL,
    [county]       CHAR (10) NOT NULL,
    [state_fips]   CHAR (2)  NOT NULL,
    [county_fips]  CHAR (3)  NOT NULL,
    [chgstamp]     SMALLINT  NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [NDX_deal_account_address_account_id_address_link]
    ON [dbo].[deal_account_address]([account_id] ASC, [address_link] ASC);

