CREATE TABLE [dbo].[LetterQueue] (
    [LetterQueueID]  INT          IDENTITY (1, 1) NOT NULL,
    [Status]         VARCHAR (20) NOT NULL,
    [ContractNumber] VARCHAR (12) NOT NULL,
    [AccountID]      INT          NOT NULL,
    [DocumentTypeID] INT          NOT NULL,
    [DateCreated]    DATETIME     NOT NULL,
    [ScheduledDate]  DATETIME     NULL,
    [PrintDate]      DATETIME     NULL,
    [Username]       VARCHAR (50) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [ndx_LetterQueueID]
    ON [dbo].[LetterQueue]([LetterQueueID] ASC) WITH (FILLFACTOR = 90);

