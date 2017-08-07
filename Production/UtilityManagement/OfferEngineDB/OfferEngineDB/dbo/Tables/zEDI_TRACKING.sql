CREATE TABLE [dbo].[zEDI_TRACKING] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [loop]           VARCHAR (MAX) NULL,
    [row_count]      INT           NULL,
    [account_number] VARCHAR (50)  NULL,
    [date_insert]    DATETIME      CONSTRAINT [DF_EDI_TRACKING_date_insert] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EDI_TRACKING] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

