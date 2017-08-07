CREATE TABLE [dbo].[TaskType] (
    [TaskTypeID]  INT           IDENTITY (1, 1) NOT NULL,
    [TaskName]    VARCHAR (100) NOT NULL,
    [IsActive]    BIT           NOT NULL,
    [IsDeleted]   BIT           NULL,
    [CreatedBy]   NVARCHAR (50) NULL,
    [DateCreated] DATETIME      NULL,
    [UpdatedBy]   NVARCHAR (50) NULL,
    [DateUpdated] DATETIME      NULL,
    CONSTRAINT [PK_TaskType] PRIMARY KEY CLUSTERED ([TaskTypeID] ASC)
);

