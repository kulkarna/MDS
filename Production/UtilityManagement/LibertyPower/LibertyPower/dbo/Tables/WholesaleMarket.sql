CREATE TABLE [dbo].[WholesaleMarket] (
    [ID]                INT          IDENTITY (1, 1) NOT NULL,
    [WholesaleMktId]    CHAR (10)    NOT NULL,
    [WholesaleMktDescp] VARCHAR (50) NOT NULL,
    [DateCreated]       DATETIME     NOT NULL,
    [Username]          NCHAR (100)  NOT NULL,
    [InactiveInd]       CHAR (1)     NOT NULL,
    [ActiveDate]        DATETIME     NOT NULL,
    [Chgstamp]          SMALLINT     NOT NULL,
    CONSTRAINT [PK_WholesaleMarket] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

