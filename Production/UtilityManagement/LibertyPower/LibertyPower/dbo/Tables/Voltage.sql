CREATE TABLE [dbo].[Voltage] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [VoltageCode] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Voltage] PRIMARY KEY CLUSTERED ([ID] ASC)
);

