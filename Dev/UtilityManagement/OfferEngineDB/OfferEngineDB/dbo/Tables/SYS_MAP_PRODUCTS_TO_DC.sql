﻿CREATE TABLE [dbo].[SYS_MAP_PRODUCTS_TO_DC] (
    [PRODUCT]  VARCHAR (50) NOT NULL,
    [UTILITY]  VARCHAR (50) NOT NULL,
    [ID_IN_DC] VARCHAR (50) NOT NULL,
    [SEQUENCE] INT          CONSTRAINT [DF__SYS_MAP_P__SEQUE__5D95E53A] DEFAULT ((1)) NOT NULL,
    [TERM]     INT          NOT NULL
);

