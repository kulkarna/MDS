﻿CREATE TABLE [dbo].[INTERVAL_PROFILES] (
    [PROFILE_ID]     VARCHAR (50)    NOT NULL,
    [ERC_TRADE_DATE] DATETIME        NOT NULL,
    [INT001]         NUMERIC (10, 4) NULL,
    [INT002]         NUMERIC (10, 4) NULL,
    [INT003]         NUMERIC (10, 4) NULL,
    [INT004]         NUMERIC (10, 4) NULL,
    [INT005]         NUMERIC (10, 4) NULL,
    [INT006]         NUMERIC (10, 4) NULL,
    [INT007]         NUMERIC (10, 4) NULL,
    [INT008]         NUMERIC (10, 4) NULL,
    [INT009]         NUMERIC (10, 4) NULL,
    [INT010]         NUMERIC (10, 4) NULL,
    [INT011]         NUMERIC (10, 4) NULL,
    [INT012]         NUMERIC (10, 4) NULL,
    [INT013]         NUMERIC (10, 4) NULL,
    [INT014]         NUMERIC (10, 4) NULL,
    [INT015]         NUMERIC (10, 4) NULL,
    [INT016]         NUMERIC (10, 4) NULL,
    [INT017]         NUMERIC (10, 4) NULL,
    [INT018]         NUMERIC (10, 4) NULL,
    [INT019]         NUMERIC (10, 4) NULL,
    [INT020]         NUMERIC (10, 4) NULL,
    [INT021]         NUMERIC (10, 4) NULL,
    [INT022]         NUMERIC (10, 4) NULL,
    [INT023]         NUMERIC (10, 4) NULL,
    [INT024]         NUMERIC (10, 4) NULL,
    [INT025]         NUMERIC (10, 4) NULL,
    [INT026]         NUMERIC (10, 4) NULL,
    [INT027]         NUMERIC (10, 4) NULL,
    [INT028]         NUMERIC (10, 4) NULL,
    [INT029]         NUMERIC (10, 4) NULL,
    [INT030]         NUMERIC (10, 4) NULL,
    [INT031]         NUMERIC (10, 4) NULL,
    [INT032]         NUMERIC (10, 4) NULL,
    [INT033]         NUMERIC (10, 4) NULL,
    [INT034]         NUMERIC (10, 4) NULL,
    [INT035]         NUMERIC (10, 4) NULL,
    [INT036]         NUMERIC (10, 4) NULL,
    [INT037]         NUMERIC (10, 4) NULL,
    [INT038]         NUMERIC (10, 4) NULL,
    [INT039]         NUMERIC (10, 4) NULL,
    [INT040]         NUMERIC (10, 4) NULL,
    [INT041]         NUMERIC (10, 4) NULL,
    [INT042]         NUMERIC (10, 4) NULL,
    [INT043]         NUMERIC (10, 4) NULL,
    [INT044]         NUMERIC (10, 4) NULL,
    [INT045]         NUMERIC (10, 4) NULL,
    [INT046]         NUMERIC (10, 4) NULL,
    [INT047]         NUMERIC (10, 4) NULL,
    [INT048]         NUMERIC (10, 4) NULL,
    [INT049]         NUMERIC (10, 4) NULL,
    [INT050]         NUMERIC (10, 4) NULL,
    [INT051]         NUMERIC (10, 4) NULL,
    [INT052]         NUMERIC (10, 4) NULL,
    [INT053]         NUMERIC (10, 4) NULL,
    [INT054]         NUMERIC (10, 4) NULL,
    [INT055]         NUMERIC (10, 4) NULL,
    [INT056]         NUMERIC (10, 4) NULL,
    [INT057]         NUMERIC (10, 4) NULL,
    [INT058]         NUMERIC (10, 4) NULL,
    [INT059]         NUMERIC (10, 4) NULL,
    [INT060]         NUMERIC (10, 4) NULL,
    [INT061]         NUMERIC (10, 4) NULL,
    [INT062]         NUMERIC (10, 4) NULL,
    [INT063]         NUMERIC (10, 4) NULL,
    [INT064]         NUMERIC (10, 4) NULL,
    [INT065]         NUMERIC (10, 4) NULL,
    [INT066]         NUMERIC (10, 4) NULL,
    [INT067]         NUMERIC (10, 4) NULL,
    [INT068]         NUMERIC (10, 4) NULL,
    [INT069]         NUMERIC (10, 4) NULL,
    [INT070]         NUMERIC (10, 4) NULL,
    [INT071]         NUMERIC (10, 4) NULL,
    [INT072]         NUMERIC (10, 4) NULL,
    [INT073]         NUMERIC (10, 4) NULL,
    [INT074]         NUMERIC (10, 4) NULL,
    [INT075]         NUMERIC (10, 4) NULL,
    [INT076]         NUMERIC (10, 4) NULL,
    [INT077]         NUMERIC (10, 4) NULL,
    [INT078]         NUMERIC (10, 4) NULL,
    [INT079]         NUMERIC (10, 4) NULL,
    [INT080]         NUMERIC (10, 4) NULL,
    [INT081]         NUMERIC (10, 4) NULL,
    [INT082]         NUMERIC (10, 4) NULL,
    [INT083]         NUMERIC (10, 4) NULL,
    [INT084]         NUMERIC (10, 4) NULL,
    [INT085]         NUMERIC (10, 4) NULL,
    [INT086]         NUMERIC (10, 4) NULL,
    [INT087]         NUMERIC (10, 4) NULL,
    [INT088]         NUMERIC (10, 4) NULL,
    [INT089]         NUMERIC (10, 4) NULL,
    [INT090]         NUMERIC (10, 4) NULL,
    [INT091]         NUMERIC (10, 4) NULL,
    [INT092]         NUMERIC (10, 4) NULL,
    [INT093]         NUMERIC (10, 4) NULL,
    [INT094]         NUMERIC (10, 4) NULL,
    [INT095]         NUMERIC (10, 4) NULL,
    [INT096]         NUMERIC (10, 4) NULL,
    [INT097]         NUMERIC (10, 4) NULL,
    [INT098]         NUMERIC (10, 4) NULL,
    [INT099]         NUMERIC (10, 4) NULL,
    [INT100]         NUMERIC (10, 4) NULL,
    [DATE_CREATED]   DATETIME        CONSTRAINT [DF_INTERVAL_PROFILES_DATE_MODIFIED] DEFAULT (getdate()) NULL,
    [CREATED_BY]     VARCHAR (50)    NULL,
    CONSTRAINT [PK_INTERVAL_PROFILES] PRIMARY KEY CLUSTERED ([PROFILE_ID] ASC, [ERC_TRADE_DATE] ASC)
);
