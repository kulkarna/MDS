CREATE TABLE [dbo].[MARKET_INTERVAL_DATA] (
    [INTERVAL_DATA_ID] INT             NOT NULL,
    [TRANSACTION_DATE] DATETIME        NULL,
    [TRADE_DATE]       DATETIME        NULL,
    [INT001]           DECIMAL (18, 6) NULL,
    [INT002]           DECIMAL (18, 6) NULL,
    [INT003]           DECIMAL (18, 6) NULL,
    [INT004]           DECIMAL (18, 6) NULL,
    [INT005]           DECIMAL (18, 6) NULL,
    [INT006]           DECIMAL (18, 6) NULL,
    [INT007]           DECIMAL (18, 6) NULL,
    [INT008]           DECIMAL (18, 6) NULL,
    [INT009]           DECIMAL (18, 6) NULL,
    [INT010]           DECIMAL (18, 6) NULL,
    [INT011]           DECIMAL (18, 6) NULL,
    [INT012]           DECIMAL (18, 6) NULL,
    [INT013]           DECIMAL (18, 6) NULL,
    [INT014]           DECIMAL (18, 6) NULL,
    [INT015]           DECIMAL (18, 6) NULL,
    [INT016]           DECIMAL (18, 6) NULL,
    [INT017]           DECIMAL (18, 6) NULL,
    [INT018]           DECIMAL (18, 6) NULL,
    [INT019]           DECIMAL (18, 6) NULL,
    [INT020]           DECIMAL (18, 6) NULL,
    [INT021]           DECIMAL (18, 6) NULL,
    [INT022]           DECIMAL (18, 6) NULL,
    [INT023]           DECIMAL (18, 6) NULL,
    [INT024]           DECIMAL (18, 6) NULL,
    [INT025]           DECIMAL (18, 6) NULL,
    [INT026]           DECIMAL (18, 6) NULL,
    [INT027]           DECIMAL (18, 6) NULL,
    [INT028]           DECIMAL (18, 6) NULL,
    [INT029]           DECIMAL (18, 6) NULL,
    [INT030]           DECIMAL (18, 6) NULL,
    [INT031]           DECIMAL (18, 6) NULL,
    [INT032]           DECIMAL (18, 6) NULL,
    [INT033]           DECIMAL (18, 6) NULL,
    [INT034]           DECIMAL (18, 6) NULL,
    [INT035]           DECIMAL (18, 6) NULL,
    [INT036]           DECIMAL (18, 6) NULL,
    [INT037]           DECIMAL (18, 6) NULL,
    [INT038]           DECIMAL (18, 6) NULL,
    [INT039]           DECIMAL (18, 6) NULL,
    [INT040]           DECIMAL (18, 6) NULL,
    [INT041]           DECIMAL (18, 6) NULL,
    [INT042]           DECIMAL (18, 6) NULL,
    [INT043]           DECIMAL (18, 6) NULL,
    [INT044]           DECIMAL (18, 6) NULL,
    [INT045]           DECIMAL (18, 6) NULL,
    [INT046]           DECIMAL (18, 6) NULL,
    [INT047]           DECIMAL (18, 6) NULL,
    [INT048]           DECIMAL (18, 6) NULL,
    [INT049]           DECIMAL (18, 6) NULL,
    [INT050]           DECIMAL (18, 6) NULL,
    [INT051]           DECIMAL (18, 6) NULL,
    [INT052]           DECIMAL (18, 6) NULL,
    [INT053]           DECIMAL (18, 6) NULL,
    [INT054]           DECIMAL (18, 6) NULL,
    [INT055]           DECIMAL (18, 6) NULL,
    [INT056]           DECIMAL (18, 6) NULL,
    [INT057]           DECIMAL (18, 6) NULL,
    [INT058]           DECIMAL (18, 6) NULL,
    [INT059]           DECIMAL (18, 6) NULL,
    [INT060]           DECIMAL (18, 6) NULL,
    [INT061]           DECIMAL (18, 6) NULL,
    [INT062]           DECIMAL (18, 6) NULL,
    [INT063]           DECIMAL (18, 6) NULL,
    [INT064]           DECIMAL (18, 6) NULL,
    [INT065]           DECIMAL (18, 6) NULL,
    [INT066]           DECIMAL (18, 6) NULL,
    [INT067]           DECIMAL (18, 6) NULL,
    [INT068]           DECIMAL (18, 6) NULL,
    [INT069]           DECIMAL (18, 6) NULL,
    [INT070]           DECIMAL (18, 6) NULL,
    [INT071]           DECIMAL (18, 6) NULL,
    [INT072]           DECIMAL (18, 6) NULL,
    [INT073]           DECIMAL (18, 6) NULL,
    [INT074]           DECIMAL (18, 6) NULL,
    [INT075]           DECIMAL (18, 6) NULL,
    [INT076]           DECIMAL (18, 6) NULL,
    [INT077]           DECIMAL (18, 6) NULL,
    [INT078]           DECIMAL (18, 6) NULL,
    [INT079]           DECIMAL (18, 6) NULL,
    [INT080]           DECIMAL (18, 6) NULL,
    [INT081]           DECIMAL (18, 6) NULL,
    [INT082]           DECIMAL (18, 6) NULL,
    [INT083]           DECIMAL (18, 6) NULL,
    [INT084]           DECIMAL (18, 6) NULL,
    [INT085]           DECIMAL (18, 6) NULL,
    [INT086]           DECIMAL (18, 6) NULL,
    [INT087]           DECIMAL (18, 6) NULL,
    [INT088]           DECIMAL (18, 6) NULL,
    [INT089]           DECIMAL (18, 6) NULL,
    [INT090]           DECIMAL (18, 6) NULL,
    [INT091]           DECIMAL (18, 6) NULL,
    [INT092]           DECIMAL (18, 6) NULL,
    [INT093]           DECIMAL (18, 6) NULL,
    [INT094]           DECIMAL (18, 6) NULL,
    [INT095]           DECIMAL (18, 6) NULL,
    [INT096]           DECIMAL (18, 6) NULL,
    [INT097]           DECIMAL (18, 6) NULL,
    [INT098]           DECIMAL (18, 6) NULL,
    [INT099]           DECIMAL (18, 6) NULL,
    [INT100]           DECIMAL (18, 6) NULL,
    [LOG_ID]           INT             NULL,
    CONSTRAINT [PK_MRKTNTRVL9_13] PRIMARY KEY CLUSTERED ([INTERVAL_DATA_ID] ASC),
    CONSTRAINT [FK_MARKET_INTERVAL_DATA_LOG_MARKET_PROCESSED] FOREIGN KEY ([LOG_ID]) REFERENCES [dbo].[LOG_MARKET_PROCESSED] ([ROW_ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Contains data values for the interval readings that make up the interval data cut.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'LINKS THIS TABLE WITH THE MARKET_INTERVAL_HEADER TABLE.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INTERVAL_DATA_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES THE DATETIME AND TIME WHEN A RECORD WAS ADDED', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'THE MARKET TRADE DATETIME FOR WHICH THE INTERVAL DATA APPLIES.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'TRADE_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT001';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT002';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT003';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT004';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT005';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT006';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT007';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT008';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT009';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT010';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT011';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT012';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT013';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT014';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT015';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT016';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT017';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT018';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT019';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT020';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT021';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT022';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT023';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT024';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT025';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT026';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT027';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT028';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT029';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT030';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT031';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT032';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT033';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT034';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT035';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT036';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT037';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT038';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT039';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT040';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT041';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT042';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT043';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT044';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT045';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT046';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT047';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT048';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT049';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT050';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT051';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT052';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT053';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT054';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT055';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT056';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT057';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT058';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT059';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT060';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT061';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT062';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT063';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT064';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT065';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT066';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT067';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT068';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT069';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT070';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT071';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT072';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT073';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT074';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT075';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT076';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT077';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT078';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT079';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT080';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT081';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT082';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT083';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT084';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT085';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT086';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT087';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT088';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT089';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT090';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT091';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT092';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT093';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT094';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT095';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT096';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT097';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT098';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT099';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Interval Reading', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_DATA', @level2type = N'COLUMN', @level2name = N'INT100';

