CREATE TABLE [dbo].[OE_SERVICE_LOG] (
    [Id]        INT              IDENTITY (1, 1) NOT NULL,
    [Guid]      UNIQUEIDENTIFIER NOT NULL,
    [Action]    VARCHAR (500)    NOT NULL,
    [Ip]        VARCHAR (39)     NULL,
    [Timestamp] DATETIME         CONSTRAINT [DF_OE_SERVICE_LOG_Timestamp] DEFAULT (getdate()) NULL,
    [Message]   XML              NULL,
    CONSTRAINT [PK_OE_SERVICE_LOG_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

