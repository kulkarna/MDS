﻿CREATE TABLE [dbo].[AD_ROLES] (
    [ROL_ID] NUMERIC (18) NOT NULL,
    [NAME]   VARCHAR (15) NOT NULL,
    CONSTRAINT [PK_ROLES] PRIMARY KEY CLUSTERED ([ROL_ID] ASC) WITH (FILLFACTOR = 90)
);
