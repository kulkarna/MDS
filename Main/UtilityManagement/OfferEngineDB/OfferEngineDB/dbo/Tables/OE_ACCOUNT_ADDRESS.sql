﻿CREATE TABLE [dbo].[OE_ACCOUNT_ADDRESS] (
    [OE_ACCOUNT_ID]  INT          NOT NULL,
    [ACCOUNT_NUMBER] VARCHAR (50) NOT NULL,
    [ADDRESS]        VARCHAR (50) NULL,
    [SUITE]          VARCHAR (50) NULL,
    [CITY]           VARCHAR (50) NULL,
    [STATE]          VARCHAR (50) NULL,
    [ZIP]            VARCHAR (25) NULL
);


GO
CREATE CLUSTERED INDEX [_dta_index_OE_ACCOUNT_ADDRESS_c_99_1646628909__K2]
    ON [dbo].[OE_ACCOUNT_ADDRESS]([ACCOUNT_NUMBER] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [NDX_Address]
    ON [dbo].[OE_ACCOUNT_ADDRESS]([OE_ACCOUNT_ID] ASC)
    INCLUDE([ADDRESS], [SUITE], [CITY], [STATE], [ZIP]) WITH (FILLFACTOR = 90);
