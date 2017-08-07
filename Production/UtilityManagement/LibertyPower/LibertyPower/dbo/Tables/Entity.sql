CREATE TABLE [dbo].[Entity] (
    [EntityID]     INT          IDENTITY (1, 1) NOT NULL,
    [EntityType]   CHAR (1)     NOT NULL,
    [DateCreated]  DATETIME     CONSTRAINT [DF_Entity_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    INT          CONSTRAINT [DF_Entity_CreatedBy] DEFAULT ((1)) NOT NULL,
    [ModifiedBy]   INT          CONSTRAINT [DF__Entity__Modified__0FD74C44] DEFAULT ((1)) NULL,
    [DateModified] DATETIME     CONSTRAINT [DF__Entity__DateModi__10CB707D] DEFAULT (getdate()) NOT NULL,
    [Tag]          VARCHAR (50) CONSTRAINT [DF__Entity__Tag__6C5905DD] DEFAULT ('') NOT NULL,
    [StartDate]    DATETIME     NULL,
    CONSTRAINT [PK_Entity] PRIMARY KEY CLUSTERED ([EntityID] ASC) WITH (FILLFACTOR = 90)
);

