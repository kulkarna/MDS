CREATE TABLE [dbo].[ProfilingQueue] (
    [ID]                        BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OfferID]                   VARCHAR (50)  NOT NULL,
    [Owner]                     VARCHAR (50)  NOT NULL,
    [Status]                    INT           CONSTRAINT [DF_ProfilingQueue_Status] DEFAULT ((0)) NOT NULL,
    [ModifiedBy]                VARCHAR (50)  NULL,
    [DateStarted]               DATETIME      NULL,
    [DateCompletedOrCanceled]   DATETIME      NULL,
    [ResultOutput]              VARCHAR (MAX) NULL,
    [NumberOfAccountsRemaining] INT           NULL,
    [NumberOfAccountsTotal]     INT           NULL,
    [CanceledBy]                VARCHAR (50)  NULL,
    [DateCreated]               DATETIME      CONSTRAINT [DF_ProfilingQueue_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ProfilingQueue] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (ALLOW_PAGE_LOCKS = OFF)
);


GO
CREATE NONCLUSTERED INDEX [ProfilingQueue__DateCompletedOrCanceled_I_Status]
    ON [dbo].[ProfilingQueue]([DateCompletedOrCanceled] ASC)
    INCLUDE([Status]) WITH (FILLFACTOR = 85, ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [ProfilingQueue__OfferID_I_Status]
    ON [dbo].[ProfilingQueue]([OfferID] ASC)
    INCLUDE([Status]) WITH (FILLFACTOR = 85, ALLOW_PAGE_LOCKS = OFF);

