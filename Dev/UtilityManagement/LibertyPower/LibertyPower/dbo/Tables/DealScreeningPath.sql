CREATE TABLE [dbo].[DealScreeningPath] (
    [DealScreeningPathID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]         VARCHAR (60) NULL,
    [DateCreated]         DATETIME     CONSTRAINT [DF_DealScreeningPath_DateCreated] DEFAULT (getdate()) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DealScreeningPath';

