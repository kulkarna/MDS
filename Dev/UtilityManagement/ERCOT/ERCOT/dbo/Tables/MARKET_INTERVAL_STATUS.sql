CREATE TABLE [dbo].[MARKET_INTERVAL_STATUS] (
    [INTERVAL_DATA_ID] INT      NOT NULL,
    [TRANSACTION_DATE] DATETIME NULL,
    [STATUS001]        CHAR (1) NULL,
    [STATUS002]        CHAR (1) NULL,
    [STATUS003]        CHAR (1) NULL,
    [STATUS004]        CHAR (1) NULL,
    [STATUS005]        CHAR (1) NULL,
    [STATUS006]        CHAR (1) NULL,
    [STATUS007]        CHAR (1) NULL,
    [STATUS008]        CHAR (1) NULL,
    [STATUS009]        CHAR (1) NULL,
    [STATUS010]        CHAR (1) NULL,
    [STATUS011]        CHAR (1) NULL,
    [STATUS012]        CHAR (1) NULL,
    [STATUS013]        CHAR (1) NULL,
    [STATUS014]        CHAR (1) NULL,
    [STATUS015]        CHAR (1) NULL,
    [STATUS016]        CHAR (1) NULL,
    [STATUS017]        CHAR (1) NULL,
    [STATUS018]        CHAR (1) NULL,
    [STATUS019]        CHAR (1) NULL,
    [STATUS020]        CHAR (1) NULL,
    [STATUS021]        CHAR (1) NULL,
    [STATUS022]        CHAR (1) NULL,
    [STATUS023]        CHAR (1) NULL,
    [STATUS024]        CHAR (1) NULL,
    [STATUS025]        CHAR (1) NULL,
    [STATUS026]        CHAR (1) NULL,
    [STATUS027]        CHAR (1) NULL,
    [STATUS028]        CHAR (1) NULL,
    [STATUS029]        CHAR (1) NULL,
    [STATUS030]        CHAR (1) NULL,
    [STATUS031]        CHAR (1) NULL,
    [STATUS032]        CHAR (1) NULL,
    [STATUS033]        CHAR (1) NULL,
    [STATUS034]        CHAR (1) NULL,
    [STATUS035]        CHAR (1) NULL,
    [STATUS036]        CHAR (1) NULL,
    [STATUS037]        CHAR (1) NULL,
    [STATUS038]        CHAR (1) NULL,
    [STATUS039]        CHAR (1) NULL,
    [STATUS040]        CHAR (1) NULL,
    [STATUS041]        CHAR (1) NULL,
    [STATUS042]        CHAR (1) NULL,
    [STATUS043]        CHAR (1) NULL,
    [STATUS044]        CHAR (1) NULL,
    [STATUS045]        CHAR (1) NULL,
    [STATUS046]        CHAR (1) NULL,
    [STATUS047]        CHAR (1) NULL,
    [STATUS048]        CHAR (1) NULL,
    [STATUS049]        CHAR (1) NULL,
    [STATUS050]        CHAR (1) NULL,
    [STATUS051]        CHAR (1) NULL,
    [STATUS052]        CHAR (1) NULL,
    [STATUS053]        CHAR (1) NULL,
    [STATUS054]        CHAR (1) NULL,
    [STATUS055]        CHAR (1) NULL,
    [STATUS056]        CHAR (1) NULL,
    [STATUS057]        CHAR (1) NULL,
    [STATUS058]        CHAR (1) NULL,
    [STATUS059]        CHAR (1) NULL,
    [STATUS060]        CHAR (1) NULL,
    [STATUS061]        CHAR (1) NULL,
    [STATUS062]        CHAR (1) NULL,
    [STATUS063]        CHAR (1) NULL,
    [STATUS064]        CHAR (1) NULL,
    [STATUS065]        CHAR (1) NULL,
    [STATUS066]        CHAR (1) NULL,
    [STATUS067]        CHAR (1) NULL,
    [STATUS068]        CHAR (1) NULL,
    [STATUS069]        CHAR (1) NULL,
    [STATUS070]        CHAR (1) NULL,
    [STATUS071]        CHAR (1) NULL,
    [STATUS072]        CHAR (1) NULL,
    [STATUS073]        CHAR (1) NULL,
    [STATUS074]        CHAR (1) NULL,
    [STATUS075]        CHAR (1) NULL,
    [STATUS076]        CHAR (1) NULL,
    [STATUS077]        CHAR (1) NULL,
    [STATUS078]        CHAR (1) NULL,
    [STATUS079]        CHAR (1) NULL,
    [STATUS080]        CHAR (1) NULL,
    [STATUS081]        CHAR (1) NULL,
    [STATUS082]        CHAR (1) NULL,
    [STATUS083]        CHAR (1) NULL,
    [STATUS084]        CHAR (1) NULL,
    [STATUS085]        CHAR (1) NULL,
    [STATUS086]        CHAR (1) NULL,
    [STATUS087]        CHAR (1) NULL,
    [STATUS088]        CHAR (1) NULL,
    [STATUS089]        CHAR (1) NULL,
    [STATUS090]        CHAR (1) NULL,
    [STATUS091]        CHAR (1) NULL,
    [STATUS092]        CHAR (1) NULL,
    [STATUS093]        CHAR (1) NULL,
    [STATUS094]        CHAR (1) NULL,
    [STATUS095]        CHAR (1) NULL,
    [STATUS096]        CHAR (1) NULL,
    [STATUS097]        CHAR (1) NULL,
    [STATUS098]        CHAR (1) NULL,
    [STATUS099]        CHAR (1) NULL,
    [STATUS100]        CHAR (1) NULL,
    [LOG_ID]           INT      NULL,
    CONSTRAINT [PK_MRKTNTRVL9_15] PRIMARY KEY CLUSTERED ([INTERVAL_DATA_ID] ASC),
    CONSTRAINT [FK_MARKET_INTERVAL_STATUS_LOG_MARKET_PROCESSED] FOREIGN KEY ([LOG_ID]) REFERENCES [dbo].[LOG_MARKET_PROCESSED] ([ROW_ID]),
    CONSTRAINT [FK_MRKTNTRVL9_MRKTNTRVL913] FOREIGN KEY ([INTERVAL_DATA_ID]) REFERENCES [dbo].[MARKET_INTERVAL_DATA] ([INTERVAL_DATA_ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Contains status codes for the interval readings that make up the interval data cut.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'LINKS THIS TABLE TO THE MARKET_INTERVAL_DATA TABLE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'INTERVAL_DATA_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS001';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS002';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS003';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS004';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS005';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS006';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS007';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS008';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS009';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS010';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS011';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS012';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS013';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS014';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS015';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS016';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS017';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS018';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS019';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS020';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS021';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS022';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS023';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS024';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS025';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS026';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS027';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS028';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS029';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS030';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS031';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS032';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS033';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS034';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS035';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS036';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS037';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS038';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS039';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS040';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS041';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS042';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS043';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS044';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS045';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS046';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS047';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS048';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS049';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS050';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS051';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS052';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS053';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS054';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS055';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS056';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS057';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS058';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS059';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS060';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS061';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS062';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS063';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS064';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS065';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS066';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS067';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS068';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS069';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS070';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS071';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS072';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS073';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS074';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS075';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS076';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS077';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS078';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS079';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS080';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS081';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS082';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS083';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS084';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS085';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS086';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS087';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS088';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS089';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS090';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS091';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS092';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS093';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS094';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS095';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS096';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS097';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS098';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS099';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Status Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_STATUS', @level2type = N'COLUMN', @level2name = N'STATUS100';

