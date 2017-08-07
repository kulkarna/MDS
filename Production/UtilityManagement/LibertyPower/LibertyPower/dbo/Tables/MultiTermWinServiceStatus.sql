CREATE TABLE [dbo].[MultiTermWinServiceStatus] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (50)  NOT NULL,
    [Description]  NVARCHAR (100) NULL,
    [DateCreated]  DATETIME       CONSTRAINT [DF_ServiceProcessStatus_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    INT            NOT NULL,
    [DateModified] DATETIME       NULL,
    [ModifiedBy]   INT            NULL,
    CONSTRAINT [PK_ServiceProcessStatus] PRIMARY KEY CLUSTERED ([Id] ASC)
);

