CREATE TABLE [dbo].[ProfilingHedgeBlock] (
    [ID]                 INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProfilingQueueID]   INT            NOT NULL,
    [HedgeBlockFileName] NVARCHAR (128) NOT NULL,
    [HedgeBlockContents] NVARCHAR (MAX) NOT NULL,
    [DateCreated]        DATETIME       CONSTRAINT [DF_ProfilingHedgeBlocks_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ProfilingHedgeBlock] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (ALLOW_PAGE_LOCKS = OFF)
);


GO
CREATE CLUSTERED INDEX [ProfilingHedgeBlock__ProfilingQueueID]
    ON [dbo].[ProfilingHedgeBlock]([ProfilingQueueID] ASC) WITH (FILLFACTOR = 85, ALLOW_PAGE_LOCKS = OFF);

