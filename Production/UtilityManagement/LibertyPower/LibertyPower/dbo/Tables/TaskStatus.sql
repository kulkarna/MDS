CREATE TABLE [dbo].[TaskStatus] (
    [TaskStatusID] INT           IDENTITY (1, 1) NOT NULL,
    [StatusName]   NVARCHAR (50) NOT NULL,
    [IsActive]     BIT           NOT NULL,
    [IsDeleted]    BIT           NULL,
    [CreatedBy]    NVARCHAR (50) NULL,
    [DateCreated]  DATETIME      NULL,
    [UpdatedBy]    NVARCHAR (50) NULL,
    [DateUpdated]  DATETIME      NULL,
    CONSTRAINT [PK_TaskStatus] PRIMARY KEY CLUSTERED ([TaskStatusID] ASC)
);

